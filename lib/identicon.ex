defmodule Identicon do
  def main(input) do
    input
      |> hash_input
      |> pick_color
  end

  def hash_input(input_string) do
    hex = :crypto.hash(:md5, input_string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(
    %Identicon.Image{hex: hex} = image
  ) do
    [r, g, b | _tail] = hex
    %Identicon.Image{image | color: %Identicon.Color{r: r, g: g, b: b}}
  end
end
