defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    users = Rumbl.Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def new(conn, _params) do
    changeset = Rumbl.User.changeset(%Rumbl.User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{ "user" => user_params }) do
    changeset = Rumbl.User.registration_changeset(%Rumbl.User{}, user_params)
    case Rumbl.Repo.insert(changeset) do

      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{ "id" => id }) do
    user = Rumbl.Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end

  defp authenticate(conn, opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged into access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
