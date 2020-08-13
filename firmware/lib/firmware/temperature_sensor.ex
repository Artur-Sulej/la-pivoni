defmodule Firmware.TemperatureSensor do
  @moduledoc false

  @base_dir "/sys/bus/w1/devices/"
  @w1_slave "w1_slave"
  @sensor_device_prefix "28-"

  def read_temperature do
    read_raw_data()
    |> parse_raw_data()
  end

  defp read_raw_data do
    sensor =
      @base_dir
      |> File.ls!()
      |> Enum.find(&String.starts_with?(&1, @sensor_device_prefix))

    if sensor do
      [@base_dir, sensor, @w1_slave]
      |> Path.join()
      |> File.read()
    else
      {:error, :sensor_not_found}
    end
  end

  defp parse_raw_data({:ok, data}) do
    matches = Regex.run(~r/t=(\d+)/, data)

    if matches do
      matches
      |> List.last()
      |> String.to_integer()
      |> Kernel./(1000)
    else
      {:error, :unprocessable_data}
    end
  end

  defp parse_raw_data({:error, error}), do: {:error, error}
end
