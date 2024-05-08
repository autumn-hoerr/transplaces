defmodule Transplaces.Accounts do
  @moduledoc """
  Users and authentication
  """

  alias Transplaces.Accounts.User
  alias Transplaces.Repo
  alias Ueberauth.Auth

  @transavengers_guild_id "926150765846868029"

  def create(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  def update(%User{} = user) do
    %User{}
    |> User.changeset(user)
    |> Repo.update()
  end

  def delete(%User{} = user) do
    user
    |> User.changeset(%{active: false})
    |> Repo.update()
  end

  def logged_in_update(%User{} = user) do
    user
    |> User.changeset(%{
      last_login: DateTime.utc_now(),
      guild_membership_last_checked: DateTime.utc_now()
    })
    |> Repo.update()
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_discordId(discordId) do
    Repo.get_by(User, discordId: discordId)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def find_or_create(%Auth{} = auth) do
    if belongs_to_guild?(auth) do
      {:ok, upsert_user(auth)}
    else
      {:error, "Not a member"}
    end
  end

  defp upsert_user(auth) do
    {status, user} =
      case get_user_by_discordId(auth.uid) do
        nil -> auth |> user_from_auth() |> create()
        user -> logged_in_update(user)
      end

    case status do
      :ok -> user_for_session(user)
      _ -> "Couldn't create user: #{user.errors}"
    end
  end

  defp user_for_session(user) do
    Map.take(user, [:id, :email])
  end

  defp user_from_auth(auth) do
    %{
      discordId: auth.uid,
      name: name_from_auth(auth),
      email: auth.info.email,
      avatar: avatar_from_auth(auth),
      last_login: DateTime.utc_now(),
      guild_membership_last_checked: DateTime.utc_now()
    }
  end

  # given that we only plan to support discord, we can make
  # pretty specific matches here for now
  defp avatar_from_auth(%{info: %{image: image}} = _auth), do: image
  defp avatar_from_auth(_auth), do: nil

  defp name_from_auth(%{info: %{nickname: nickname}} = _auth), do: nickname
  defp name_from_auth(_auth), do: nil

  defp belongs_to_guild?(%{extra: %{raw_info: %{guilds: guilds}}} = _auth) do
    guilds
    |> Enum.map(& &1["id"])
    |> Enum.any?(fn guild_id -> guild_id == @transavengers_guild_id end)
  end

  defp belongs_to_guild?(_auth), do: false
end
