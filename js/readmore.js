function myFunction(sectionId) {
    var dots = document.getElementById("dots" + sectionId);
    var moreText = document.getElementById("more" + sectionId);
    var btnText = document.getElementById("myBtn" + sectionId);
  
    if (dots.style.display === "none") {
      dots.style.display = "inline";
      btnText.innerHTML = "Read more";
      moreText.style.display = "none";
    } else {
      dots.style.display = "none";
      btnText.innerHTML = "Read less";
      moreText.style.display = "inline";
    }
  }