# PORTPORTPORT
Simple, dumb, works in bash and zsh, PORTPORTPORT provides three tools:
1. `isport` which lets you query whether a port is commonly used for a purpose.
2. `whatport` which lets you query what ports a service commonly uses.
3. `portportport` which dumps the entire known mapping of ports to services to stdout for your own convenience.


# Goals
- be able to query for ports used by specific programs
- be able to query programs that use a specific port
- have a portable output that can be used for more complex queries

# Stretch goals
- Maintain a unique, user defined port list.
- query for what ports are occupied on the users machine and store them for future reference
- be able to update port map without relying on repo/reinstall
- byob - bring your own backend. i.e. use rg instead of grep

# Non-goals
- no side-effects outside install location
- provide downstream guarantees or support
- be anything but a tool for personal use

# Runtime Requirements
bash, version TBD, or some bashwards compatible shell like zsh.
maybe JQ, depends on how hard this actually is, and whether jq queries are faster
grep

# Build requirements
bash
jq
curl
miller cli
either htmlq or xidel, maybe, not sure.
