

function toggleDropdown(id) {
  document.querySelectorAll('.dropdown-content').forEach(drop => {
    if (drop.id !== id) drop.classList.remove('show');
  });
  document.getElementById(id).classList.toggle('show');
}

window.onclick = function(event) {
  if (!event.target.matches('button')) {
    document.querySelectorAll('.dropdown-content').forEach(drop => {
      drop.classList.remove('show');
    });
  }
}