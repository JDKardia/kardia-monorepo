# Pshtman

Have you ever wanted a low dependency, low resource, easily configurable, dumb easy way
to curl a pre described set of endpoints without having to hack together a suite of curl
scripts? No? I'm alone in this? shit. Well here we are anyway because a friend nerd sniped me and I said I could do it.

## Dependencies

short and simple:

- bash
- jq
- curl

why no versions? I'm not taking advantage of anything particularly special, I'd be shocked
if you could find a modern machine with installs of those three tools that couldn't run this.

## Configuration

configs will be loaded in order from

```
.pshtman.json
.pshtman.d/*.json # NOT IMPLEMENTED
.config/pshtman.json # NOT IMPLEMENTED
.config/pshtman.d/*.json # NOT IMPLEMENTED
```

## Usage

```bash
$ post endpoint-name ENV_VAR_I_WANT_TO_CHANGE=100 __DATA='{"test":"test"}'
posting to SOME ENDPOINT HERE WITH EXAMPLE OF ENV VAR BEING REPLACED WITH BODY
{
  "test": "test"
}
response:
```

## Goals

- be a pure, supreme cli experience.
- Configuration for endpoints and rest methods that can be picked up by just looking at
  a valid config file
- low dependency, but not dumbly so. I'm not doing all of this in bash, i'm also going to use `jq`, the best json cli tool.
- basic caching to keep start up time low
- the only latency we should experience should be from the call being made itself
- completion should guide users in usage, not just speeding up power users
- pretty print what can be printed prettily

## Non-Goals

- posix compliance
- Render HTML
- have a gui/tui
- act as documentation
- have more than one config destination

## Future features

1. Something, I dunno, this isn't even working yet.
2. xdg-desktop compliance
