defmodule Sauron.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        SauronWeb.Endpoint,
        brook_def()
      ]
      |> List.flatten()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sauron.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def brook_def() do
    case Application.get_env(:sauron, :brook) do
      nil -> []
      config -> {Brook, config}
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SauronWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
