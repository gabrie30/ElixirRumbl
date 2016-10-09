defmodule Rumbl.SessionController do
  use Rumbl.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    # require IEx; IEx.pry
    # creating a new session
    # grab the username and password
    # check to see if the username is in the db
    # check to see if the passwords match
    # log user in and redirect
    # or tell them their credentials are wrong
    case Rumbl.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render("new.html")
    end
  end
end
