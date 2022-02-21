defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "create/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.create("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "create/3" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called with date filter, return only content between date filter" do
      params1 = %{
        complete_date: ~N[2022-01-01 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params2 = %{
        complete_date: ~N[2022-01-02 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params3 = %{
        complete_date: ~N[2022-01-03 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content =
        "12345678900,Brasilia,Bananeiras,2022-01-02 12:00:00\n" <>
          "12345678900,Brasilia,Bananeiras,2022-01-03 12:00:00"

      Flightex.create_or_update_booking(params1)
      Flightex.create_or_update_booking(params2)
      Flightex.create_or_update_booking(params3)
      Report.create("report-test.csv", ~N[2022-01-02 12:00:00], ~N[2022-01-04 12:00:00])
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end
end
