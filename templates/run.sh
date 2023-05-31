#!/usr/bin/env bash
# shellcheck disable=SC2317,SC2181
# ignored due to indirect invocation
#   -> SC2317 - Command appears to be unreachable
# ignored for readability purposes
#   -> SC2181 - Check exit code directly with 'if mycmd;' not indirectly with '$?'.
set -o nounset
set -o pipefail
set -o errexit
IFS=$'\n\t'
# TEMPLATE NOTES:
#   This should be placed at the root of a project directory, as setup uses that context for all subsequent commands

# Usage:
#   ./run.sh <function name>
# try `./run.sh help` for more detailed instructions

# This script uses the $0 dispatch pattern to create a swiss army knife script
# that can be easily be extended and chained with itself and other scripts.
# for more specific details, see this section in a post by Andy Chu of OSH
# https://www.oilshell.org/blog/2020/02/good-parts-sketch.html#the-0-dispatch-pattern-solves-three-important-problems

PROJECT_PATH="$( cd "$(dirname "$0")" && pwd -P)"
PROJECT_NAME="$( basename "$PROJECT_PATH")"
REPO_PATH="$( cd "$PROJECT_PATH/.." && pwd -P)"
BAZEL="$REPO_PATH/bazel"
GOCTL="$REPO_PATH/bin/goctl"

help() {
	# usage information {{{
	cat <<USAGEDOC
run.sh:
  A script to document common operations and simplify their execution, allowing chaining of commands

Usage:
  ./run.sh <command-1> ... <command-n>
  where execution of commands occurs in order from 1 to n

Commands:
  'help'     - show this menu. every function that supports subcommands will have its own help sub-command
  'sync'     - sync repo to devbox
  'proto'    - regenerate protobufs for $PROJECT_NAME
  'build'    - run bazel builds for $PROJECT_NAME
  'start'    - start the most recently built binary of $PROJECT_NAME"
  'tests'    - run tests via bazel for $PROJECT_NAME
  'format'   - format go files in $PROJECT_NAME
  'gazelle'  - regenerate BUILD.bazel files in $PROJECT_NAME
  'setup-pre-commit' - install pre-commit hooks from $REPO_PATH

Helper Commands:
  'rerun'       - automatically re-run commands on certain file changes
  'text-header' - emits a header containing the value in the first argument passed to it.
  'time-header' - same as text-header, but with a timestamp appended to the first argument.
  'for-project' - changes to different project within $REPO_PATH
  'on-remote'   - execute following commands via run.sh on a remote box.
  'background'  - run quietly in the background,

Pre-Composed Commands
  'local-dev'     - runs gazelle, generates protobufs, builds, and tests on relevant changes
  'local-worker'  - syncs to devbox, runs gazelle, and generates protobufs on relevant changes.
  'remote-worker' - sshes into devbox and then builds, tests, and runs project on pushed changes.

USAGEDOC
	exit
	# }}}
}

# Commands {{{
sync()  {
	cd "$REPO_PATH" || exit
	pay sync .
	"$@"
}

setup-pre-commit() {
	cp "$REPO_PATH/tools/pre-commit" "$REPO_PATH/.git/hooks"
}

build()  {
	cd "$REPO_PATH" || exit
	$BAZEL build "$PROJECT_NAME/$PROJECT_NAME"
	"$@"
}

proto()  {
	cd "$REPO_PATH" || exit
	./bin/syncgenerated -targets "//$PROJECT_NAME/..."
	"$@"
}

start()  {
	cd "$REPO_PATH" || exit
	"./bazel-bin/$PROJECT_NAME/${PROJECT_NAME}_/$PROJECT_NAME" \
		--http-address localhost:8507 \
		--debug-address localhost:8586 \
		--consul-address unix:///pay/consul/consul-agent.sock
	"$@"
}

tests()      {
	cd "$REPO_PATH" || exit
	$BAZEL test --test_output=errors "//$PROJECT_NAME/..."
	"$@"
}

format()      {
	cd "$REPO_PATH" || exit
	./bin/goimports "$PROJECT_NAME"
	"$@"
}

gazelle()      {
	cd "$REPO_PATH" || exit
	./bin/gocode-gazelle "$PROJECT_PATH"
	sleep 0.1
	"$@"
}
# }}}

