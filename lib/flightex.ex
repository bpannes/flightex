defmodule Flightex do
  alias Flightex.Bookings.Agent, as: UserBooking
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBookings
  alias Flightex.Bookings.Report, as: BookingReport
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUsers

  def start_agents do
    UserAgent.start_link(%{})
    UserBooking.start_link(%{})
  end

  defdelegate create_or_update_user(params), to: CreateOrUpdateUsers, as: :call
  defdelegate create_or_update_booking(params), to: CreateOrUpdateBookings, as: :call

  defdelegate generate_report(from_date, to_date, filename),
    to: BookingReport,
    as: :generate_report
end
