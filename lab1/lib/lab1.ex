defmodule Lab1 do
  def start do
    WorkSupervisor.start_link(:ok)
  end
end
