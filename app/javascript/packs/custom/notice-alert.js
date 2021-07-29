$(document).ready(function () {
    $("#scroll-top").click(function () {
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        $("#scroll-top").fadeOut("slow");
    });
});

$(document).ready(function () {
    setTimeout(function () {
        $('#notice-wrapper').fadeOut("slow", function () {
            $(this).remove();
        })
        $("#scroll-top").fadeOut("slow");
    }, 3000); //Hides notice wrapper and notificator after that time
});

