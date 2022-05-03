defmodule NotRedditWeb.AuthController do
  use NotRedditWeb, :controller
  plug Ueberauth
  alias NotReddit.User
  alias NotReddit.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: params["provider"]}
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  defp insert_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  defp signin(conn, changeset) do
    case insert_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def signout(conn,__params) do
    conn
    |> configure_session(drop: true) ## delete anything to do with user session
    |> redirect(to: Routes.topic_path(conn,:index))
  end
end
