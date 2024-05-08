defmodule TransplacesWeb.Authentication.Controller do
  use TransplacesWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Transplaces.Accounts
  alias Transplaces.Authentication.Guardian

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> fetch_session()
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> configure_session(renew: true)
        |> discord_sign_in(user)
        |> dbg()
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def discord_sign_in(conn, user),
    do: Guardian.Plug.sign_in(conn, %{:email => user.email})
end
