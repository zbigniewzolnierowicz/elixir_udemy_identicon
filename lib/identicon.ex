defmodule Identicon do
  def main(input) do
    input
      |> hash_input
      |> pick_color
      |> build_grid
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(
    %Identicon.Image{hex: hex} = image
  ) do
    [r, g, b | _tail] = hex
    %Identicon.Image{image | color: %Identicon.Color{r: r, g: g, b: b}}
  end

  def build_grid(
    %Identicon.Image{hex: hex} = image
  ) do
    grid_data = hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | hex: grid_data}
  end

  def mirror_row(
    [first, second | _tail] = row
  ) do
    row ++ [second, first]
  end
end
