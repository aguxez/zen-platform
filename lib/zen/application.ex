defmodule Zen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Zen.Repo,
      ZenWeb.Telemetry,
      {Phoenix.PubSub, name: Zen.PubSub},
      ZenWeb.Endpoint,
      Zen.Events.Watcher,
      {Task.Supervisor, name: Zen.Supervisors.EventsSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ZenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
