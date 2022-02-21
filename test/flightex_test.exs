defmodule FlightexTest do
  use ExUnit.Case, async: false
  alias Flightex.Users.User

  describe "start_agents/0" do
    test "When start_agents, returns :ok" do
      {result, _pid} = Flightex.start_agents()
      assert result == :ok
    end
  end

  describe "create_report/0" do
    setup do
      Flightex.start_agents()
      :ok
    end

    test "when run, creates report" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(params)
      response = Flightex.create_report("report-test.csv")

      assert response == :ok
    end
  end

  describe "create_report/3" do
    setup do
      Flightex.start_agents()
      :ok
    end

    test "when run with date filters, creates report only with date between that filter" do
      params = %{
        complete_date: ~N[2022-02-06 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params2 = %{
        complete_date: ~N[2022-02-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      params3 = %{
        complete_date: ~N[2022-02-08 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params2)
      Flightex.create_or_update_booking(params3)

      response =
        Flightex.create_report(
          "report-test_date.csv",
          ~N[2022-02-07 12:00:00],
          ~N[2022-02-08 20:00:00]
        )

      content =
        "12345678900,Brasilia,Bananeiras,2022-02-07 12:00:00\n" <>
          "12345678900,Brasilia,Bananeiras,2022-02-08 12:00:00"

      assert response == :ok

      {:ok, file} = File.read("report-test_date.csv")

      assert file =~ content
    end
  end

  describe "create_or_update_user/1" do
    setup do
      Flightex.start_agents()
      :ok
    end

    test "should create an user" do
      response =
        Flightex.create_or_update_user(%{
          name: "Leandro",
          email: "email@gmail.com",
          cpf: "99999999999"
        })

      assert {:ok, result} = response
      assert %{name: "Leandro"} = result
    end
  end
end
