defmodule Scrapper.Request do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: Scrapper.Request)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:scrap_url, url}, state) do
    IO.inspect(url)
    {:noreply, state}
  end

  def scrap(url) do
    GenServer.cast(__MODULE__, {:scrap_url, url})
  end
end
