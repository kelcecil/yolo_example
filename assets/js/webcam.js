import Webcam from "webcamjs";
import { Socket } from "phoenix";

let socket = new Socket("/socket");
socket.connect();

let channel = socket.channel("webcam:detection", {});
channel.join()
    .receive("ok", resp => { console.log(`Joined successfully`)})
    .receive("error", resp => { console.log("Unable to join", resp)});

Webcam.set({
    width: 1280,
    height: 720,
    image_format: 'jpeg',
    jpeg_quality: 90,
    fps: 30
});
Webcam.attach("#camera");

//our canvas element
let canvas = document.getElementById('objects');
let ctx = canvas.getContext('2d');
const boxColor = "blue";
//labels font size
const fontSize = 18;

const capture = () => {
    Webcam.snap((dataUri, canvas, context) => {
        channel.push("frame", { "frame": dataUri });
    });
};

const drawObjects = (result) => {
    const objects = result.objects;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.lineWidth = 4;
    ctx.font = `${fontSize}px Helvetica`;
    objects.forEach((obj) => {
        const width = ctx.measureText(obj.label).width;
        ctx.strokestyle = boxColor;
        ctx.strokeRect(obj.x, obj.y, obj.w, obj.h);
        ctx.fillStyle = boxColor;
        ctx.fillRect(obj.x - 2, obj.y - fontSize, width + 10, fontSize);
        ctx.fillStyle = "white";
        ctx.fillText(obj.label, obj.x, obj.y -2);
    });
};

channel.on("detected", drawObjects);

const FPS = 1;
let intervalID = null;
let startStopButton = document.getElementById("start_stop")

startStopButton.addEventListener("click", () => {
    if (intervalID == null) {
        intervalID = setInterval(capture, 1000/FPS);
        startStopButton.textContent = "Stop";
    } else {
        clearInterval(intervalID);
        intervalID = null;
        startStopButton.textContent = "Start";
    }
});

export default socket;