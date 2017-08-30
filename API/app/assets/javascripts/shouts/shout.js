/**
 * Name: Mohamed Eid
 * Date: 3/27/13
 * Time: 4:19 PM
 */

var ShoutModel = Backbone.Model.extend({
    urlRoot: '/shouts',
    defaults: {
        message: null,
        reference_name: null,
        referenced_party_id: null,
        referenced_place_id: null,
        shout_type: null
    },
    initialize: function() {
        var message;
        var reference_name = this.get('reference_name');
        var referenced_party_id = this.get('referenced_party_id');
        var referenced_place_id = this.get('referenced_place_id');
        switch(this.get('shout_type')) {
            case 'party_throw':
                message = 'is throwing a <a href="/parties/'+referenced_party_id+'/attending_users">party</a> ';
                break;
            case 'party_attendance':
                message = 'is attending <a href="/parties//attending_users">'+reference_name+'\'s</a> <a href="/parties/'+referenced_party_id+'/attending_users">party</a>';
                break;
            case 'place_attendance':
                message = 'is attending <a href="/places/'+referenced_place_id+'/attending_users" rel="popover" data-id="'+referenced_place_id+'" data-class="place">'+reference_name+'</a>';
                break;
            case 'place_attendance_change':
                message = 'is now going to <a href="/places/'+referenced_place_id+'/attending_users">'+reference_name+'</a>';
                break;
            case 'status':
                message = this.get('message');
                break;
            default:
                message = this.get('message');
                break;
        }
        this.set('message', message);
    }
});

load_shout = function(shout_id)
{
    if(window.location != 'http://nitesite.co/shouts/'+shout_id)
    {
        window.location = '/shouts/'+shout_id;
    }
    else
    {
        load_shout_page(shout_id);
    }
}
load_shout_page = function(shout_id)
{
    var shout_account_id, shout_account_type, shout_delete, shout_item_left, shout_item_message, shout_item_name, shout_item_right, shout_like, shout_liked_users_list, shout_user_likes, shout_item_bottom;
    reset_slides();

    var response = $.ajax({ type: "GET",
        url: "/shouts/"+shout_id+".json",
        async: false
    }).responseText;
    var shout = jQuery.parseJSON(response);
    var avatar_location = shout.avatar_location;
    var is_liked = shout.is_liked;
    var liked_users = shout.liked_users;
        var liked_users_keys = Object.keys(liked_users);
        var liked_users_length = liked_users_keys.length;
    var message = shout.message;
    var name = shout.name;
    var time = shout.time;
    var group_id = shout.group_id;
    var user_id = shout.user_id;

    if(group_id != null)
    {
        shout_account_type = 'group';
    }
    else if(user_id != null)
    {
        shout_account_type = 'user';
    }
    switch(shout_account_type)
    {
        case 'group':
            shout_account_id = shout.group_id;
            break;
        case 'place':
            shout_account_id = shout.place_id;
            break;
        case 'service':
            shout_account_id = shout.service_id;
            break;
        case 'user':
            shout_account_id = shout.user_id;
            break;
    }

    var is_self = false;
    if(shout_account_id == account_id) is_self = true;

    shout_item_left = '<div class="follow_item_left"><img onclick="load_account('+shout_account_id+', \''+shout_account_type+'\')" src="'+avatar_location+'"></div>';

    shout_item_name = '<div class="user_name" onclick="load_account('+shout_account_id+', \''+shout_account_type+'\')">'+name+'</div><br>';
    shout_item_message = '<div class="profile_shout_message">'+message+'</div>';
    shout_item_right = '<div class="follow_item_right">'+shout_item_name+shout_item_message+'</div><span class="shout_time">'+time+'</span>';

    if(is_self == true)
    {
        shout_delete = '<div class="shout_destroy shout_bottom_item" data-shout_id=""'+shout_id+'">Delete</div>'
    }
    else
    {
        shout_delete = '';
    }

    if(is_liked == true)
    {
        shout_like = '<div class="shout_unlike shout_'+shout_id+'_like liked" style="margin-left:7px;width:42px;">Liked</div>';
    }
    else
    {
        shout_like = '<div class="shout_like shout_'+shout_id+'_like shout_bottom_item" style="margin-left:7px;width:42px;">Like</div>';
    }

    shout_item_bottom = '<div class="shout_bottom">'+shout_like+shout_delete+'</div>';

    var rendered_liked_users = '';


    for(var i = 0; i < liked_users_length; i++)
    {
        var liked_user_avatar, liked_user_id, liked_user_item, liked_user_item_left, liked_user_name, liked_time, liked_user_item_right;
        liked_user_avatar = liked_users[i].avatar_location;
        liked_user_id = liked_users[i].user_id;
        liked_user_name = liked_users[i].name;
        liked_time = liked_users[i].time;

        liked_user_item_left = '<div class="left"><img data-link="user" data-id='+liked_user_id+' src="'+liked_user_avatar+'" onclick="load_user('+liked_user_id+')"></div>';
        liked_user_item_right = '<div class="right"><div><div data-link="user" data-id='+liked_user_id+' class="user_name" onclick="load_user('+liked_user_id+')">'+liked_user_name+'</div>&nbsp;likes this.</div><div data-location="shout" class="shout_time" style="float:right;">'+liked_time+'</div></div>';

        liked_user_item = '<li class="follow_item" style="min-height:0px;">'+liked_user_item_left+liked_user_item_right+'</li>'
        rendered_liked_users = rendered_liked_users+liked_user_item;
    }

    shout_liked_users_list = '<ul class="liked_users_list">'+rendered_liked_users+'</ul>';

    var rendered_shout = '<div data-id='+shout_id+' data-location="shout_page" class="follow_item shout_item data-id="'+shout_id+'"><div class="follow_item_contents">'+shout_item_left+shout_item_right+'</div>'+shout_item_bottom+'</div>';
    $('.content_body').html('<div data-shout-id="'+shout_id+'" class="body_shout"><div>'+rendered_shout+shout_liked_users_list+'</div></div>').fadeIn(100);
    var title = liked_users_length+' people like this.';
    if(liked_users_length == 1) title = '1 person likes this.'
    //title = '<div class="segmented_control"><div class="button">Replies</div><div class="button">'+liked_users_length+' Likes</div></div>'
    render_navigator('<div style="color:rgb(80,80,80);font-family:poet;font-size:20px;text-align:center;margin: 10px 325px 0 0;">'+title+'</div>');
    initialize_shout();
    //update_browser(name, "shouts", shout_id);
}

