defmodule Scrapper.Cover.Utils do
  def get_urls(document) do
    document
    |> Floki.find("a")
    |> Floki.attribute("href")
  end

  def absolute_urls(urls, base_url) do
    Enum.map(urls, fn url ->
      URI.merge(base_url, url) |> to_string
    end)
  end

  def merge_current_urls(urls, current) do
    urls
    |> Enum.map_reduce(current, fn url, acc ->
      {url, Map.put(acc, url, %{url: url, processed: false})}
    end)
  end
end
