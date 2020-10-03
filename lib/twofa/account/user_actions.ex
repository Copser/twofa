defmodule Twofa.Account.UserActions do
  import Ecto.Query
  import Ecto.Changeset
  alias Twofa.Repo
  alias Twofa.Account.User


  defp deliver(to, body) do
    require Logger
    Logger.debug(body)
    {:ok, %{to: to, body: body}}
  end

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(viewer, id) do
    user =
      User
      |> limit(1)
      |> Repo.one!

    {:ok, user}
  end

  def all_users!, do: Repo.all(User)

  def list_users(viewer, opts \\ []) do
    users =
      User
      |> Repo.all

    {:ok, users}
  end

  def register_user(%{name: name, email: email}) do
    
    {status, user} =
      %User{}
      |> User.changeset(%{name: name, email: email})
      |> Repo.insert()
    
    if status == :ok do
      # Send verification EMAIL to user
      # setup Swoosh for now logger it
      link = Twofa.Endpoint.url <> "/setup/" <> generate_setup_token(user)

      deliver(user.email, """

      Hey #{user.email},

      You can confirm your account by visiting the URL below:

      #{link}
      """)

      {:ok, user}
    else
      {status, user}
    end
  end

  def setup_user(%{secret_2fa: nil} = user, attrs) do
    user
    |> User.setup_changeset(attrs)
    |> Repo.update
  end

  def login(email, password) do
    user =
      User
      |> where([t], t.email == ^email and not(is_nil(t.password_hash)))
      |> Repo.one

    has_valid_password = Bcrypt.verify_pass(password, (if user, do: user.password_hash, else: ""))

    if user && has_valid_password do
      deliver(user.email, """
      
      """)
    end
  end
end