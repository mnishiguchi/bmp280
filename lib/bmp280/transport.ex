defmodule BMP280.Transport do
  @moduledoc false

  @type bus_name :: binary

  @type bus_address :: 0..127

  @type t :: %{
          required(:i2c_ref) => reference(),
          required(:address) => bus_address(),
          optional(:__struct__) => atom()
        }

  @callback open(bus_name, bus_address) ::
              {:ok, t} | {:error, any}

  @callback write(t, bus_address, iodata) ::
              :ok | {:error, any}

  @callback read(t, bus_address, non_neg_integer) ::
              {:ok, binary} | {:error, any}
end
