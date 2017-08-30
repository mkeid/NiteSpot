// The following loads the places slide.
var places_loaded = false;
var places_fade = true;
var selected_year = "all";
var load_places_repeat;
load_places = function()
{
    if(window.location != 'http://nitesite.co/places')
    {
        window.location = '/places';
    }
    else
    {
        load_places_page();
    }
}
load_places_page = function(change_place_vote){
    reset_slides(true);
    update_browser("Places", "places", "");
    home_page = "places";
    $('.item_places span').addClass("places-selected");
    if(typeof change_place_vote != "boolean")
    {
        change_place_vote = false;
    }
    var places = get_places(change_place_vote);
    var places_keys = Object.keys(places);
    var places_length = places_keys.length;
    var rendered_places = "";
    if(places[0].type == "vote")
    {
        places_loaded = false;
        if(places_loaded == false)
        {
            var change_place_button = '<span class="button_action greyed_out" style="cursor:default;">Change Vote</span>';
            render_navigator('<div class="stylish_text">Where are you thinking about going out tonight?</div>');
        }
        for(var x = 0; x < places_length; x++)
        {
            var place_id = places[x].id;
            var place_avatar = places[x].avatar_location;
            var place_name = places[x].name;
            rendered_places = rendered_places+"<li class='place' style='background:url("+place_avatar+")'><div class='place_top place_vote' onclick='place_vote("+place_id+")' style='background:rgba(0,0,0,0)'></div><div class='place_bottom' onclick='place_vote("+places[x].id+")'>"+place_name+"</div></li>";
        }
    }
    else if(places[0].type == "result")
    {
        places_loaded = true;
        if(places_loaded == true)
        {
            var classes_controller = '<div class="segmented_control"><div id="button_all" class="button" onclick="year_filter(&quot;all&quot;)">All</div><div id="button_fr" class="button" onclick="year_filter(&quot;fr&quot;)">Freshmen</div><div id="button_so" class="button" onclick="year_filter(&quot;so&quot;)">Sophomores</div><div id="button_jr" class="button" onclick="year_filter(&quot;jr&quot;)">Juniors</div><div id="button_sr" class="button" onclick="year_filter(&quot;sr&quot;)">Seniors</div></div>';
            var change_place_button = '<span class="button_action" onclick="load_places_page(true)">Change Vote</span>';
            render_navigator(classes_controller);
        }
        for(var x = 0; x < places_length; x++)
        {
            var place_id = places[x].id;
            var place_avatar = places[x].avatar_location;
            var place_name = places[x].name;
            var img_male = "<span style='font-size:28px;margin-left:5px;'>♂</span>";
            var img_female = "<span style='font-size:28px;margin-left:5px;'>♀</span>";

            var gender_space = "<span style='padding-right:15px;'></span>";

            var place_votes_total_all = "<div class='place_votes_total'>"+places[x].votes_total+"</div>";
            var place_votes_genders_all = "<div class='place_votes_genders'>"+places[x].votes_male+img_male+gender_space+places[x].votes_female+img_female+"</div>";

            var place_votes_total_fr = "<div class='place_votes_total'>"+places[x].votes_total_fr+"</div>";
            var place_votes_genders_fr = "<div class='place_votes_genders'>"+places[x].votes_male_fr+img_male+gender_space+places[x].votes_female_fr+img_female+"</div>";

            var place_votes_total_so = "<div class='place_votes_total'>"+places[x].votes_total_so+"</div>";
            var place_votes_genders_so = "<div class='place_votes_genders'>"+places[x].votes_male_so+img_male+gender_space+places[x].votes_female_so+img_female+"</div>";

            var place_votes_total_jr = "<div class='place_votes_total'>"+places[x].votes_total_jr+"</div>";
            var place_votes_genders_jr = "<div class='place_votes_genders'>"+places[x].votes_male_jr+img_male+gender_space+places[x].votes_female_jr+img_female+"</div>";

            var place_votes_total_sr = "<div class='place_votes_total'>"+places[x].votes_total_sr+"</div>";
            var place_votes_genders_sr = "<div class='place_votes_genders'>"+places[x].votes_male_sr+img_male+gender_space+places[x].votes_female_sr+img_female+"</div>";

            var place_top_all = "<div class='year_all'>"+place_votes_total_all+place_votes_genders_all+"</div>";
            var place_top_fr = "<div class='year_fr'>"+place_votes_total_fr+place_votes_genders_fr+"</div>";
            var place_top_so = "<div class='year_so'>"+place_votes_total_so+place_votes_genders_so+"</div>";
            var place_top_jr = "<div class='year_jr'>"+place_votes_total_jr+place_votes_genders_jr+"</div>";
            var place_top_sr = "<div class='year_sr'>"+place_votes_total_sr+place_votes_genders_sr+"</div>";
            var place = "<li class='place' style='background:url("+place_avatar+")'><div class='place_top'>"+place_top_all+place_top_fr+place_top_so+place_top_jr+place_top_sr+"</div><div class='action place_bottom' data-id='"+places[x].id+"' data-class='place' data-action='show'>"+place_name+"</div></li>";
            rendered_places = rendered_places+place;
        }
    }
    var button_stats = '<span class="button_support">Statistics</span>';
    $('.content_body').css('margin-top', '55px');
    $('.ns_title').html(button_stats+'Places'+change_place_button);
    //$(".content_body").html("<ul class='body_home'>"+rendered_places+"</ul>");
    year_filter(selected_year, false);
    if(places_fade == true)
    {
        $(".content_body").fadeIn(100);
        year_filter(selected_year, true);
        places_fade = false;
    }
    else
    {
        $(".content_body").show();
        year_filter(selected_year, false);
    }

	if(change_place_vote == true)
	{
		clearTimeout(load_places_repeat);
	}
	else if(change_place_vote == false && places_loaded == true)
	{
		//load_places_repeat = setTimeout(function() { load_places_page(false, selected_year); }, 5000);
	}
}

// The following votes on a place
place_attend = function(place_id){
    $.ajax({
        type: "POST",
        url: "/places/"+place_id+"/attend",
        success: function() {
            document.location = '/places'
        }
    });
}

load_place = function(id)
{
    if(window.location != 'http://nitesite.co/places/'+id)
    {
        window.location = '/places/'+id;
    }
    else
    {
        load_place_page(id);
    }
}
load_place_page = function(place_id, place_relation, place_name)
{
    var button_stats = generate_html({tag: 'span', class: 'action button_support', data: {id: place_id, class: 'place', acton: 'statistics'}, html: 'Statistics'});
    var button_attend;
    switch(place_relation)
    {
        case 'attending':
            button_attend = generate_html({tag: 'span', class: 'button_action greyed_out', html: 'Attending'});
            break;
        case 'not_attending':
            button_attend = generate_html({tag: 'span', id: 'button_attend', class: 'action button_action', data: {id: place_id, class: 'place', action: 'attend'}, html: 'Attend'});
            break;
    }
    $('.ns_title').html(button_stats+place_name+button_attend);
}