defmodule Flightex.Bookings.Booking do
  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  @enforce_keys @keys
  defstruct @keys

  @doc """
   Recebe os parametros e cria um booking. Retorna uma tupla {:ok, booking}
  """
  def build(complete_date, local_origin, local_destination, user_id) do
    {:ok,
     %__MODULE__{
       complete_date: complete_date,
       local_origin: local_origin,
       local_destination: local_destination,
       user_id: user_id,
       id: UUID.uuid4()
     }}
  end
end
