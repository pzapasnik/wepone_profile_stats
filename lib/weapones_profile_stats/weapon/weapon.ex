defmodule Weapone do
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
  defstruct name: "",
            attacks_number: 0,
            atacks_modifier: :none,
            to_hit: 0,
            to_wound: 0,
            rend: 0,
            damage: 0,
            damage_modifier: :none
end
