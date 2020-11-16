defmodule FsmWeb.Router do
  use FsmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FsmWeb.ApiSpec
  end

  scope "/", FsmWeb do
    pipe_through :browser
    
    get "/", PageController, :index
  end

  scope "/api", FsmWeb do
    pipe_through :api
    
    post "/create", JobController, :create
    get "/retrieve/:id", JobController, :retrieve
    patch "/update/:id", JobController, :update
    delete "/delete/:id", JobController, :delete
  end

  scope "/api" do
    pipe_through :api
    
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end  

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FsmWeb.Telemetry
    end
  end
end
