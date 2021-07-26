defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate_report(from_date, to_date, filename \\ "report.csv") do
    booking_list = build_booking_list_with_check(from_date, to_date)

    File.write(filename, booking_list)

    {:ok, "Report generated successfully"}
  end

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  defp build_booking_list do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string(booking) end)
  end

  defp build_booking_list_with_check(from_date, to_date) do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_string_with_check(booking, from_date, to_date) end)
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

  defp booking_string_with_check(
         %Booking{
           complete_date: complete_date,
           local_origin: local_origin,
           local_destination: local_destination,
           user_id: user_id,
           id: _booking_uuid
         },
         from_date,
         to_date
       ) do
    complete_date_string = NaiveDateTime.to_string(complete_date)
    string = "#{user_id},#{local_origin},#{local_destination},#{complete_date_string}\n"

    {Date.compare(complete_date, from_date), Date.compare(complete_date, to_date)}
    |> check_string(string)
  end

  defp complete_date_string(date) do
    "#{date.year},#{date.month},#{date.day},#{date.hour},#{date.minute},#{date.second}"
  end

  defp check_string({_result1, :gt}, _string), do: ""
  defp check_string({:lt, _result2}, _string), do: ""
  defp check_string({_result1, _result2}, string), do: string
end
