const sidebar = document.getElementById("mySidebar");
const toggleBtn = document.getElementById("sidebarbtn");
const sidebarContent = document.getElementById("sidebarContent");

toggleBtn.onclick = () => { // Check current width of the sidebar 
if (sidebar.style.width === "320px") { // If open, close it 
sidebar.style.width = "0"; toggleBtn.innerHTML = "☰ Sidebar"; } else { // If closed, open it 
sidebar.style.width = "320px"; toggleBtn.innerHTML = "× Close"; } };

