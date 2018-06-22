# Timeularex
[![CircleCI](https://circleci.com/gh/r-frederick/timeularex.svg?style=shield)](https://circleci.com/gh/r-frederick/timeularex)
[![hex.pm](https://img.shields.io/badge/hex-0.1.0-blue.svg)](https://hex.pm/packages/timeularex)

NOTE: Timeularex is in early stages of development. Use in production
should be considered with caution.

Timeularex is an API client for the [Timeular public API](http://developers.timeular.com/public-api/).
Timular is a service to improve time-tracking of activities.

## Installation

Timeularex can be installed by adding `timeularex` to your list of 
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:timeularex, "~> 0.1.0"}
  ]
end
```

## Configuration

The client provides two options for configuration. The first involves the
  typical setting of variables in your `config.exs` file:

```elixir
config :timeularex,
    api_key: <<API_KEY>>,
    api_secret: <<API_SECRET>>
```

Additionally, you can utilize api_key/1 and api_secret/1 functions in 
the `TImeularex.Config` module.

Your API key and secret can be retrieved from your 
[account app settings](https://profile.timeular.com/#/app/account).


---
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/timeularex](https://hexdocs.pm/timeularex).