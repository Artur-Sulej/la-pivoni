defmodule TemperatureScheduler do
  use GenServer

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def init(state) do
    LCD.start()
    display_temperature()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:update_temp, state) do
    display_temperature()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :update_temp, 60 * 1000)
  end

  def display_temperature do
    temperature =
      Firmware.TemperatureSensor.read_temperature()
      |> Float.round(1)
      |> Float.to_string()

    formatted_temperature = "Temp: #{temperature}C"
    LCD.execute(:clear)
    LCD.execute(:home)
    LCD.execute(:print, formatted_temperature)
  end
end
