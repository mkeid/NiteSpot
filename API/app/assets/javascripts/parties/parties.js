/**
 * Name: Mohamed Eid
 * Date: 3/21/13
 * Time: 5:09 AM
 */

var parties_loaded = false;
var parties_fade = true;
var selected_year_party = "all";
var load_parties_repeat;

load_parties = function()
{
    if(window.location != 'http://nitesite.co/parties')
    {
        window.location = '/parties';
    }
    else
    {
        load_parties_page();
    }
}
load_parties_page = function(change_party_vote)
{
    reset_slides(true);
    update_browser("Parties", "parties", "");
    home_page = "parties";
    $('.item_parties span').addClass("parties-selected");
    if(typeof change_party_vote != "boolean")
    {
        change_party_vote = false;
    }
    var response = $.ajax({ type: "GET",
        url: "/parties/list.json?change="+change_party_vote.toString(),
        async: false
    }).responseText;
    var parties = jQuery.parseJSON(response);
    var parties_keys = Object.keys(parties);
    var parties_length = parties_keys.length;
    if(parties_length == 0)
    {
        $('.bar_support').remove();
        $('.content_body').html('<div class="warning">There are currently no parties going on today. If you want to host a party, do it through one of your groups.</div>').show();
    }
    else
    {
        var rendered_parties = '';
        if(parties[0].type == "vote")
        {
            parties_loaded = false;
            if(parties_loaded == false)
            {
                var change_party_button = '<span class="button_action greyed_out" style="cursor:default;width:118px">Change Vote</span>';
                render_navigator('<div class="stylish_text">Where are you thinking about going out tonight?</div>');
            }
            for(var x = 0; x < parties_length; x++)
            {
                var party_id = parties[x].id;
                var party_address = parties[x].address;
                var party_avatar = parties[x].avatar_location;
                var party_group = parties[x].group_name;
                var party_name = parties[x].name;
                var party_time = parties[x].time;
                rendered_parties = rendered_parties+"<li class='place tooltip' title='Time: "+party_time+"<br>Address: "+party_address+"' style='background:url("+party_avatar+")'><div class='place_top place_vote' onclick='party_vote("+party_id+")' style='background:rgba(0,0,0,0);'></div><div class='action place_bottom' data-id="+party_id+" data-class='party' data-action='attend' style='padding-top:3px;height:28px;'>"+party_name+"<br>["+party_group+"]</div></li>";
            }
        }
        else if(parties[0].type == "result")
        {
            parties_loaded = true;
            if(parties_loaded == true)
            {
                var classes_controller = '<div class="segmented_control"><div id="button_all" class="button" onclick="year_filter(&quot;all&quot;)">All</div><div id="button_fr" class="button" onclick="year_filter(&quot;fr&quot;)">Freshmen</div><div id="button_so" class="button" onclick="year_filter(&quot;so&quot;)">Sophomores</div><div id="button_jr" class="button" onclick="year_filter(&quot;jr&quot;)">Juniors</div><div id="button_sr" class="button" onclick="year_filter(&quot;sr&quot;)">Seniors</div></div>';
                var change_party_button = '<span class="button_action" onclick="load_parties_page(true)" style="width:118px;">Change Vote</span>';
                render_navigator(classes_controller);
            }
            for(var x = 0; x < parties_length; x++)
            {
                var party_id = parties[x].party_id;
                var party_address = parties[x].address;
                var party_avatar = parties[x].avatar_location;
                var party_group = parties[x].group_name;
                var party_name = parties[x].name;
                var party_time = parties[x].time;
                var img_male = "<span style='font-size:28px;margin-left:5px;'>♂</span>";
                var img_female = "<span style='font-size:28px;margin-left:5px;'>♀</span>";

                var gender_space = "<span style='padding-right:15px;'></span>";

                var party_votes_total_all = "<div class='place_votes_total'>"+parties[x].votes_total+"</div>";
                var party_votes_genders_all = "<div class='place_votes_genders'>"+parties[x].votes_male+img_male+gender_space+parties[x].votes_female+img_female+"</div>";

                var party_votes_total_fr = "<div class='place_votes_total'>"+parties[x].votes_total_fr+"</div>";
                var party_votes_genders_fr = "<div class='place_votes_genders'>"+parties[x].votes_male_fr+img_male+gender_space+parties[x].votes_female_fr+img_female+"</div>";

                var party_votes_total_so = "<div class='place_votes_total'>"+parties[x].votes_total_so+"</div>";
                var party_votes_genders_so = "<div class='place_votes_genders'>"+parties[x].votes_male_so+img_male+gender_space+parties[x].votes_female_so+img_female+"</div>";

                var party_votes_total_jr = "<div class='place_votes_total'>"+parties[x].votes_total_jr+"</div>";
                var party_votes_genders_jr = "<div class='place_votes_genders'>"+parties[x].votes_male_jr+img_male+gender_space+parties[x].votes_female_jr+img_female+"</div>";

                var party_votes_total_sr = "<div class='place_votes_total'>"+parties[x].votes_total_sr+"</div>";
                var party_votes_genders_sr = "<div class='place_votes_genders'>"+parties[x].votes_male_sr+img_male+gender_space+parties[x].votes_female_sr+img_female+"</div>";

                var party_top_all = "<div class='year_all'>"+party_votes_total_all+party_votes_genders_all+"</div>";
                var party_top_fr = "<div class='year_fr'>"+party_votes_total_fr+party_votes_genders_fr+"</div>";
                var party_top_so = "<div class='year_so'>"+party_votes_total_so+party_votes_genders_so+"</div>";
                var party_top_jr = "<div class='year_jr'>"+party_votes_total_jr+party_votes_genders_jr+"</div>";
                var party_top_sr = "<div class='year_sr'>"+party_votes_total_sr+party_votes_genders_sr+"</div>";
                var party = "<li class='place tooltip' title='Time: "+party_time+"<br>Address: "+party_address+"' style='background:url("+party_avatar+")'><div class='place_top'>"+party_top_all+party_top_fr+party_top_so+party_top_jr+party_top_sr+"</div><div class='action place_bottom' data-id-'"+party_id+"'data-class='party' data-action='show'  style='padding-top:3px;height:28px;'>"+party_name+"<br>["+party_group+"]</div></li>";
                rendered_parties = rendered_parties+party;
            }
        }
        $('.content_body').css('margin-top', '55px');
        $('.ns_title').html('Parties'+change_party_button);
        $('.content_body').html("<ul class='body_home'>"+rendered_parties+'</ul>').show();
        year_filter(selected_year, false);
        initialize_tooltip();
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
    }
}

