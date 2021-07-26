defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def call(%{
        complete_date: complete_date_list,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      })
      when is_list(complete_date_list) do
    with {:ok, complete_date} <- build_date(complete_date_list),
         {:ok, booking} <-
           Booking.build(
             complete_date,
             local_origin,
             local_destination,
             user_id
           ) do
      BookingAgent.save(booking)
    else
      error -> error
    end
  end

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    with {:ok, complete_date} <- {:ok, complete_date},
         {:ok, booking} <-
           Booking.build(
             complete_date,
             local_origin,
             local_destination,
             user_id
           ) do
      BookingAgent.save(booking)
    else
      error -> error
    end
  end

  defp build_date([year, month, day, hour, minute, second]) do
    NaiveDateTime.new(year, month, day, hour, minute, second)
  end
end
