defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking

  def create(filename \\ "report.csv") do
    with bookings <- BookingsAgent.get_all(),
         items <- build_strings(bookings) do
      File.write(filename, items)
    end
  end

  def create(filename \\ "report.csv", start_date, final_date) do
    with bookings <- BookingsAgent.get_all(),
         items <- build_and_filter(bookings, start_date, final_date) do
      File.write(filename, items)
    end
  end

  defp build_and_filter(bookings, start_date, end_date) do
    bookings
    |> Map.values()
    |> Enum.filter(fn item ->
      item.complete_date >= start_date && item.complete_date <= end_date
    end)
    |> Enum.sort(:asc)
    |> Enum.map(&build_string/1)
  end

  defp build_strings(bookings) do
    bookings
    |> Map.values()
    |> Enum.map(&build_string/1)
  end

  defp build_string(%Booking{
         complete_date: complete_date,
         local_origin: origin,
         local_destination: destination,
         user_id: user_id
       }) do
    "#{user_id},#{origin},#{destination},#{complete_date}\n"
  end
end
