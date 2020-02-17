defmodule YoloExampleWeb.WebcamChannel do
  use Phoenix.Channel

  def join("webcam:detection", _params, socket) do
    {:ok, socket}
  end

  def handle_in("frame", %{"frame" => "data:image/jpeg;base64," <> frame_data} = _event, socket) do
    frame = Base.decode64!(frame_data)
    YoloExample.Worker.request_detection(YoloExample.Worker, frame)
    {:noreply, socket}
  end

  def handle_info({:detected, _image_id, result}, socket) do
    push(socket, "detected", result)
    {:noreply, socket}
  end
end
