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
    children = []
    opts = [strategy: :one_for_one, name: WeaponesProfileStats.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
