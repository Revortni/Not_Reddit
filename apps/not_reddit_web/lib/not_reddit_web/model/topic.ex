defmodule NotReddit.Topic do
  use NotRedditWeb, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, NotReddit.User
    has_many :comments, NotReddit.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
