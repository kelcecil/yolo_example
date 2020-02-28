defmodule YoloExampleWeb.WebcamChannel do
  use Phoenix.Channel

  def join("webcam:detection", _params, socket) do
    socket =
      socket
      |> assign(:current_image_id, nil)
      |> assign(:latest_frame, nil)

    {:ok, socket}
  end

  def handle_in(
        "frame",
        %{"frame" => "data:image/jpeg;base64," <> frame_data} = _event,
        %{assigns: %{current_image_id: image_id}} = socket
      ) do
    if image_id == nil do
      {:noreply, detect(socket, frame_data)}
    else
      {:noreply, assign(socket, :latest_frame, frame_data)}
    end
  end

  # only the result of the current_image_id
  def handle_info(
        {:detected, image_id, result},
        %{assigns: %{current_image_id: image_id}} = socket
      ),
      do: handle_detected(result, socket)

  # skipping results we are not waiting for
  def handle_info({:detected, _, _}, socket),
    do: {:noreply, socket}

  defp detect(socket, frame_data) do
    frame = Base.decode64!(frame_data)
    image_id = YoloExample.Worker.request_detection(YoloExample.Worker, frame)

    socket
    |> assign(:current_image_id, image_id)
    |> assign(:latest_frame, nil)

    {:noreply, socket}
  end

  defp handle_detected(result, socket) do
    push(socket, "detected", result)

    socket =
      socket
      |> assign(:current_image_id, nil)
      |> detect_if_need()

    {:noreply, socket}
  end

  defp detect_if_need(socket) do
    if socket.assigns.latest_frame != nil do
      detect(socket, socket.assigns.latest_frame)
    else
      socket
    end
  end
end
