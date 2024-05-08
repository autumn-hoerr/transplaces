defmodule Transplaces.Authentication.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :transplaces,
    error_handler: Transplaces.Authentication.ErrorHandler,
    module: Transplaces.Authentication.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}, refresh_from_cookie: true
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, refresh_from_cookie: true
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
