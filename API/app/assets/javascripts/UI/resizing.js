var $window = $(window);
$('.ns').ready(function(){
   adjust_sizes();
});
$window.resize(function(){
    adjust_sizes();
});

adjust_sizes = function()
{
    if($window.width() < 900)
    {
        $('.ns').css('left', '-68px');
    }
    else
    {
        $('.ns').css('left', '0');
    }
    if($window.width() < 675)
    {
        $('.bar_support .segmented_control').css('right', '0');
        $('.bar_right').hide();
        $('.ns_title').css('right', '-10px');
        $('body').css('padding', '48px 0 0 0');
    }
    else
    {
        $('.bar_support .segmented_control').css('right', '100px');
        $('.bar_right').show();
        $('.ns_title').css('right', '90px');
        $('body').css('padding', '48px 200px 0 0');
    }
}