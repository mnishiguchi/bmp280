defmodule BMP280.BME280Comm do
  @moduledoc false

  alias BMP280.{BME280Sensor, Transport}

  @calib00_register 0x88
  @calib26_register 0xE1
  @ctrl_hum_register 0xF2
  @ctrl_meas_register 0xF4
  @press_msb_register 0xF7

  @spec set_oversampling(Transport.t()) :: :ok | {:error, any()}
  def set_oversampling(transport) do
    # normal
    mode = 3
    # x2 oversampling
    osrs_t = 2
    # x16 oversampling
    osrs_p = 5
    # x16 oversampling
    osrs_h = 5

    with :ok <- Transport.I2C.write(transport, @ctrl_hum_register, <<osrs_h>>) do
      Transport.I2C.write(
        transport,
        @ctrl_meas_register,
        <<osrs_t::size(3), osrs_p::size(3), mode::size(2)>>
      )
    end
  end

  @spec read_calibration(Transport.t()) :: {:error, any} | {:ok, binary}
  def read_calibration(transport) do
    with {:ok, first_part} <- Transport.I2C.read(transport, @calib00_register, 26),
         {:ok, second_part} <- Transport.I2C.read(transport, @calib26_register, 7) do
      {:ok, first_part <> second_part}
    end
  end

  @spec read_raw_samples(Transport.t()) :: {:error, any} | {:ok, BME280Sensor.raw_samples()}
  def read_raw_samples(transport) do
    case Transport.I2C.read(transport, @press_msb_register, 8) do
      {:ok, <<pressure::20, _::4, temp::20, _::4, humidity::16>>} ->
        {:ok, %{raw_pressure: pressure, raw_temperature: temp, raw_humidity: humidity}}

      {:error, _reason} = error ->
        error
    end
  end
end
