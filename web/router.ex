defmodule Kenbruen.Router do
  use Kenbruen.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Kenbruen.Auth, repo: Kenbruen.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Kenbruen do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Kenbruen do
  #   pipe_through :api
  # end
end
