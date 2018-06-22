defmodule Timeularex.API do
  use HTTPoison.Base
  alias Timeularex.Config

  @base_url "https://api.timeular.com/api/v2"

  def process_url(url) do
    @base_url <> url
  end

  def process_request_body(body) do
    body
      |> Poison.encode!
  end

  def process_request_headers(headers) do
    headers ++ [{"Content-type", "application/json"}]
  end

  def process_response_body(body) do
    body
      |> Poison.decode!
  end
end
