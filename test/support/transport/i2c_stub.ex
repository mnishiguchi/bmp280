defmodule BMP280.Transport.I2C.Stub do
  @moduledoc false

  @behaviour BMP280.Transport

  defstruct [:i2c_ref, :address]

  @impl BMP280.Transport
  def open(bus_name, address)
      when is_binary(bus_name) and is_integer(address) do
    {:ok, %__MODULE__{i2c_ref: Kernel.make_ref(), address: address}}
  end

  @impl BMP280.Transport
  def write(_transport, register, data)
      when is_integer(register) and (is_binary(data) or is_list(data)) do
    :ok
  end

  @impl BMP280.Transport
  def read(_transport, register, bytes_to_read)
      when is_integer(register) and is_integer(bytes_to_read) do
    {:ok, "stub"}
  end
end
