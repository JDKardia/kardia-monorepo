# Much-To-Do-About-Nothing

Where I put all the things I THINK I want to do and some relevant research, plans,
directions to go with them.

## Code Art/Fun projects

### Generative 3d Star Map

Create a 3d traversable universe, with systems, planets, stars, nebulas, and other shit
that you can zoom in and 'visit'. Names and descriptions that are generated, eventually
a persistent version from a seed maybe, that way maybe it can be used as a tool for
writing/creating games.

### Word Shape Dictionary

create a dictionary/database that maps words to shapes that are useful when working with
english. This could be speaking, writing prose, poetry, etc.
possible shapes:

- inflection
- semantic connotations
- definitions
- word type (verb, adverb)
- sounds/rhyming

Goal is to create a data set to inform and generate textual content for fun

### Random Phrase generator ala michael fogleman

variable length phrase generator that focuses on grammatical combinations and
pseudo-correct sentences/fragments. Generates based on pentameters and inflections as
well, goal is to create phrases and words that flow well.

### Poetry/Sonnet generator

Tied into the above generator, create sentences and lines and stanzas and verses that
should flow if not make sense. Perhaps provide an existing sonnet or song and it
replaces the words with similar emphasis and syllable count words so it flows the same
but is totally different.

## Software Engineering Projects

### Shell Degit

degit is an npm thing, what if I could convert it over to shell or something that can
become a super lightweight cli tool.

### Item organization, categorization, and tracking tool

searchable database, allows metadata and other tagging, allows mapping to locations on a
map or a provided picture, allows for instructions, pictures, expiration dates, plugin
extension via HTML/CSS/JS or Svelte Components or something like that, and drag/drop:
recategorization, metadata layout, labeling, and more. Want a visual personal database.
provide multiple keys with which to identify unique items or groups of items.

A wishlist/want functionality would be nice. A queue of items to get and their price.

attach receipts for items for insurance and tracking purposes?

could bloat into ultimate personal life tracker. May not be bad bloat, but would want to
make sure everything is composable, not monolithic. plugins via code dependency or by
container spinup? Both? ¯\\\_(ツ)\_/¯

### Personal Website/Resume/Links to personal projects

A place where I can showcase Myself, my projects, my interests, all of that. Put myself
forward online and let people see what I want them too.
auto-protect against link-rot
multiple site versions built in react, Svelte, preact, or whatever for fun.
Make Copy and structure less hardcoded if possible, defined via JSON or Yaml or some
other config to make updating it easier.
Or maybe that's the blog part of it, whatever, the site itself will be a repo or 3. just
itself? ugh, who knows.

### Cutlist generator

come up with several algorithms and heuristics that allow for the creation of a cutlist
and then renders that out for a user. Ideally use some form of genetic algorithm or
simulated annealing to permute cutlists, allow for constraints and other requirements,
pick between board slicing, or plywood segmentation, optimization settings for
guillotine cutting, space, wood grain, kerf, finish passes, dimensioning, etc.

### CI/CD Serverless app

Create a composable set of scripts and commands that get pulled together into scripts
for CI/CD pipelines. Think like a very abstract compiler that takes a declarative list
of actions and then performs them by linking together scripts that work well in a
serverless environment. Ideally all in the same language, and optimizations are made
during compile to reduce errors and increase buildtime. Could be local tool that
updates a static-site and aws lambda functions, could be a dynamic site that does
that, could be a static site that modifies itself and is entirely serverless, even
during compilation. Probably want this to be open-source after I play withit.
hat

### Dependency Graph Generator / Code analysis tool.

Tool that generates dependency graphs and information about a codebase and it's
orthogonality by either pointing it at Repos, a local file directory, or uploading a
zip.

Could be fun to do the work myself, start with one language, try and create a
generalizable program around that. Could be a good time to put the Compose-not-inherit
money where my mouth is.

### Team Planning suite?

Not a genuine single project, but I've got a project planner, a code analysis tool, a
CI/CD idea, and a hosted coding server idea in here. only a Chat app would be necessary
to put it all in one big planning suite. Though frankly, The better way to do it would
be something like the project planner, the ci/cd tool, and then integrate with slack and
other services to let other things deal with it. OR, OR, OR, I could do a code analysis
tool that shows test coverage, integration coverage, and orthogonality between services
and systems. that could be cool. a lot, but cool

### Multi-website Wishlist/Cart app

add items and compare across sites and costs, add up total, suggest alternatives, and
allow you to checkout/consolidate purchases.

### FForest

A fandom first blogging platform with robust tagging and organizational features across
multiple blogs and tag-groups. Tree metaphor blogging structure where posts are
connected and rendered via a graph and posts are immutable once created, but can be
edited and marked up. and a history of that is maintained.

## DevOps and scripting Projects

### Personal Deployment Configs

a private repo dedicated to my own ops scripts/secrets/and other things necessary to
automate and ease the deployment of my own sites and tools.

Maybe personal machines and also for webserver setup.

### Setup NixOS env for fun and profit

Really robust package manager, could homogenize configs across linux and mac, look into
Nix Store for Dot files, could really just set me and my desktop environments up with
one or two configs. 0_0
