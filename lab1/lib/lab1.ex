defmodule Lab1 do
  def start do
    ReaderSupervisor.start_link(:ok)
  end
end
