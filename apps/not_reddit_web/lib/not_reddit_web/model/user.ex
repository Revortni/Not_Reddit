defmodule NotReddit.User do
  use NotRedditWeb, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, NotReddit.Topic
    has_many :comments, NotReddit.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
