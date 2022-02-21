defmodule Flightex.Bookings.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingsAgent

  describe "save/1" do
    setup do
      BookingsAgent.start_link(%{})

      :ok
    end

    test "when the param are valid, return a booking uuid" do
      response =
        :booking
        |> build()
        |> BookingsAgent.save()

      {:ok, uuid} = response

      assert response == {:ok, uuid}
    end
  end

  describe "get/1" do
    setup do
      BookingsAgent.start_link(%{})

      {:ok, id: UUID.uuid4()}
    end

    test "when the user is found, return a booking", %{id: id} do
      booking = build(:booking, id: id)
      {:ok, uuid} = BookingsAgent.save(booking)

      response = BookingsAgent.get(uuid)

      expected_response =
        {:ok,
         %Flightex.Bookings.Booking{
           complete_date: ~N[2001-05-07 03:05:00],
           id: id,
           local_destination: "Bananeiras",
           local_origin: "Brasilia",
           user_id: "12345678900"
         }}

      assert response == expected_response
    end

    test "when the user wasn't found, returns an error", %{id: id} do
      booking = build(:booking, id: id)
      {:ok, _uuid} = BookingsAgent.save(booking)

      response = BookingsAgent.get("banana")

      expected_response = {:error, "Booking not found"}

      assert response == expected_response
    end
  end

  describe "get_all/0" do
    setup do
      BookingsAgent.start_link(%{})

      {:ok, id: UUID.uuid4(), id2: UUID.uuid4()}
    end

    test "return all bookings on agent", %{id: id, id2: id2} do
      booking1 = build(:booking, id: id)
      booking2 = build(:booking, id: id2)

      BookingsAgent.save(booking1)
      BookingsAgent.save(booking2)

      response = BookingsAgent.get_all()

      expected_response = %{id => booking1, id2 => booking2}

      assert response == expected_response
    end
  end
end
