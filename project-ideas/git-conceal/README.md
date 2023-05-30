# `git-conceal`
inspired directly by https://github.com/higgins/privatize

# Why reinvent someone else's wheel
i really like the idea of privatize, but it has 3 major issues for me:
1. It doesn't play within git itself, it's called via `private COMMAND`not `git privatize COMMAND` as I would expect a tool that is focused on improving a pain point with git to integrate with it seamlessly.
2. It uses Javascript, specifically Node.JS. Having node as a dependency for one of my key workflows is a huge no, it's not often installed on my machines, and I can't rely on it being present, i need a tool like this to *just work*.
3. It requires HEREDOC syntax. This doesn't play ball with a number of the usecases I can think of wanting this for, I'd like much more finegrained control over my encryption delimiters

## Goals
These are the core driving purpose of this project, work that deviates course from these tenets should not be committed:
1. Encrypt text similar to `git-crypt` and `privatize` where delimited
1. Encryption should use sane defaults that provide actual security without compromising user experience.
2. Allow custom delimiters, not just HEREDOC syntax or entire files
3. Bulk of the code should be as close to POSIX compliant as possible
4. Non-Posix code should be in a bash compatible syntax, utilizing as few bash-isms as possible to maintain compatibility
5. any non shell dependencies should be ubiquitous on linux
6. well documented and understandable tests should be present for people to validate that `git-conceal` works on a machine before install
7. Interface and commands should be fast to execute, intuitive to understand, well documented, and designed to prevent leakage of sensitive details into git history

### Stretch Goals
These aren't a priority, but would be nice to have
1. Allow custom start and end delimiters, i.e. allow encrypted blocks to have different opening and closing symbols/phrases
3. All code is as close to POSIX compliant as possible, i.e. no non-POSIX
4. Non-Posix code should be in a bash compatible syntax, utilizing as few bash-isms as possible to maintain compatibility
5. any non shell dependencies should be ubiquitous on both linux and latest MacOs
5. Framework for attacking and verifying security of `git-conceal` on your own machine is present in repo to provide peace of mind and feedback to the project
6. Clear code of conduct and contribution guidelines

## Non Goals
These are objectives I'm not interested in pursuing with this project
1. Implementation in non shell languages/anything that needs compilation
2. Providing guarantees to users beyond making it available for use. I'll try to be a good steward, but I'm human and have a life beyond code.
