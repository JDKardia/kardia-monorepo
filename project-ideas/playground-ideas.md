# Playground

where I play around with things.

## Ideas

- Infrastructure-As-Code tools
  - ansible
  - terraform
  - circle-ci
  - github actions
- shared postgres db for all the below.
- Basic Elixir website with Phoenix
- Minimal Elixir Site with Auth and Row Level Security
- Elixir Job manager with Postgres
- Solid.Js FE with Postgrest backend
- Sveltekit FE with Postgrest backend
- Common Lisp name generator and maybe website/wasm thing
- Same website, different Backend idea (let subdomain whether served from Elixir, CL, Scala, Bash, cache, etc. (if one goes down, want to give a 404 and suggest the cached version which should be statically generated and served via redis or something. 
- Other fun little website tests I can play around with
- NGINX to reverse proxy all that jazz

## Elixir Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `playground` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:playground, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/playground](https://hexdocs.pm/playground).
