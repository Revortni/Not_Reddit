defmodule NotRedditWeb.TopicController do
  use NotRedditWeb, :controller
  alias NotReddit.Topic

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, params) do
    %{"topic" => %{ "title" => title}} = params
    IO.puts title
  end
end
