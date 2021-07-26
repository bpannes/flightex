defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  defp build_booking_list do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp booking_string(%Booking{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id,
         id: _booking_uuid
       }) do
    complete_date_string = complete_date_string(complete_date)

    "#{user_id},#{local_origin},#{local_destination},#{complete_date_string}\n"
  end

  defp complete_date_string(date) do
    "#{date.year},#{date.month},#{date.day},#{date.hour},#{date.minute},#{date.second}"
  end
end
