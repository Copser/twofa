defmodule Twofa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Twofa.Repo,
      # Start the Telemetry supervisor
      TwofaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Twofa.PubSub},
      # Start the Endpoint (http/https)
      TwofaWeb.Endpoint
      # Start a worker by calling: Twofa.Worker.start_link(arg)
      # {Twofa.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twofa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwofaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
