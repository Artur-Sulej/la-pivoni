defmodule Firmware.TemperatureSensor do
  @moduledoc false

  @base_dir "/sys/bus/w1/devices/"
  @sensor_device_prefix "28-"

  def read_temperature do
    read_raw_data
    |> parse_raw_data
  end

  defp read_raw_data do
    sensor =
      @base_dir
      |> File.ls!()
      |> Enum.find(&String.starts_with?(&1, @sensor_device_prefix))

    File.read!("#{@base_dir}#{sensor}/w1_slave")
  end

  defp parse_raw_data(data) do
    ~r/t=(\d+)/
    |> Regex.run(data)
    |> List.last()
    |> String.to_integer()
    |> Kernel./(1000)
  end
end
