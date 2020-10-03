defmodule Twofa.Account.User do
  use Twofa.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias __MODULE__
  alias Twofa.Repo

  schema "users" do
    field :name, :string
    field :email, :string

    field :password_hash, :string
    field :password, :string, virtual: true
    field :code, :string, virtual: true

    field :secret_2fa, :string
  end


  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :cust_ref, :last_logged_ip])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> update_change(:email, &String.trim/1)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/[^@]+@[^\.]+\..+/)
  end


  def setup_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :secret_2fa, :code])
    |> validate_required([:password, :secret_2fa, :code])
    |> validate_length(:password, min: 6, message: "Password should be at least 6 characters")
    |> validate_2fa_code
    |> hash_password()
  end

  # ========================================================================
  #                               TOTP
  # ========================================================================


  def validate_2fa_code(%Ecto.Changeset{valid?: true}  = changeset) do
    secret_2fa = get_field(changeset, :secret_2fa)
    code = get_field(changeset, :code)

    if validate_totp(secret_2fa, code) do
      changeset
    else
      changeset
      |> add_error(:code, "Invalid 2FA code")
    end
  end

  def validate_2fa_code(changeset), do: changeset


  def validate_totp(secret, code) do
    :pot.valid_totp(code, secret)
  end

  def generate_totp_secret do
    :crypto.strong_rand_bytes(20)
    |> Base.encode32
  end


  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
