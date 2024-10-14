defmodule Wcm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WcmWeb.Telemetry,
      Wcm.Repo,
      {DNSCluster, query: Application.get_env(:wcm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wcm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Wcm.Finch},
      # Start a worker by calling: Wcm.Worker.start_link(arg)
      # {Wcm.Worker, arg},
      # Start to serve requests, typically the last entry
      WcmWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wcm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WcmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
