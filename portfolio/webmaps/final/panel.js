                
                // sidebar with slight mod from W3Schools
                function w3_open() {
                    const sidebar = document.getElementById("mySidebar");
                    const button = document.getElementById("togglebtn");

                    sidebar.classList.toggle("open");
                    // when the sidebar is open it changes the button HTML and vice versa
                    if (sidebar.classList.contains("open")) {
                        // Unicode symbols: https://www.w3schools.com/charsets/ref_utf_arrows.asp
                        button.innerHTML = "&times; Close Sidebar";
                    } else {
                        button.innerHTML = "&#x2630; Open Sidebar";
                    }
                }
                