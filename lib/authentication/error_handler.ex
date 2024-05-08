defmodule Transplaces.Authentication.ErrorHandler do
  @moduledoc false
  @behaviour Guardian.Plug.ErrorHandler
  import Plug.Conn
  require Logger

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_resp_header("location", "/login")
    |> send_resp(302, "You are being redirected..")
    |> halt()
  end
end
