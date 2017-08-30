/**
 * Name: Mohamed Eid
 * Date: 5/29/13
 * Time: 3:58 PM
 */

close_menu_requests = function() // This function closes (slides) the requests menu.
{
    $('.menu_requests').animate({left: '-=202'}, 80, function(){$(this).css('left', '-102px').hide();});
}

get_requests = function(class_type, group_id)
{
    var response;
    switch(class_type)
    {
        case 'user':
            response = $.ajax({ type: "GET",
                url: "/requests/list.json",
                async: false
            }).responseText;
            return jQuery.parseJSON(response);
            break;
        case 'group':
            response = $.ajax({ type: "GET",
                url: "/groups/requests/"+group_id+".json",
                async: false
            }).responseText;
            return jQuery.parseJSON(response);
            break;
    }
}

open_menu_requests = function(class_type, group_id) // This function creates a menu containing some of the user's requests.
{
    close_menu_notifications();
    var requests = get_requests(class_type, group_id);
    var requests_keys = Object.keys(requests);
    var requests_length = requests_keys.length;
    var rendered_requests = '';

    if(requests_length != 0)
    {
        var accept_link, avatar, button_accept, button_deny, deny_link, from_group, from_user, id, link_to, message, name, request_item, request_item_bottom, request_item_left, request_item_right, type;
        for(var x = 0; x < requests_length; x++)
        {
            id = requests[x].id;
            avatar = requests[x].avatar_location;
            from_group = requests[x].from_group;
            from_user = requests[x].from_user;
            name = requests[x].name;
            type = requests[x].request_type;

            switch(type)
            {
                case 'group_invite':
                    link_to = 'load_group('+from_group+')';
                    message = ' wants you to join its group.';
                    name = '<div class="user_name" onclick="load_group('+from_group+')">'+name+'</div><br>';

                    accept_link = 'request_accept('+id+', \''+type+'\')';
                    deny_link = 'request_deny('+id+', \''+type+'\')';
                    break;
                case 'group_join':
                    link_to = 'load_user('+from_user+')';
                    message = ' wants to join your group.';
                    name = '<div class="user_name" onclick="load_user('+from_user+')">'+name+'</div><br>';

                    accept_link = 'request_accept('+id+', \''+type+'\')';
                    deny_link = 'request_deny('+id+', \''+type+'\')';
                    break;
                case 'user_follow':
                    link_to = 'load_user('+from_user+')';
                    message = ' wants to follow you.';
                    name = '<div class="user_name" onclick="load_user('+from_user+')">'+name+'</div><br>';

                    accept_link = 'request_accept('+id+', \''+type+'\')';
                    deny_link = 'request_deny('+id+', \''+type+'\')';
                    break;
            }

            request_item_left = '<div class="menu_item_left"><img onclick="'+link_to+'" src="'+avatar+'"></div>';
            request_item_right = '<div class="menu_item_right">'+name+message+'</div>';

            button_accept = '<div data-id='+id+' data-label="request_accept" class="shout_bottom_item" onclick="'+accept_link+'">Accept</div>';
            button_deny = '<div data-id='+id+' data-label="request_deny" class="shout_bottom_item" onclick="'+deny_link+'">Deny</div>';
            request_item_bottom = '<div class="menu_item_bottom">'+button_accept+button_deny+'</div>';

            request_item = '<li data-id='+id+' data-location="menu" class="request">'+request_item_left+request_item_right+request_item_bottom+'</li>';

            rendered_requests = rendered_requests + request_item;
        }
    }
    else
    {
        var msg;
        switch(class_type)
        {
            case 'user':
                msg = 'You have';
                break;
            case 'group':
                msg = 'There are';
                break;
        }
        rendered_requests = '<div class="warning" style="font-size:30px;text-align: left;padding-left: 25px ;">'+msg+' no requests at this time.</div>';
    }

    $('.menu_requests').show().animate({left: '+=182'}, 80, function(){
            $(this).html('<ul>'+rendered_requests+'</ul>');
        }
    );
}

request_accept = function(request_id, request_type) // This function accepts a request and deletes it form the database.
{
    $.ajax({
        type: "POST",
        url: "/requests/accept/"+request_id ,
        success: function()
        {
            adjust_alerts(1);
            request_count_minus(request_id);
            /*switch(request_type)
            {
                case 'user_follow':
                    followers_count_add();
                    break;
                default:
                    break;
            }*/
        }
    });
}
request_deny = function(request_id) // This function denies a request and deletes it from the database.
{
    $.ajax({
        type: "DELETE",
        url: "/requests/"+request_id,
        success: function()
        {
            adjust_alerts(1);
            request_count_minus(request_id);
        }
    });
}

request_count_minus = function(request_id)
{
    // The following removes (in animation) the request list item from the list.
    $('li[data-request-id='+request_id+']').animate({
        right: -250
    }, 300, function(){
        $(this).hide();
    });

    var request_html_element = $('span[data-label=count_requests]');
    var request_count_html = request_html_element.html();
    var request_count_integer = parseInt(request_count_html);
    var request_new_count = request_count_integer - 1;
    request_html_element.html(request_new_count);
}