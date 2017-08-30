/**
 * Name: Mohamed Eid
 * Date: 5/29/13
 * Time: 4:07 PM
 */

/**************************************************
 * The following resets the unchecked notification
 * count back to 0.
 *************************************************/
check_notifications = function()
{
    $.ajax({
        type: "POST",
        url: "/notifications/check"
    });
    $('span[data-label=count_notifications]').html('0');
}

close_menu_notifications = function() // This function closes (slides) the notifications menu.
{
    $('.menu_notifications').animate({left: '-=202'}, 80, function(){$(this).css('left', '-102px').hide();});
}

open_menu_notification = function(user_id) // This function creates a menu containing some of the user's notifications.
{
    close_menu_requests();
    var notifications = get_notifications();
    var notifications_keys = Object.keys(notifications);
    var notifications_length = notifications_keys.length;
    var rendered_notifications = '';

    var avatar, avatar_group, avatar_user, from_group, from_user, group_id, link_to, message, name, notification_id, notification_item, notification_left, notification_right, place_id, service_id, shout_liked, time, type, unchecked, unchecked_class;
    for(var x = 0; x < notifications_length; x ++)
    {
        avatar_user = notifications[x].avatar_location;
        from_group = notifications[x].from_group;
        from_user = notifications[x].from_user;
        name = notifications[x].name;
        notification_id = notifications[x].id;
        shout_liked = notifications[x].shout_liked;
        time = notifications[x].time;
        type = notifications[x].notification_type;
        unchecked = notifications[x].unchecked;
        group_id = notifications[x].group_id;
        place_id = notifications[x].place_id;
        service_id = notifications[x].service_id;
        user_id = notifications[x].user_id;

        if(avatar_group != undefined && avatar_group != "")
        {
            avatar = avatar_group;
        }
        else if(avatar_user != undefined && avatar_user != "")
        {
            avatar = avatar_user;
        }

        switch(type)
        {
            case 'shout_like':
                link_to = 'load_user('+from_user+')';
                message = ' liked your <span onclick="load_shout('+shout_liked+')">shout</span>.';
                name = '<div class="user_name" onclick="load_user('+from_user+')">'+name+'</div><br>';
                break;
            case 'user_follow':
                link_to = 'load_user('+from_user+')';
                message = ' started following you.';
                name = '<div class="user_name" onclick="load_user('+from_user+')">'+name+'</div><br>';
                break;
        }

        if(unchecked == true)
        {
            unchecked_class = 'unchecked';
        }
        else
        {
            unchecked_class = '';
        }

        notification_left = '<div class="menu_item_left notification_left"><img onclick="'+link_to+'" src="'+avatar+'"></div>';
        notification_right = '<div class="menu_item_right notification_right">'+name+message+'</div><div data-location="profile_menu" class="time">'+time+'</div>';
        notification_item = '<li data-id='+notification_id+' data-shout-type="'+type+'" data-location="menu" class="notification '+unchecked_class+'">'+notification_left+notification_right+'</li>';
        rendered_notifications = rendered_notifications+notification_item;
    }
    $('.menu_notifications').show().animate({left: '+=182'}, 80, function(){
            $(this).html('<ul>'+rendered_notifications+'</ul>');
        }
    );
    check_notifications();
}

get_notifications = function()
{
    var response = $.ajax({ type: "GET",
        url: "/notifications/list",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}