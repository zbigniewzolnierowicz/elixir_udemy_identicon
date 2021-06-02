defmodule Identicon.Image do
  defstruct hex: nil,
    grid: nil,
    pixel_map: nil,
    color: :egd.color(:white)
end
