defmodule FreeFall do
  @moduledoc "Offers functions concerning the free fall of objects"
  @gravity 9.81

  @doc "Computes the velocity on impact given the height"
  @spec impact_velocity(number) :: number
  def impact_velocity(height) do
    :math.sqrt(2 * @gravity * height)
  end

  @doc "Computes the time it takes for the object to reach the ground"
  @spec fall_time(number) :: number
  def fall_time(height) do
    impact_velocity(height) / @gravity
  end
end
