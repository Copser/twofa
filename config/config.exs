# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twofa,
  ecto_repos: [Twofa.Repo],
  generators: [binary_id: true]

  config :twofa, Twofa.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :twofa, TwofaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9ITFEWOT26dcG9o7PwQ5V3rNH/JXM8cxVKXKmWZqVZ/73OTDw/YYh4vt+d9t4Ty+",
  render_errors: [view: TwofaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Twofa.PubSub,
  live_view: [signing_salt: "Gf5cNUji"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken, default_signer: [
  signer_alg: "HS256",
  key_octet: "cuastv23dsqwdffnhjhdbkcbakjasqkfwir123o8r83bufbfbf1b"
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
