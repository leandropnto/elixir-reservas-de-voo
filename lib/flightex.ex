defmodule Flightex do
  alias Flightex.Bookings.Report
  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  defdelegate create_or_update_user(params), to: CreateOrUpdateUser, as: :call
  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call

  def start_agents do
    BookingsAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

  def create_report() do
    Report.create()
  end

  def create_report(start_date, final_date) do
    Report.create(start_date, final_date)
  end
end
