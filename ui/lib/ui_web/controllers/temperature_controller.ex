defmodule UiWeb.TemperatureController do
  use UiWeb, :controller

  def show(conn, _params) do
    temperature = Firmware.TemperatureSensor.read_temperature()
    render(conn, temperature: temperature)
  end
end
