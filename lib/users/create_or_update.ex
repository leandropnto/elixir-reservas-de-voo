defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(%{name: name, email: email, cpf: cpf}) do
    with {:ok, user} <- User.build(name, email, cpf),
         :ok <- UserAgent.save(user) do
      {:ok, user}
    end
  end
end
