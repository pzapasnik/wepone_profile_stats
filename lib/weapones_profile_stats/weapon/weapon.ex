defmodule Weapon.Profile do
  @moduledoc """
  This module defines a struct for a single weapon profile.
   - `name` - name of the weapon
   - `attacks_number` - number of attacks
   - `attacks_modifier` - modifier for number of attacks (:none, :d6, :d3)
   - `to_hit` - to hit roll
   - `to_wound` - to wound roll
   - `rend` - rend value
   - `damage` - damage value
   - `damage_modifier` - modifier for damage (:none, :d6, :d3)
  """
  defstruct [:name, :attacks, :to_hit, :to_wound, :rend, :damage]
end

defmodule WeaponAdapter do
  def adapt_weapons(weapons) do
    Enum.reduce(weapons, {[], []}, fn weapon, {successe, errors} ->
      case adapt(weapon) do
        {:ok, weapon_profile} -> {[weapon_profile | successe], errors}
        {:error, reason} -> {successe, [{weapon, reason} | errors]}
      end
    end)
  end

  def adapt(weapon) do
    fields_to_types = [
      {:name, :string},
      {:attacks, :int_or_string},
      {:to_hit, :int},
      {:to_wound, :int},
      {:rend, :int_or_string},
      {:damage, :int_or_string}
    ]

    with {:ok, parsed_fields} <- parse_fields(weapon, fields_to_types) do
      {:ok, struct(Weapon.Profile, parsed_fields)}
    end
  end

  defp parse_fields(weapon, fields_to_types) do
    Enum.reduce_while(fields_to_types, {:ok, %{}}, fn {field, type}, {:ok, acc} ->
      value = Map.get(weapon, field, default_value(type))
      IO.puts("Parsing #{field} with value #{value}")

      case parse_value(value, type) do
        {:ok, parsed_value} ->
          IO.puts("Parsed #{field} with value #{parsed_value}")
          IO.inspect(acc)
          {:cont, {:ok, Map.put(acc, field, parsed_value)}}

        {:error, reason} ->
          {:halt, {:error, "Error parsing #{field}: #{reason}"}}
      end
    end)
  end

  defp default_value(:string), do: ""
  defp default_value(:int), do: 0
  defp default_value(:int_or_string), do: 0

  defp parse_value(value, :string), do: {:ok, value}
  defp parse_value(value, :int), do: parse_int(value)
  defp parse_value(value, :int_or_string), do: parse_int_or_string(value)

  defp parse_int_or_string(value) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      :error -> {:ok, value}
    end
  end

  defp parse_int(value) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      :error -> {:error, "Invalid integer value"}
    end
  end
end
