const sidebar = document.getElementById("mySidebar");
const toggleBtn = document.getElementById("toggleSidebarBtn");
const sidebarContent = document.getElementById("sidebarContent");

toggleBtn.onclick = () => {
  const currentWidth = window.getComputedStyle(sidebar).width;
  if (sidebar.style.width === "250px") {
    // close
    sidebar.style.width = "0";
    toggleBtn.innerHTML = "☰ Menu";
  } else {
    // open
    sidebar.style.width = "250px"; // or whatever width you want
    toggleBtn.innerHTML = "× Close";
  }
};
