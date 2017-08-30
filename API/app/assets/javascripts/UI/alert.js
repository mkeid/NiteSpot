// Alerts

create_alert = function(text)
{
	$(".alert_list").html("");
	var alert_box = "<li class='alert'><h2>"+text+"</h2></li>";
	$(".alert_list").html(alert_box);
	$(".alert").hide();
	$(".alert").fadeIn(100);
	setTimeout($(".alert").fadeOut(12000), 1000000);
}