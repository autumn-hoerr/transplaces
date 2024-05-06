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

  def find_or_create(%Auth{} = auth) do
    if belongs_to_guild?(auth) do
      {:ok, upsert_user(auth)}
    else
      {:error, "Not a member"}
    end
  end

  def upsert_user(auth) do
    {status, user} =
      case get_user_by_discordId(auth.uid) do
        nil -> auth |> user_from_auth() |> create()
        user -> logged_in_update(user)
      end

    case status do
      :ok -> {:ok, user_for_session(user)}
      _ -> {:error, "Couldn't create user: #{user.errors}"}
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

# auth: %Ueberauth.Auth{
#   uid: "201468878604337153",
#   provider: :discord,
#   strategy: Ueberauth.Strategy.Discord,
#   info: %Ueberauth.Auth.Info{
#     name: nil,
#     first_name: nil,
#     last_name: nil,
#     nickname: "refringence",
#     email: "autumn.m.hoerr@gmail.com",
#     location: nil,
#     description: nil,
#     image: "https://cdn.discordapp.com/avatars/201468878604337153/cae9434aa29a2aaf3e80e42b9bc97225.jpg",
#     phone: nil,
#     birthday: nil,
#     urls: %{}
#   },
#   credentials: %Ueberauth.Auth.Credentials{
#     token: "GiSHdYbu6dF8uxWoSRaUBPfd7FowAx",
#     refresh_token: "Zr7NUiy8PKYqOBMSmkAE0M90F77dyp",
#     token_type: nil,
#     secret: nil,
#     expires: true,
#     expires_at: 1715545358,
#     scopes: ["guilds", "email", "identify"],
#     other: %{}
#   },
#   extra: %Ueberauth.Auth.Extra{
#     raw_info: %{
#       user: %{
#         "accent_color" => 8184807,
#         "avatar" => "cae9434aa29a2aaf3e80e42b9bc97225",
#         "avatar_decoration_data" => nil,
#         "banner" => nil,
#         "banner_color" => "#7ce3e7",
#         "clan" => nil,
#         "discriminator" => "0",
#         "email" => "autumn.m.hoerr@gmail.com",
#         "flags" => 0,
#         "global_name" => "Refringence",
#         "id" => "201468878604337153",
#         "locale" => "en-US",
#         "mfa_enabled" => true,
#         "premium_type" => 0,
#         "public_flags" => 0,
#         "username" => "refringence",
#         "verified" => true
#       },
#       token: %OAuth2.AccessToken{
#         access_token: "GiSHdYbu6dF8uxWoSRaUBPfd7FowAx",
#         refresh_token: "Zr7NUiy8PKYqOBMSmkAE0M90F77dyp",
#         expires_at: 1715545358,
#         token_type: "Bearer",
#         other_params: %{"scope" => "guilds email identify"}
#       },
#       guilds: [
#         %{
#           "features" => ["AUTO_MODERATION", "CHANNEL_ICON_EMOJIS_GENERATED"],
#           "icon" => "127836c5fe8cc2554fc9a1bed6f4a0c4",
#           "id" => "926150765846868029",
#           "name" => "TRANS-avengers",
#           "owner" => false,
#           "permissions" => 1312288323,
#           "permissions_new" => "1123691458457155"
#         },
#
#       ]
#     }
#   }
# }
