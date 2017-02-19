# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kenbruen,
  ecto_repos: [Kenbruen.Repo]

# Configures the endpoint
config :kenbruen, Kenbruen.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SB26uMvketmdrdo1S9yeS1F2BF9i8gU91ISRqgTs1GpyzgsrM98bGTiZq9tClLR8",
  render_errors: [view: Kenbruen.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kenbruen.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
