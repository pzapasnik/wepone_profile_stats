defmodule WeaponesProfileStats.Application do
  @moduledoc """
  This module calculates, and compares stats for different Age of Sigmar wepone profiles.
  """
  use Application

  @doc """
  Starts the application.
  Can be run in two modes:
    - `:io_input` - will ask for input from the user
    - `:file_input` - will expect path to csv file with input data. The file should have the following format:
      ```
      Name, Atacks,To Hit,To Wound,Rend,Damage
      Sword,  3, 3, -1, 1
      Bow,    2D6, 4, 3, 0, 1
      Spear,  3, 4, 3, -1, D6
      ```
  """
  @impl true
  def start(_type, _args) do
    IO.puts("Starting WeponesProfileStats application")
    config = Application.get_all_env(:weapones_profile_stats)
    IO.inspect(config)

    weapons = []

    case config[:execution] do
      :io_input ->
        IO.puts("Starting IO input mode")
        get_io_input(weapons)

      :file_input ->
        start_file_input(weapons, config[:file_path])

      _ ->
        IO.puts("Invalid execution mode")
    end

    IO.inspect(weapons)

    children = []
    opts = [strategy: :one_for_one, name: WeaponesProfileStats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_io_input(weapons) do
    weapon =
      IO.gets("Pass Wepon Profile in format: Name, Atacks,To Hit, To Wound, Rend, Damage")
      |> parseWeaponInput()

    IO.inspect(weapon)
    weapons = [weapon | weapons]
    IO.inspect(weapons)
    recurse_io_input(weapons)
  end

  defp recurse_io_input(weapons) do
    should_continue = IO.gets("Do you want to add a new weapon profile? (y/n)")

    case should_continue do
      "y\n" -> get_io_input(weapons)
      "n\n" -> weapons
      _ -> recurse_io_input(weapons)
    end
  end

  defp parseWeaponInput(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> then(&Enum.zip([:name, :attacks, :to_hit, :to_wound, :rend, :damage], &1))
    |> Enum.into(%{})
  end

  defp start_file_input(weapons, file_path) do
    IO.puts("Starting file input mode")
    IO.puts("Reading file: #{file_path}")

    # file =
    #   File.read!(file_path)
    #   |> String.split("\n")
    #   |> Enum.map(&String.split(&1, ","))
    #   |> Enum.map(&parse_weapon/1)
    #
    # file

    weapons
  end
end
