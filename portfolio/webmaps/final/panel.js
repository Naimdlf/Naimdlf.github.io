                alert("the JS linked currectly");
                
                function w3_open() {
                const sidebar = document.getElementById("mySidebar");
                const button = document.getElementById("togglebtn");

                if (sidebar.style.display === "block") {
                    sidebar.style.display = "none";
                    button.innerHTML = "&#x2630; Open Sidebar";
                } else {
                    sidebar.style.display = "block";
                    button.innerHTML = "&times; Close Sidebar";
                }
                }

                map.on('load', () => {
                // Array of your layers and corresponding checkbox IDs (use underscores for HTML ids)
                const layers = [
                    "City Labels",
                    "Transit Expendature",
                    "Urban Area",
                    "Public Transit",
                    "Drove Alone",
                    "Vehicle_Available"
                ];

                layers.forEach(layerId => {
                    // checkbox ID uses underscores replacing spaces for valid HTML ids
                    const checkboxId = layerId.replace(/\s/g, '_');
                    const checkbox = document.getElementById(checkboxId);

                    if (map.getLayer(layerId) && checkbox) {
                    // Set initial visibility based on checkbox status
                    map.setLayoutProperty(layerId, 'visibility', checkbox.checked ? 'visible' : 'none');

                    // Add listener to toggle visibility on checkbox change
                    checkbox.addEventListener('change', (e) => {
                        map.setLayoutProperty(layerId, 'visibility', e.target.checked ? 'visible' : 'none');
                    });
                    } else {
                    console.warn(`Layer or checkbox not found for: ${layerId}`);
                    }
                });
                });



