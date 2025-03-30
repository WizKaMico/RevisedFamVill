<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <?php
        if (!empty($_GET['message'])) {
            if ($_GET['message'] == 'success') {
                    echo '
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            Swal.fire({
                                icon: "success",
                                title: "Submission request has been submitted",
                                text: ""
                            });
                        });
                    </script>';
            } else {
                    echo '
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            Swal.fire({
                                icon: "error",
                                title: "An error occurred",
                                text: ""
                            });
                        });
                    </script>';
            }
        }
    ?>

    </script>
