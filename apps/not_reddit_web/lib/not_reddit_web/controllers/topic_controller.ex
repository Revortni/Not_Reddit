defmodule NotRedditWeb.TopicController do
  use NotRedditWeb, :controller
  alias NotReddit.Topic
  alias NotReddit.Repo

  def index(conn, _params) do
    topics =  Repo.all(Topic)
    render conn, "index.html", topics: topics

    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid topic name")
        |> render "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id"=> topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn,%{"id"=> topic_id, "topic" => topic}) do
    prev_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(prev_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render "edit.html", changeset: changeset, topic: prev_topic
    end
  end
end