load_party_modal = function(group_id)
{

}

var party_public = true;
throw_party = function(group_id) // This function throws a party for a group.
{
    var party_month = parseInt($('#party_month').val());
    var party_day = parseInt($('#party_day').val());
    if(party_month == party_month_default && party_day < party_day_default)
    {
        alert('You can\'t throw a party in the past.');
    }
    else
    {
        var party_hour = parseInt($('#party_hour').val());
        // Since Rails handles a 24 hour clock system, we adjust it appropriately here.
        if($('#party_meridiem').val() == 'PM')
        {
            party_hour +=12;
        }
        $.ajax({
            type: "POST",
            url: "/parties",
            data: {
                "group_id": group_id,
                "party[name]": $('#party_name').val(),
                "party[address]": $('#party_address').val(),
                "party[description]": $('#party_description').val(),
                "party[public]": party_public,
                "party[month]": party_month,
                "party[day]": party_day,
                "party[hour]": party_hour,
                "party[minute]": parseInt($('#party_minute').val())
            },
            success: function(){
                window.location = '/groups/'+group_id.toString()+'/members#sucessParty';
            }
        });
    }
}

update_party = function(party_id) // This function throws a party for a group.
{
    var party_month = parseInt($('#party_month').val());
    var party_day = parseInt($('#party_day').val());
    if(party_month == party_month_default && party_day < party_day_default)
    {
        alert('You can\'t throw a party in the past.');
    }
    else
    {
        var party_hour = parseInt($('#party_hour').val());
        // Since Rails handles a 24 hour clock system, we adjust it appropriately here.
        if($('#party_meridiem').val() == 'PM')
        {
            party_hour +=12;
        }
        $.ajax({
            type: "PUT",
            url: "/parties/"+party_id,
            data: {
                "party[name]": $('#party_name').val(),
                "party[address]": $('#party_address').val(),
                "party[description]": $('#party_description').val(),
                "party[public]": party_public,
                "party[month]": party_month,
                "party[day]": party_day,
                "party[hour]": party_hour,
                "party[minute]": parseInt($('#party_minute').val())
            },
            success: function(){
                window.location = '/parties/'+party_id.toString()
            }
        });
    }
}

load_party = function(id)
{
    if(window.location != 'http://nitesite.co/parties/'+id)
    {
        window.location = '/parties/'+id;
    }
    else
    {
        load_party_page(id);
    }
}
load_party_page = function(party_id)
{
    reset_slides();
    var response = $.ajax({ type: "GET",
        url: "/parties/"+party_id.toString()+".json",
        async: false
    }).responseText;
    var party = jQuery.parseJSON(response);
    $('title').html(party.name);

    var head_item_avatar = '<li><img src="'+party.avatar_location+'"></li>';
    var head_item_name = '<li>'+party.name+' [<span class="user_name" onclick="load_group('+party.group_id+')">'+party.group_name+'</span>]</li>';
    var head_items = head_item_avatar+head_item_name;
    var head_list = '<ul>'+head_items+'</ul>';
    var profile_head = '<div class="profile_head">'+head_list+'</div>';

    var profile_bar = '<div class="profile_bar" style="left:-58px;text-align:center;"><span style="color:rgb(80,80,80);font-family:poet;font-size:20px;position:relative;top:5px;">People going here:</span></div>';
    var profile_contents = '<div class="profile_contents"></div>';
    var profile_body = profile_head+profile_bar+profile_contents;

    $('.content_body').html(profile_body).fadeIn(100); // This will put all the new HTML into the content body.

    var classes_controller = '<div class="segmented_control"><div id="button_all" class="button" onclick="year_filter(&quot;all&quot;)">All</div><div id="button_fr" class="button" onclick="year_filter(&quot;fr&quot;)">Freshmen</div><div id="button_so" class="button" onclick="year_filter(&quot;so&quot;)">Sophomores</div><div id="button_jr" class="button" onclick="year_filter(&quot;jr&quot;)">Juniors</div><div id="button_sr" class="button" onclick="year_filter(&quot;sr&quot;)">Seniors</div></div>';
    render_navigator(classes_controller);

    render_attending_users(party_id, 'party');
}

party_vote = function(party_id, refresh_parties_page)
{
    refresh_parties_page = typeof refresh_parties_page !== 'undefined' ? refresh_parties_page : true;
    $.ajax({
        type: "POST",
        url: "/parties/"+party_id+'/vote',
        success: function() {
            window.location.reload();
        }
    });
}

get_attending_users_party = function(party_id)
{
    var response = $.ajax({ type: "GET",
        url: "/parties/attending_users/"+party_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}
