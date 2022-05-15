defmodule NotReddit.Comment do
  use NotRedditWeb, :model

  schema "comments" do
    field :content, :string
    belongs_to :user, NotReddit.User
    belongs_to :topic, NotReddit.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end

end
