create_modal = function(modal)
{
	$(".backdrop").fadeIn();
	$(modal).fadeIn();
}

close_modal = function()
{
	$(".backdrop").click(function(e){
		var clickedOn = $(e.target);
		if(clickedOn.parents().andSelf().is('.modal'))
		{
		}
		else
		{
			$(".backdrop").fadeOut(120, function(){
                $(this).css('left', '0');
                hide_alerts()
            });
			$(".modal").fadeOut();
		}
	});
}

$(function(){
	close_modal();
});