defmodule NotRedditWeb.CommentsChannel do
  use NotRedditWeb, :channel
  alias NotReddit.{Topic, Comment, Repo}

  @impl true
  def join("comments:" <> topic_id, payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
    |> Repo.get(topic_id)
    |> Repo.preload(:comments)

    if authorized?(payload) do
      {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    changeset = topic
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
