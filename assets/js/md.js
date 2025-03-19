
// Open the modal without a backdrop
document.querySelectorAll('[data-toggle="modal"]').forEach(trigger => {
    trigger.addEventListener('click', function () {
        const modalId = this.getAttribute('href');
        const modalElement = document.querySelector(modalId);
        const modal = new bootstrap.Modal(modalElement, {
            backdrop: false
        });
        modal.show();
    });
});