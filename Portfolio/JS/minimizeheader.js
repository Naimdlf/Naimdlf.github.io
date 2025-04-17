//https://www.w3schools.com/howto/howto_js_shrink_header_scroll.asp

const header = document.querySelector("header");
const title = document.querySelector("h1");
const buttons = document.querySelectorAll("button");

window.onscroll = function () {
  if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
    header.style.padding = "1px 5px";
    header.style.borderTopLeftRadius = "0";
    header.style.borderTopRightRadius = "0";
    header.style.transform = "scaleX(0.96)";
    title.style.fontSize = "16px";
    buttons.forEach(btn => {
      btn.style.padding = "1px 5px";
    });
  } else {
    header.style.padding = "10px 15px";
    header.style.borderTopLeftRadius = "8px";
    header.style.borderTopRightRadius = "8px";
    header.style.transform = "scaleX(1)";
    title.style.fontSize = "24px";
    buttons.forEach(btn => {
      btn.style.padding = "10px 10px";
    });
  }
};
