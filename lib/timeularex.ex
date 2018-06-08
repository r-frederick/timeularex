defmodule Timeularex do
  @moduledoc """
  API wrapper for the Timeular public API

  http://developers.timeular.com/public-api/
  """
  use Application

  alias Timeularex.Client
  alias Timeularex.Resources

  def start(_type, _args) do
    children = [
      Timeularex.Client
    ]

    opts = [strategy: :one_for_one, name: Timeularex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init(_) do
    IO.puts("test")
  end

  # Timeular API

  def integrations do
    "/integrations"
    |> Client.request(:get)
  end

  def activities do
    "/activities"
    |> Client.request(:get)
  end

  def create_activity(%Resources.Activity{} = activity) do
    "/activities"
    |> Client.request(:post, activity)
  end

  def update_activity(%Resources.Activity{} = activity) do
    "/activities"
    |> Client.request(:patch, activity)
  end

  def archive_activity(activity_id) do
    "/activities/#{activity_id}"
    |> Client.request(:delete)
  end

  def assign_side_activity(device_side, activity_id) do
    "/activities/#{activity_id}/device-side/#{device_side}"
    |> Client.request(:post)
  end

  def unassign_side_activity(device_side, activity_id) do
    "/activities/#{activity_id}/device-side/#{device_side}"
    |> Client.request(:delete)
  end

  def archived_activities do
    "/archived_activities"
    |> Client.request(:get)
  end

  def devices do
    "/devices"
    |> Client.request(:get)
  end

  def activate_device(device_serial) do
    "/devices/#{device_serial}/active"
    |> Client.request(:post)
  end

  def deactivate_device(device_serial) do
    "/devices/#{device_serial}/active"
    |> Client.request(:delete)
  end

  def update_device_name(device_serial, name) do
    "/devices/#{device_serial}"
    |> Client.request(:patch, %{name: name})
  end

  def remove_device(device_serial) do
    "/devices/#{device_serial}"
    |> Client.request(:delete)
  end

  def disable_device(device_serial) do
    "/devices/#{device_serial}/disabled"
    |> Client.request(:post)
  end

  def enable_device(device_serial) do
    "/devices/#{device_serial}/disabled"
    |> Client.request(:delete)
  end

  def tracking do
    "/tracking"
    |> Client.request(:get)
  end

  def start_tracking(activity_id) do
    # YYYY-MM-DDTHH:mm:ss.SSS
    current_datetime = Timex.now() |> timeular_datetime_format

    "/tracking/#{activity_id}/start"
    |> Client.request(:post, %{startedAt: current_datetime})
  end

  def edit_tracking_note(activity_id, %Resources.Note{} = note) do
    "/tracking/#{activity_id}"
    |> Client.request(:patch, note)
  end

  def stop_tracking(activity_id) do
    current_datetime = Timex.now() |> timeular_datetime_format()

    "/tracking/#{activity_id}/stop"
    |> Client.request(:post, %{stoppedAt: current_datetime})
  end

  def time_entries(stopped_after, started_before) do
    "/time-entries/#{stopped_after}/#{started_before}"
    |> Client.request(:get)
  end

  def time_entry(entry_id) do
    "/time-entries/#{entry_id}"
    |> Client.request(:get)
  end

  def reports(start_timestamp, stop_timestamp) do
    "/report/#{start_timestamp}/#{stop_timestamp}"
    |> Client.request(:get)
  end

  def tags_and_mentions do
    "/tags-and-mentions"
    |> Client.request(:get)
  end

  # Helpers

  defp timeular_datetime_format(datetime) do
    datetime
    |> DateTime.truncate(:millisecond)
    |> Timex.format!("{YYYY}-{0M}-{0D}T{h24}:{m}:{s}{ss}")
  end
end
