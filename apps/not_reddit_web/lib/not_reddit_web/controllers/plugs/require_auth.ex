defmodule NotRedditWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller


  alias NotRedditWeb.Router.Helpers
  alias NotReddit.User

  def init(_params) do

  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
        |> put_flash(:error, "You must be logged in.")
        |> redirect(to: Helpers.topic_path(conn, :index))
        |> halt()
    end
    # cond do
    #   %{assigns: %{user: user}} = conn -> conn
    #   true ->
    #     conn
    #     |> put_flash(:error, "You must be logged in.")
    #     |> redirect(to: Helpers.topic_path(conn, :index))
    #     |> halt()
    # end
  end

end
