defmodule Timeularex.Config do
  def api_key do
    Application.fetch_env!(:timeularex, :api_key)
  end

  def api_key(key) do
    Application.put_env(:timeularex, :api_key, key)
  end

  def api_secret do
    Application.fetch_env!(:timeularex, :api_secret)
  end

  def api_secret(secret) do
    Application.put_env(:timeularex, :api_secret, secret)
  end
end
