defmodule Flightex.Bookings.Agent do
  alias Agent

  alias Flightex.Bookings.Booking

  def start_link(_inital) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
   Recebe um %Booking{} e delega o save para o Agent.
   Retorna o {:ok, booking.id }
  """
  def save(booking) do
    Agent.update(__MODULE__, &add_booking(&1, booking))
    {:ok, booking.id}
  end

  defp add_booking(state, %Booking{id: id} = booking) do
    state
    |> Map.put(id, booking)
  end

  def get(id) do
    Agent.get(__MODULE__, &get_book(&1, id))
  end

  defp get_book(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "Booking not found"}
      user -> {:ok, user}
    end
  end
end
