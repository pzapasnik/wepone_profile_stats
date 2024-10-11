defmodule WeaponsParsers do
  def parse_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> then(&Enum.zip([:name, :attacks, :to_hit, :to_wound, :rend, :damage], &1))
    |> Enum.into(%{})
  end
end
