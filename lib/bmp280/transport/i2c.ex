defmodule BMP280.Transport.I2C do
  @moduledoc false

  @behaviour BMP280.Transport

  defstruct [:i2c_ref, :address]

  @impl BMP280.Transport
  def open(bus_name, address)
      when is_binary(bus_name) and is_integer(address) do
    with {:ok, i2c_ref} <- Circuits.I2C.open(bus_name) do
      {:ok, %__MODULE__{i2c_ref: i2c_ref, address: address}}
    end
  end

  @impl BMP280.Transport
  def write(transport, register, data)
      when is_integer(register) and (is_binary(data) or is_list(data)) do
    Circuits.I2C.write(
      transport.i2c_ref,
      transport.address,
      [register, data]
    )
  end

  @impl BMP280.Transport
  def read(transport, register, bytes_to_read)
      when is_integer(register) and is_integer(bytes_to_read) do
    Circuits.I2C.write_read(
      transport.i2c_ref,
      transport.address,
      <<register>>,
      bytes_to_read
    )
  end
end
