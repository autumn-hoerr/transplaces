defmodule Transplaces.Authentication.Guardian do
  use Guardian, otp_app: :transplaces

  def subject_for_token(%{email: email}, _claims), do: {:ok, email}
  def subject_for_token(_, _), do: {:error, :you_done_goofed_son}

  def resource_from_claims(%{"sub" => email}) do
    case Transplaces.Accounts.get_user_by_email(email) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :you_done_goofed_son}
  end
end
