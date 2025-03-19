 <style>
/* Remove box shadow for the modal */
#datePickerModal .modal-content {
    box-shadow: none !important;
    border: none !important;
    background-color: transparent !important;
}

/* Remove box shadow for the modal-dialog */
#datePickerModal .modal-dialog {
    box-shadow: none !important;
    border: none !important;
}

.highlight-today {
    background: #ffeb3b !important;
    /* Bright yellow for highlighting */
    color: #000 !important;
    border-radius: 50%;
    cursor: not-allowed;
    /* Indicate it's not clickable */
}

.flatpickr-disabled {
    pointer-events: none;
    /* Prevent any interaction */
    opacity: 0.6;
    /* Dim disabled dates */
}


/* Remove background and shadow for modal backdrop */
.modal-backdrop {
    box-shadow: none !important;
}

/* Flatpickr container clean-up */
.flatpickr-calendar {
    box-shadow: none !important;
    border: none !important;
}

/* General clean-up for modal body */
.modal-body {
    padding: 0;
    background-color: transparent !important;
}

/* Hide any padding from modal content */
.modal-header,
.modal-footer {
    display: none;
    /* If not being used */
}

/* Center the modal properly */
.modal.fade.show {
    display: flex !important;
    align-items: center;
    justify-content: center;
}
 </style>