$(window).on("load", function () {
  setTimeout(function () {
    $("#loader-overlay").fadeOut("slow", function () {
      $("#content").fadeIn("slow");
    });
  }, 500); // optional delay
});
