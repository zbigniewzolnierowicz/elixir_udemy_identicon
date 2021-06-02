defmodule Identicon do
  def main(input) do
    input
      |> hash_input
      |> pick_color
      |> build_grid
      |> filter_odd_squares
      |> build_pixel_map
      |> draw_image
      |> save_image(input)
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

    %Identicon.Image{image | grid: grid_data}
  end

  def mirror_row(
    [first, second | _tail] = row
  ) do
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid = Enum.filter(grid, fn({item, _index}) -> rem(item, 2) == 0 end)
    %Identicon.Image{image | grid: filtered_grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_item, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      start_point = {horizontal, vertical}
      end_point = {horizontal + 50, vertical + 50}
      {start_point, end_point}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    size = 50 * 5
    image = :egd.create(size, size)
    %Identicon.Color{r: r, g: g, b: b} = color
    for {start_point, end_point} <- pixel_map do
      :egd.filledRectangle(image, start_point, end_point, :egd.color({r, g, b}))
    end
    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
