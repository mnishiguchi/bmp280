defmodule BMP280.BMP280Comm do
  @moduledoc false

  alias BMP280.{BMP280Sensor, Transport}

  @calib00_register 0x88
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

    Transport.I2C.write(
      transport,
      @ctrl_meas_register,
      <<osrs_t::size(3), osrs_p::size(3), mode::size(2)>>
    )
  end

  @spec read_calibration(Transport.t()) :: {:error, any} | {:ok, binary}
  def read_calibration(transport) do
    Transport.I2C.read(transport, @calib00_register, 24)
  end

  @spec read_raw_samples(Transport.t()) :: {:error, any} | {:ok, BMP280Sensor.raw_samples()}
  def read_raw_samples(transport) do
    case Transport.I2C.read(transport, @press_msb_register, 6) do
      {:ok, <<pressure::20, _::4, temp::20, _::4>>} ->
        {:ok, %{raw_pressure: pressure, raw_temperature: temp}}

      {:error, _reason} = error ->
        error
    end
  end
end