shout_destroy = function(shout_id) // This function deletes a shout.
{
    $.ajax({
        type: "DELETE",
        url: "/shouts/"+shout_id,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function() {
            var count_shouts_element = $('div[data-label=count_shouts]');
            var count_shouts = count_shouts_element.html();
            count_shouts = parseInt(count_shouts)-1;
            count_shouts_element.html(count_shouts);
            $('.shout_item[data-id='+shout_id+']').hide();
        }
    });
}
shout_liking = function(shout_id) // This function likes a shout.
{
    $.ajax({
        type: "POST",
        url: "/shouts/"+shout_id+"/like",
        success: function() {
            $('.shout_'+shout_id+'_like').removeClass('shout_bottom_item').addClass('liked').data('action', 'unlike').html('<i class="icon-heart icon-white"></i> Liked');
            shout_open(shout_id);
            var body_shout = $('.body_shout');
            if(body_shout.css('display') != undefined && body_shout.data('shout-id') == shout_id) load_shout(shout_id);
        }
    });
}
shout_unlike = function(shout_id) // This function unlikes a shout.
{
    $.ajax({
        type: "POST",
        url: "/shouts/"+shout_id+"/unlike",
        success: function() {
            $('.shout_'+shout_id+'_like').removeClass('liked').addClass('shout_bottom_item').data('action', 'like').html('<i class="icon-heart"></i> Like');
            if($('.shout_profile_'+shout_id+' .shout_user_likes').css('display') == 'block')
            {
                shout_open(shout_id);
                var body_shout = $('.body_shout');
                if(body_shout.css('display') != undefined && body_shout.data('shout-id') == shout_id) load_shout(shout_id);
            }
        }
    });
}

shout = function() // This function creates a shout and updates the feed.
{
    if($("#shout_text").val() != ""){
        $.ajax({
            type: "POST",
            url: "/shouts/create",
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
            data: {
                "message": $("#shout_text").val(),
                "type": "status"
            },
            success: function() {
                load_feed();
                $("#shout_text").val("");
                $('.shout_character_count').html("");
                var list_shouts = $('ul[data-label=list_shouts]');
                if(list_shouts.css('display') == 'block' && list_shouts.data('user-id') == account_id)
                {
                    var count_shouts_element = $('div[data-label=count_shouts]');
                    var count_shouts = count_shouts_element.html();
                    count_shouts = parseInt(count_shouts)+1;
                    count_shouts_element.html(count_shouts);
                    load_user_shouts(account_id);
                }
            }
        });
    }
}

shout_alter = function(shout_id) // This function will check to open or close a shout.
{
    switch($('.follow_item[data-id='+shout_id+'] .shout_user_likes').css('display'))
    {
        case 'none':
            shout_open(shout_id);
            break;
        default:
            shout_close(shout_id);
            break;
    }
}
shout_close = function(shout_id) // This function removes additional information of a shout that was previously opened.
{
    $('.follow_item[data-id='+shout_id+'] .shout_user_likes').animate({height: '-=29'}, 40,function(){$(this).hide()});
}

shout_open = function(shout_id) // This function adds further information of a shout inside its html element.
{
    var shout = get_shout(shout_id);
    var users_liked = shout.liked_users;
    var users_liked_keys = Object.keys(users_liked);
    var users_liked_length = users_liked_keys.length;
    var rendered_users = "";

    if(users_liked_length > 10)
    {
        users_liked_length = 10;
    }

    var avatar_location, user_name, user_id;
    for(var x = 0; x < users_liked_length; x ++)
    {
        avatar_location = users_liked[x].avatar_location;
        user_name = users_liked[x].name;
        user_id = users_liked[x].user_id;

        rendered_users = rendered_users+'<li data-link="user" data-id='+user_id+'><a href="/users/'+user_id+'/feed"><img src="'+avatar_location+'" class="tooltip"  title="'+user_name+'"></a></li>';
    }
    var s = 's';
    if(users_liked_length == 1) s = '';
    var num_likes = '<a href="/shouts/'+shout_id+'/likes"><div data-id='+shout_id+' class="num_likes shout_item shout_load"><div style="margin:0;">'+users_liked_length+'</div><div style="color:rgb(90,90,90)">Like'+s+'</div></a></div>';
    var likes = '<ul>'+rendered_users+'</ul>';
    $('.follow_item[data-id='+shout_id+'] .shout_user_likes').css('height', '0px').show().animate({height: '+=29'}, 40).html(num_likes+likes).fadeIn(100);
    initialize_tooltip();
}
