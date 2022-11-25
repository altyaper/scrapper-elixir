defmodule Scrapper.Cover do
  use GenServer
  alias Scrapper.Cover.Utils

  def start_link(core) do
    GenServer.start_link(__MODULE__, core, name: core.id)
  end

  def init(core) do
    core = Map.put(core, :urls, %{})
    {:ok, core}
  end

  def handle_call(:get_cover, _from, core) do
    %{base_url: base_url, regex_url: regex_url} = core
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(base_url),
         {:ok, document} <- Floki.parse_document(body) do

          {urls, map} = Utils.get_urls(document)
            |> Enum.filter(&String.match?(&1, regex_url))
            |> Utils.absolute_urls(base_url)
            |> Utils.merge_current_urls(core.urls)

          core = Map.put(core, :urls, map)
          {:reply, urls, core}
         end
  end

  def handle_call({:mark_as_processed, %{url: url, article: article}}, _from, core) do
    new_urls = Map.get(core, :urls)
      |> Map.update(url, %{url: url, processed: false}, fn u ->
        Map.merge(u, %{processed: true, article: article})
      end)
    new_core = core |> Map.put(:urls, new_urls)
    {:reply, :ok, new_core}
  end

  def handle_call(:get_state, _from, core) do
    {:reply, core, core}
  end

  def get_cover(module) do
    GenServer.call(module, :get_cover)
  end

  def set_url(module, response) do
    GenServer.call(module, {:mark_as_processed, response})
  end

  def get_state(module) do
    GenServer.call(module, :get_state)
  end

end
