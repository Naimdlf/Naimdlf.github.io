/*
  Author: Naim Ferris
  Description: Lab 8
*/
function setup() {
    // Get the canvas and context
    const canvas = document.querySelector("#canvas");
    const ctx = canvas.getContext("2d");
    
    // Set up the initial state of the drawing
    let isDrawing = false;
    let lastX = 0;
    let lastY = 0;

    const colors = ["black", "red", "green", "blue"];
    let selectedColor = colors[0]; 
    const colorSelector = document.querySelector("#colorSelect");
    for (let i = 0; i < colors.length; i++) {
    const option = document.createElement("option")
    option.valur = colors[i];
    option.textContent = colors[i];
    colorSelector.appendChild(option);
    }
    colorSelector.addEventListener("change", function(){
        selectedColor = colorSelector.value;
    })

    canvas.addEventListener("mousedown", function (evt) {
        isDrawing = true;
        lastX = evt.offsetX;
        lastY = evt.offsetY;
          
      // TODO: Implement the drawing functionality
    });
  
    canvas.addEventListener("mousemove", function (evt) {
      if (isDrawing) {
        const x = evt.offsetX;
const y = evt.offsetY;
ctx.beginPath();
ctx.moveTo(lastX, lastY);
ctx.lineTo(x, y);
//change color of stroke
ctx.strokeStyle = selectedColor;
ctx.stroke();
lastX = x;
lastY = y;
        // TODO: Implement the drawing functionality
      }
    });
  
    canvas.addEventListener("mouseup", function () {
      // Mouse button released, signal that we're not drawing anymore
      isDrawing = false;
    });
  
    canvas.addEventListener("mouseout", function () {
      // Mouse left the canvas, signal that we're not drawing anymore
      isDrawing = false;
    });
  
    document.querySelector("#clearButton").addEventListener("click", function () {
      // TODO: Clear the canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    });
  }
  
  //Call setup() when the DOM is loaded
  window.addEventListener("DOMContentLoaded", setup);