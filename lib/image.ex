defmodule Identicon.Image do
  defstruct hex: nil,
    grid: nil,
    color: %Identicon.Color{r: 255, g: 255, b: 255}
end
