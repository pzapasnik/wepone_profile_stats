defmodule IOWeapons do
  def get_io_input() do
    weapon =
      IO.gets("Pass Wepon Profile in format: Name, Atacks,To Hit, To Wound, Rend, Damage")
      |> WeaponsParsers.parse_input()

    weapons = [weapon | recurse_io_input()]
    weapons
  end

  defp recurse_io_input() do
    should_continue = IO.gets("Do you want to add a new weapon profile? (y/n)")

    weapons =
      case should_continue do
        "y\n" -> get_io_input()
        "n\n" -> []
        _ -> recurse_io_input()
      end

    weapons
  end
end
