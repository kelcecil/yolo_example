# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :yolo_example, YoloExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RXW0RqtlQgmWgdK4O0JhlMvW0Lhkdd3jOpi663q3bQC+J1+5IkZTi59fcFc3tY2t",
  render_errors: [view: YoloExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: YoloExample.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
