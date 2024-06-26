defmodule TransplacesWeb.Router do
  use TransplacesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TransplacesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Transplaces.Authentication.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
    plug Transplaces.Authentication.CurrentUser
  end

  # AUTH ROUTES

  scope "/auth", TransplacesWeb do
    pipe_through :browser

    get "/:provider", Authentication.Controller, :request
    get "/:provider/callback", Authentication.Controller, :callback
    post "/:provider/callback", Authentication.Controller, :callback
    delete "/logout", Authentication.Controller, :delete
  end

  scope "/", TransplacesWeb do
    pipe_through :browser
    live("/", HomeLive)
  end

  scope "/places", TransplacesWeb do
    pipe_through [:browser]
    live("/", PlacesLive)
    live("/:id", PlaceLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TransplacesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:transplaces, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TransplacesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