# Helper Commands {{{
text-header()      {
	local content clen
	content="$1"
	clen=${#content}
	printf "\e[1;7m  %${clen}s  \n" ' '
	printf "  %s  \n" "$content"
	printf "  %${clen}s  \e[0m\n" ' ' | sed 's/ /▁/g'
	shift
	"$@"
}

time-header()    {
	local content clen
	content="$1"
	shift
	text-header "${content}: $(date -Iseconds)"
	"$@"
}

for-project() {
	local project="$1"
	shift
	export PROJECT_NAME="$project"
	export PROJECT_PATH="$REPO_PATH/$PROJECT_NAME"
	("$@")
}

on-remote() {
	[[ $PWD == "$REPO_PATH" ]] && cd "$REPO_PATH" || exit
	# run further commands on devbox in tmux session with session name 'remote-worker'
	pay ssh --force-tty tmux new -A -s "remote-worker" "./run.sh" "$@"
	# no chaining here as we continue composition on remote host
}

background() {
	local
	to_background="$1"
	shift
	{
		"$to_background"
	} &
	"$@"
}

rerun()  {
	# rerun subcommands {{{
	command -v entr >/dev/null || {
		echo 'please install entr to use rerun functionality.'
		exit
	}
	cd "$PROJECT_PATH" || exit
	help() {
		# rerun command usage information {{{
		cat <<USAGEDOC
    run.sh rerun:
    Watch relevant files, and when they change restart/rerun given commands.
    To avoid looping, try to avoid triggering reruns for commands on changes to files they modify.

    Usage:
    ./run.sh rerun <sub-command> <commands>

    Dependencies:
    requires the 'entr' binary

    Sub-Command:
    'help' - show this menu
    'on-all'       - rerun on changes to all files in $PROJECT_NAME
    'on-buildable' - rerun on changes to go and bazel files in $PROJECT_NAME
    'on-testable'  - rerun on changes to go, yaml, and bazel files in $PROJECT_NAME
    'on-proto'     - rerun on changes to protobuf definitions in $PROJECT_NAME
    'on-runnable'  - rerun on changes to go, yaml, bazel or binary files in $PROJECT_NAME
    example: ./run.sh rerun on-testable tests with-header
USAGEDOC
		exit
		# }}}
	}
	__watch-dispatch() {
		# generalized watching functionality for fileextensions{{{
		local patterns pat to_dispatch
		patterns="$1"
		# splitting to avoid system dependent find behavior
		IFS='|' read -ra patterns < <(echo "$1") && shift
		# splitting so we can dispatch correctly
		IFS=' ' read -ra to_dispatch < <(echo "$@")

		# set +o errexit # we want to rerun things even if there are errors
		while true; do
			{
				for pat in "${patterns[@]}"; do
					find "$PROJECT_PATH" -regex "$pat"
				done
			} | entr -d "$0" "${to_dispatch[@]}"
			[[ $? == 0 ]] && exit # exit if entr received SIGINT
		done
		# }}}
	}
	on-buildable() {
		__watch-dispatch '.*\.go|.*\.bzl|.*\.bazel' "$@"
	}
	on-testable() {
		__watch-dispatch '.*\.go|.*\.yml|.*\.yaml|.*\.bzl|.*\.bazel' "$@"
	}
	on-proto() {
		__watch-dispatch '.*\.proto' "$@"
	}

	on-binary() {
		# note the extra flag for entr, this will cause restarts mid-execution
		# meaning commands that change files will cause this to infinitely loop
		while true; do
			find bazel-bin -follow -regex ".*$PROJECT_NAME.*" | entr -rdc "$0" "$@"
			[[ $? == 0 ]] && exit
		done
	}
	on-runnable() {
		# note the extra flag for entr, this will cause restarts mid-execution
		# meaning commands that change files will cause this to infinitely loop
		while true; do
			{
				echo "$REPO_PATH/bazel-bin/$PROJECT_NAME/${PROJECT_NAME}_/$PROJECT_NAME"
			} | entr -rdc "$0" "$@"
			[[ $? == 0 ]] && exit
		done
	}
	on-all() {
		# note the extra flag for entr, this will cause restarts mid-execution
		# meaning commands that change files could cause this to infinitely loop
		while true; do
			{
				echo "$REPO_PATH/bazel-bin/$PROJECT_NAME/${PROJECT_NAME}_/$PROJECT_NAME"
				find "$PROJECT_PATH" -regex '.*\.go'
				find "$PROJECT_PATH" -regex '.*\.bzl'
				find "$PROJECT_PATH" -regex '.*\.bazel'
				find "$PROJECT_PATH" -regex '.*\.yml'
				find "$PROJECT_PATH" -regex '.*\.yaml'
			} | entr -rdc "$0" "$@"
			[[ $? == 0 ]] && exit
		done
	}

	command -v entr >/dev/null || {
		echo "please run 'brew install entr' in order to use the rerun command"
		exit
	}
	"$@"
	# }}}
}
# }}}

# pre-composed commands {{{
local-dev() {
	# {{{
	[[ $PWD == "$PROJECT_PATH" ]] && cd "$REPO_PATH" || exit
	# handles proto and gazelle for us, but also don't want to fail if its already running
	"$GOCTL" watch || true
	rerun on-buildable \
		time-header 'Build' build \
		time-header 'Tests' tests \
		time-header 'Start' start \
		"$@"
	# }}}
}

local-worker() {
	# {{{
	[[ $PWD == "$REPO_PATH" ]] && cd "$REPO_PATH" || exit
	background sync \
		rerun on-buildable \
		time-header 'Gazelle' gazelle \
		time-header 'Proto' proto
	"$@"
	# }}}
}

remote-worker() {
	# {{{
	if [[ -z ${PROJECT_NAME:-""} ]]; then
		# set $PROJECT_NAME if not set already
		local project="$1"
		shift
		for-project "$project" \
			remote-worker \
			"$@"
	else
		on-remote \
			for-project "$PROJECT_NAME" \
			rerun on-buildable \
			time-header 'Build' build \
			time-header 'Tests' tests \
			time-header 'Start' start \
			"$@"
	fi
	# }}}
}
# }}}

"$@"
