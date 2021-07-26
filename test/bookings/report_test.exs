# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return :ok" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      content = "12345678900,Brasilia,Bananeiras,2001,5,7,12,0,0"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {_ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate_report/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return :ok" do
      from_date = ~D[2001-05-07]
      to_date = ~D[2001-05-17]

      params_1 = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      params_2 = %{
        complete_date: ~N[2001-05-17 18:00:00],
        local_origin: "Bananeiras",
        local_destination: "Brasilia",
        user_id: "12345678900"
      }

      params_3 = %{
        complete_date: ~N[2001-05-18 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      content =
        "12345678900,Bananeiras,Brasilia,2001-05-17 18:00:00\n12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00\n"

      Flightex.create_or_update_booking(params_1)
      Flightex.create_or_update_booking(params_2)
      Flightex.create_or_update_booking(params_3)
      Flightex.generate_report(from_date, to_date, "generate-report-test.csv")
      {_ok, file} = File.read("generate-report-test.csv")

      assert file =~ content
    end
  end
end
