defmodule NotRedditWeb.TopicController do
  use NotRedditWeb, :controller
  alias NotReddit.Topic
  alias NotReddit.Repo
  plug NotRedditWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics =  Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id"=> topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    changeset = conn.assigns[:user]
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(topic)

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


  def delete(conn, %{"id"=> topic_id}) do
    current_topic = Repo.get!(Topic, topic_id)
    Repo.get!(Topic, topic_id)
    |> Repo.delete!
    %{title: topic_title} = current_topic
    conn
    |> put_flash(:info, "Topic \"#{topic_title}\" Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))

  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id"=> topic_id}} = conn
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Permission denied")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
