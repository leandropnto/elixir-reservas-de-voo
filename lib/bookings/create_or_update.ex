defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    with {:ok, booking} <- Booking.build(complete_date, local_origin, local_destination, user_id),
         {_ok, _uid} = result <- BookingsAgent.save(booking) do
      result
    end
  end
end
