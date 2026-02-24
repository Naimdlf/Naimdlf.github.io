//https://www.w3schools.com/howto/howto_js_filter_elements.asp

 // store currently previewed image globally
 var currentImagesrc = "";

filterSelection("all")
function filterSelection(c) {
    var x, i;
    x = document.getElementsByClassName("filterDiv");
    document.querySelector(".gissection").style.display = "inline-flex"; // Show the grid
    document.getElementById('imagePreviewSection').style.display = 'none'; // Hide the preview if open
  
    if (c == "all") c = "";
    for (i = 0; i < x.length; i++) {
      w3RemoveClass(x[i], "show");
      if (x[i].className.indexOf(c) > -1) w3AddClass(x[i], "show");
    }
  }  

function w3AddClass(element, name) {
  var i, arr1, arr2;
  arr1 = element.className.split(" ");
  arr2 = name.split(" ");
  for (i = 0; i < arr2.length; i++) {
    if (arr1.indexOf(arr2[i]) == -1) {element.className += " " + arr2[i];}
  }
}

function w3RemoveClass(element, name) {
  var i, arr1, arr2;
  arr1 = element.className.split(" ");
  arr2 = name.split(" ");
  for (i = 0; i < arr2.length; i++) {
    while (arr1.indexOf(arr2[i]) > -1) {
      arr1.splice(arr1.indexOf(arr2[i]), 1);     
    }
  }
  element.className = arr1.join(" ");
}

// Add active class to the current button (highlight it)
var btnContainer = document.getElementById("myBtnContainer");
var btns = btnContainer.getElementsByClassName("btn");
for (var i = 0; i < btns.length; i++) {
  btns[i].addEventListener("click", function(){
    var current = document.getElementsByClassName("active");
    current[0].className = current[0].className.replace(" active", "");
    this.className += " active";
  });
}

//image expander
function showLargeImage(imgElement) {
    var previewSection = document.getElementById("imagePreviewSection"); // https://www.w3schools.com/jsref/met_document_getelementbyid.asp
    var previewImage = document.getElementById("previewImage"); 
    var mapDescription = document.getElementById("mapDescription");  // The paragraph to display the description
    var gridSection = document.querySelector(".gissection");

    currentImagesrc = imgElement.src;

    // Set the source of the image in the preview
    previewImage.src = imgElement.src; 

    // Get the description from the corresponding <p> tag
    var description = imgElement.nextElementSibling.textContent; //https://www.w3schools.com/jsref/prop_element_nextelementsibling.asp

    // Get the description FIRST
    var description = imgElement.nextElementSibling.textContent;

    // Set image
    previewImage.src = imgElement.src;

    // Set accessible text
    previewImage.alt = "Enlarged map view. " + imgElement.alt;

    // Update description panel
    mapDescription.textContent = description;


    
    // Show the preview section and hide the grid
    previewSection.style.display = "block"; 
    gridSection.style.display = "none"; 

    document.body.classList.add("preview-open");
}


function closePreview() {
    var previewSection = document.getElementById('imagePreviewSection');
    var gridSection = document.querySelector(".gissection");

    // Hide the preview section
    previewSection.style.display = 'none';

    // Show the image grid section
    gridSection.style.display = "flex";
    document.body.classList.remove("preview-open");
}

function downloadbtn() {
    // Find the original anchor tag associated with the clicked image
    const link = document.createElement("a");
    link.href = currentImagesrc;
    link.download = currentImagesrc.split("/").pop();
    link.click();
}

  





  