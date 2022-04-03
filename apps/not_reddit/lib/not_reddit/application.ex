defmodule NotReddit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NotReddit.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NotReddit.PubSub}
      # Start a worker by calling: NotReddit.Worker.start_link(arg)
      # {NotReddit.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: NotReddit.Supervisor)
  end
end
