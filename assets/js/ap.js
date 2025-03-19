
 const doaInput = document.getElementById("doa");
        const modalElement = document.getElementById("datePickerModal");

        // Initialize Flatpickr and bind it to the container in the modal
        flatpickr("#flatpickr-container", {
            inline: true, // Display the calendar inline
            dateFormat: "Y-m-d", // Format date as YYYY-MM-DD
            minDate: "tomorrow", // Prevent selection of today and past dates
            onDayCreate: function(dObj, dStr, fp, dayElem) {
                const today = new Date();
                const todayStr = fp.formatDate(today, "Y-m-d");

                // Disable past dates, including today
                if (dayElem.dateObj && dayElem.dateObj < today) {
                    dayElem.classList.add("flatpickr-disabled");
                    dayElem.setAttribute("aria-disabled", "true");
                }

                // Check if the current day is today
                if (dayElem.dateObj && fp.formatDate(dayElem.dateObj, "Y-m-d") === todayStr) {
                    // Highlight today's date
                    dayElem.classList.add("highlight-today");

                    // Disable today's date (if needed)
                    dayElem.classList.add("flatpickr-disabled");
                    dayElem.setAttribute("aria-disabled", "true");
                }
            },
            onChange: function(selectedDates, dateStr) {
                // Set the selected date to the main input field
                doaInput.value = dateStr;

                // Close the modal
                const modal = bootstrap.Modal.getInstance(modalElement);
                modal.hide();
            }
        });


        // Open the modal when the main input field is clicked
        doaInput.addEventListener("click", function() {
            const modal = new bootstrap.Modal(modalElement, {
                backdrop: false // Disable backdrop completely
            });
            modal.show();
        });