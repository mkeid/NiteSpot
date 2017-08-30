settings_initialize = function()
{
    // Initialized variables.
    var settings_gender;
    var settings_privacy;
    var settings_year;


	// The following selects the gender.
	$("#button_settings_female").click(function(){
		select_gender("female");
	});
	$("#button_settings_male").click(function(){
		select_gender("male");
	});
	
	// The following selects the privacy.
	$("#button_settings_public").click(function(){
		select_privacy("public");
	});
	$("#button_settings_private").click(function(){
		select_privacy("private");
	});
	
	// The following selects the year.
	$("#button_settings_fr").click(function(){
		select_year("freshmen");
	});
	$("#button_settings_so").click(function(){
		select_year("sophomore");
	});
	$("#button_settings_jr").click(function(){
		select_year("junior");
	});
	$("#button_settings_sr").click(function(){
		select_year("senior");
	});
}

// The following loads the settings slide.
select_gender = function(gender)
{
	$(".radio[data-name=gender]").removeClass("radio_selected");
	switch(gender)
	{
		case "male":
			$("#button_settings_male").addClass("radio_selected");
			break;
		case "female":
			$("#button_settings_female").addClass("radio_selected");
			break;
	}
	settings_gender = gender;
}

select_privacy = function(privacy)
{
	$(".radio[data-name=privacy]").removeClass("radio_selected");
	switch(privacy)
	{
		case "public":
			$("#button_settings_public").addClass("radio_selected");
			break;
		case "private":
			$("#button_settings_private").addClass("radio_selected");
			break;
	}
	settings_privacy = privacy;
}


select_year = function(year)
{
	$(".radio[data-name=year]").removeClass("radio_selected");
	switch(year)
	{
		case "freshmen":
			$("#button_settings_fr").addClass("radio_selected");
			break;
		case "sophomore":
			$("#button_settings_so").addClass("radio_selected");
			break;
		case "junior":
			$("#button_settings_jr").addClass("radio_selected");
			break;
		case "senior":
			$("#button_settings_sr").addClass("radio_selected");
			break;
	}
	settings_year = year;
}

// The following loads the settings slide.
load_settings = function()
{
	reset_slides();
    $('.item_settings span').addClass("settings-selected");
	var button_picture = "<span class='button_support' onclick='create_picture_modal()'>Picture</span>";
	var button_save = "<span class='button_action' onclick='settings_save()'>Save</span>";
	$(".bar_support").remove();
    $('.ns_title').html(button_picture+'Settings'+button_save);
	// Initializations:
	settings_initialize();
	// The following initializes all the selections.
	select_gender(user_gender);
	select_privacy(user_privacy);
	select_year(user_year);
}

settings_save = function()
{
	var password1 = $("#password1").val();
	var password2 = $("#password2").val();
	var password3 = $("#password3").val()
	$.ajax({  
		type: "PUT",
		url: "/users/update",
		data: {
			"name_first": $("#name_first").val(),
			"name_last": $("#name_last").val(),
			"password1": password1,
			"password2": password2,
			"password3": password3,
			"gender": settings_gender,
			"year": settings_year,
			"privacy": settings_privacy
		},
		success: function() {
            setCookie("gender", settings_gender, 1);
            setCookie("privacy", settings_privacy, 1);
            setCookie("year", settings_year, 1);
            user_gender = settings_gender;
            user_privacy = settings_privacy;
            user_year = settings_year;
        }
	}); 
	if(password2 != password3)
	{
		create_alert("Your password does not match.");
	}
	else if(password3 != "" && password3.length < 6)
	{
		create_alert("Your password must be at least 6 characters long.");
	}
	else
	{
		create_alert("Your settings have been saved.");
	}
}

create_picture_modal = function()
{
	create_modal("#picture_upload_modal");
}