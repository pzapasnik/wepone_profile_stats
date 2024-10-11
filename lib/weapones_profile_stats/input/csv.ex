defmodule CSVWeapons do
  def read(file) do
    case File.read(file) do
      {:ok, content} ->
        String.split(content, "\n", trim: true)
        |> Enum.map(fn x -> WeaponsParsers.parse_input(x) end)

      {:error, reason} ->
        reason
    end
  end
end
