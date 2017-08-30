// Home Javascript

var home_page = "places";
load_home = function()
{
    switch(home_page)
    {
        case "places":
            load_places();
            break;
        case "parties":
            load_parties();
            break;
        default:
            load_places();
            break;
    }
}

load_page = function(page)
{
    switch(page)
    {
        case "places":
            window.location = '/places';
            break;
        case "parties":
            window.location = '/parties';
            break;
        case "me":
            window.location = '/me';
            break;
        case "groups":
            window.location = '/groups';
            break;
        case "groups_new":
            window.location = '/groups/new';
            break;
        case "food":
            window.location = '/food';
            break;
        case "cabs":
            window.location = '/cabs';
            break;
        case "settings":
            window.location = '/settings';
            break;
        default:
            window.location = '/places';
            break;
    }
}

// The following renders the navigator
render_navigator = function(data){
	$(".bar_support").html(data);
}

// This resets everything when switching between pages.
var remove_flash = false;
reset_slides = function(remove_flash)
{
	clearTimeout(load_places_repeat);
	if(remove_flash == true)
	{
		places_fade = false;
	}
	else
	{
		places_fade = true;
	}
	places_loaded = false;
	load_places_repeat = false;
	$(".content_body").hide();
}

update_browser = function(title, account_type, handle)
{
    if(handle == undefined)handle = "";
    if(handle != "" || handle == undefined)
    {
        handle = "/"+handle;
    }
    var new_state = "http://nitesite.co/"+account_type+handle;
    if(window.location != new_state)
    {
        //window.history.pushState("", title, "/"+account_type+handle);
        //setCookie("nav", window.location.pathname);
    }
}

load_account = function(id, account_type)
{
    switch(account_type)
    {
        case 'group':
            load_group(id);
            break;
        case 'place':
            load_place(id);
            break;
        case 'service':
            load_service(id);
            break;
        case 'user':
            load_user(id);
            break;
    }
}

$(function(){
	/*$('.bar_left span').addClass('greyed');
	$('.bar_left span').hover(function(){
		$(this).removeClass('greyed');
	});
	$('.bar_left span').mouseout(function(){
		$('.bar_left span').addClass('greyed');
	});*/
});

render_attending_users = function(id, type) // This renders the attending users for a place or party.
{
    var users;
    switch(type)
    {
        case 'place':
            users = get_attending_users_place(id);
            break;
        case 'party':
            users = get_attending_users_party(id);
            break;
    }

    var users_keys = Object.keys(users);
    var users_length = users_keys.length;
    if(users_length != 0)
    {
        render_users(users);
    }
    else
    {
        $('.profile_contents').hide().html('<div class="warning" style="left:15px;">Either you haven\'t voted yet or no one is going to this '+type+'.</div>').fadeIn(100);
    }
}