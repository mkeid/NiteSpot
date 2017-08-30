/**
 * Name: Mohamed Eid
 * Date: 3/21/13
 * Time: 5:27 AM
 */
load_group = function()
{
    if(window.location != 'http://nitesite.co/groups')
    {
        window.location = '/groups';
    }
    else
    {
        load_groups_page();
    }
}

load_groups_page = function(user_id)
{
    if(user_id == undefined) user_id = account_id;
    if(user_id == account_id)
    {
        $('.ns_title').html('Groups');
        update_browser("Groups", "groups", "");
        var button_create_group = "";
        render_navigator(button_create_group);
        var html_contents = $('.content_body');
        html_contents.css('display', 'block');
    }
    else
    {
        load_user_page(user_id);
        var html_contents = $('.profile_contents');
    }

    if(user_id == account_id)
    {
        $('.bar_support').remove();
        $('.ns_title').html('Groups<span class="button_action" onclick="load_page(\'groups_new\')">Create Group</div>');
    }
    else
    {
        var groups = get_groups(user_id);
        var groups_keys = Object.keys(groups);
        var groups_length = groups_keys.length;
        var rendered_groups = "";
        if(groups_length > 0)
        {
            for(var x = 0; x < groups_length; x++)
            {
                var group_id = groups[x].id;
                var group_avatar = groups[x].avatar_location;
                var group_name = groups[x].name;
                var group_type = groups[x].type;

                var group_item_name = '<li>'+group_name+'</li>';
                var group_item_type = '<li>'+group_type+'</li>';

                var group_left = '<div class="accordion_image"><img src="'+group_avatar+'"></div>';
                var group_right = '<div class="accordion_information"><ul>'+group_item_name+group_item_type+'</ul></div>';

                var group_list_item = '<li data-group-id='+group_id+' data-group-name='+group_name+' class="accordion_item">'+group_left+group_right+'</li>';
                rendered_groups = rendered_groups+group_list_item;
            }
            html_contents.html('<div class="body_groups"><ul>'+rendered_groups+'</ul></div>').fadeIn();
        }
        else
        {
            var group_warning;
            if(account_id == user_id)
            {
                group_warning = 'You\'re not in any groups yet! Try making your own by clicking the button on the top right.';
            }
            else
            {
                group_warning = 'This user is not in any groups yet! Invite them to one of yours from one of your group pages.';
            }
            html_contents.html('<div class="warning">'+group_warning+'</div>').css('display', 'inline-block').fadeIn();
        }
        $('.profile_bar').html('<div class="stylish_text">User Groups</div>');
    }
};
load_group = function(group_id)
{
    if(window.location != 'http://nitesite.co/groups/'+group_id)
    {
        window.location = '/groups/'+group_id;
    }
    else
    {
        load_group_page(group_id);
    }
}
load_group_page = function(group_id)
{
    reset_slides();

    var response = $.ajax({ type: "GET",
        url: "/groups/"+group_id+".json",
        async: false
    }).responseText;
    var group = jQuery.parseJSON(response);
    var rendered_group = "";

    // The following creates HTML using the retrieved JSON objects from the server.
    var group_avatar = group.avatar_location;
    var group_id = group.id;
    var group_is_admin = group.is_admin;
    var group_is_member = group.is_member;
    var group_is_pending = group.is_pending;
    var group_name = group.name;
    var group_public = group.public;
    var group_type = group.type;
    var group_count_admins = group.count_admins;
    var group_count_members = group.count_members;
    var group_count_parties = group.acount_parties;

    render_group = function()
    {
        var head_item_avatar = generate_html({tag: 'li', html: generate_html({tag: 'img', src: group.avatar_location})});
        var head_list = generate_html({tag: 'ul', class: 'head_left', html: head_item_avatar});
        var profile_head = generate_html({tag: 'div', class: 'profile_head', data: {id:group.id, class: 'group'}, html: head_list});

        var profile_bar = generate_html({tag: 'div', class: 'profile_bar', data: {id: group.id, class: 'group'}});

        var profile_contents = '<div data-group-id='+group_id+' class="profile_contents"></div>';
        var profile_body = profile_head+profile_bar+profile_contents;

        $('.content_body').html(profile_body).fadeIn(100); // This will put all the new HTML into the content body.

        var bar_notifiers = '';
        bar_invites = function()
        {
            var bar_invite = '<a href="/groups/invite/'+group_id+'"><div class="button_green tooltip" title="Invite users to join."><span class="group_invite_small sprite"></span></div></a>';
            return bar_invite;
        }
        bar_parties = function()
        {
            var bar_parties = '<a href="/groups/new_party/'+group_id+'"><div class="button_blue tooltip" title="Throw a party."><span class="parties_small sprite"></span></div></a>'
            return bar_parties;
        }
        bar_requests = function()
        {
            var bar_requests_left = '<div class="profile_bar_left"><span class="requests_small sprite"></span></div>';
            var s_requests = ''; if(group.count_requests != 1) s_requests = 's';
            var bar_requests_right = '<div class="profile_bar_right"><div data-label="count_requests">'+group.count_requests+'</div><div>Request'+s_requests+'</div>';
            var bar_requests = '<li data-group-id='+group_id+' data-action="load_requests" data-label="requests" class="user_page_button group_item">'+bar_requests_left+bar_requests_right+'</li>';
            return bar_requests;
        }
        bar_settings = function()
        {
            var bar_settings = '<a href="/groups/edit/'+group_id+'"><div class="button_grey tooltip" title="Change your group settings."><span class="settings_small sprite"></span></div></a>';
            return bar_settings;
        }
        var button_join
        if(group_is_member)
        {
            button_join = '<span data-group-id='+group_id+' data-action="group_leave" class="group_item button_action group_leave">Leave</span>'; // This makes the top-right action button a "Leave" button if the user is a member.
            bar_notifiers = bar_notifiers+bar_requests()+bar_invites()+bar_parties();
        }
        else if(group_is_member == false && group_public == true)
        {
            button_join = '<span data-group-id='+group_id+' data-action="group_join" class="group_item button_action group_join">Join</span>';
        }
        else if(group_is_member == false && group_public == false && group_is_pending == false)
        {
            button_join = '<span id="button_group_ask" data-group-id='+group_id+' data-action="group_ask" class="group_item button_action group_ask">Ask to Join</span>';
        }
        else if(group_is_member == false && group_public == false && group_is_pending == true)
        {
            button_join = '<span data-group-id='+group_id+' data-action="pending" class="group_item button_action group_pending greyed_out" style="cursor:default;">Pending</span>';
        }
        if(group_is_admin)
        {
            var bar_requests_menu = '<div class="menu_profile menu_requests"></div>';
            bar_notifiers = bar_notifiers+bar_settings()+bar_requests_menu;
        }
        else
        {
            bar_notifiers = '';
            $('.bar_support').remove();
        }
        bar_notifiers = '<ul class="notifiers">'+bar_notifiers+'</ul>';
        $('.ns_title').html(group.name+button_join);
        render_navigator(bar_notifiers);
        setTimeout(function(){initialize_group();}, 100);
    }
    if(response != null)
    {
        render_group();
    }
    else
    {
        var intro;
        if(id == account_id)
        {
            intro = 'You aren\'t ';
        }
        else
        {
            intro = user.name +' isn\'t ';
        }
        $('.profile_contents').hide().html('<div class="warning" style="left:15px;">'+intro+'in any groups yet.</div>').fadeIn(100);
    }

    load_members = function(group_id) // This functions loads all the members of a specific group.
    {
        var users = get_members(group_id);
        render_group_users(users, group_is_admin, group_id);
    }
    load_admins = function(group_id) // This function loads all the admins of a specific group.
    {
        var users = get_admins(group_id);
        render_group_users(users, group_is_admin, group_id);
    }
    load_parties = function(group_id) // This function loads all the parties of a specific group.
    {
        var parties = get_parties(group_id);
        render_group_parties(parties, group_is_admin);
    }


    load_members(group_id);

    group_delete = function(group_id)
    {
        $.ajax({
            type: "POST",
            url: "/groups/destroy/"+group_id ,
            success: function()
            {
                window.location = '/groups';
            }
        });
    }
    group_join = function(group_id, is_asking)
    {
        $.ajax({
            type: "POST",
            url: "/groups/join/"+group_id ,
            success: function()
            {
                if(is_asking == true)
                {
                    $('#button_group_ask').data('action', 'pending').css('cursor', 'default').addClass('greyed_out').html('Pending');
                }
                else
                {
                    window.location = '/groups/'+group_id;
                }
            }
        });
    }
    group_leave = function(group_id)
    {
        $.ajax({
            type: "POST",
            url: "/groups/leave/"+group_id ,
            success: function()
            {
                window.location = '/groups/'+group_id;
            }
        });
    }
}

load_requests_group = function(group_id)
{
}

/**************************************************
 * The following functions get JSON data from the
 * server. They return a parsed JSON object.
 **************************************************/

get_possible_users_for_invite = function(class_name, id)
{
    var response;
    switch(class_name)
    {
        case 'Group':
        response = $.ajax({ type: "GET",
            url: "/groups/possible_users_to_invite/"+id,
            async: false
        }).responseText;
        break;
        case 'Party':
            response = $.ajax({ type: "GET",
                url: "/parties/possible_users_to_invite/"+id,
                async: false
            }).responseText;
            break;
    }
    return jQuery.parseJSON(response);
}

get_members = function(group_id)
{
    var response = $.ajax({ type: "GET",
        url: "/groups/members/"+group_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_admins = function(group_id)
{
    var response = $.ajax({ type: "GET",
        url: "/groups/admins/"+group_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_parties = function(group_id)
{
    var response = $.ajax({ type: "GET",
        url: "/groups/parties/"+group_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

/**************************************************
 * The following functions render HTML elements
 * based on JSON data from the server (previously
 * retrieved through the getter functions).
 **************************************************/

render_group_users = function(users, group_is_admin, group_id)
{
    var users_keys = Object.keys(users);
    var users_length = users_keys.length;
    var rendered_users = "";


    // The following creates HTML using the retrieved JSON objects from the server.
    var button_admin, button_follow, user, user_item, user_item_left, user_item_name, user_item_right, user_item_year, user_name;
    for(var x = 0; x < users_length; x++)
    {
        user = users[x];

        if(group_is_admin && user.id != account_id)
        {
            button_admin = create_button_admin(user.id, user.is_admin, group_id);
        }
        else
        {
            button_admin = '';
        }
        button_follow = create_button_follow(user.id, user.relation);

        user_item_left = '<div class="follow_item_left"><img onclick="load_user('+user.id+')" src="'+user.avatar_location+'"></div>';

        user_item_name = '<div class="user_name" onclick="load_user('+user.id+')">'+user.name+'</div><br>';
        user_item_year = '<div class="school_item">'+user.year+'</div>';
        user_item_right = '<div class="follow_item_right">'+user_item_name+user_item_year+'</div>';

        user_item = '<li data-user-id='+user.id+' class="follow_item"><div class="follow_item_contents">'+user_item_left+user_item_right+'</div>'+button_admin+button_follow+'</li>';

        rendered_users = rendered_users+user_item;
    }
    $('.profile_contents').hide().html('<ul class="list_followed_users">'+rendered_users+'</ul>').fadeIn(100);
    var classes_controller = '<div class="segmented_control"><div id="button_all" class="button" onclick="year_filter(&quot;all&quot;)">All</div><div id="button_fr" class="button" onclick="year_filter(&quot;fr&quot;)">Freshmen</div><div id="button_so" class="button" onclick="year_filter(&quot;so&quot;)">Sophomores</div><div id="button_jr" class="button" onclick="year_filter(&quot;jr&quot;)">Juniors</div><div id="button_sr" class="button" onclick="year_filter(&quot;sr&quot;)">Seniors</div></div>';
    $('.profile_bar').html(classes_controller);

    initialize_buttons();
    initialize_tooltip();
}

render_group_parties =  function(parties, is_admin)
{
    is_admin = typeof is_admin !== 'undefined' ? is_admin : false;
    var parties_keys = Object.keys(parties);
    var parties_length = parties_keys.length;
    var rendered_parties = "";

    if(parties_length == 0)
    {
        rendered_parties = '<div class="warning">This group currently has no parties posted.</div>';
    }
    else
    {
        // The following creates HTML using the retrieved JSON objects from the server.
        var party, party_item, party_item_left, party_item_right, party_item_right_list, party_item_name, party_item_location, party_item_time, party_item_bottom, party_item_info, party_item_attend, party_edit;
        for(var x = 0; x < parties_length; x++)
        {
            party = parties[x];

            party_item_left = '<div class="follow_item_left"><a href="/parties/'+parties[x].id+'"><span class="sprite parties"></span></a></div>';

            party_item_name = '<li><span>Party Name:</span> '+parties[x].name+'</li>';
            party_item_location = '<li><span>Location:</span> '+parties[x].address+'</li>';
            party_item_time = '<li><span>Time:</span> '+parties[x].time+'</li>';
            party_item_right_list = party_item_name+party_item_location+party_item_time;
            party_item_right = '<div class="follow_item_right"><ul>'+party_item_right_list+'</ul></div>';

            party_item_info = '<li data-action="party_info" data-party-id="'+parties[x].id+'" class="shout_bottom_item party_item">Info</li>';
            if(parties[x].is_attending)
            {
                party_item_attend = '<li data-action="party_vote" data-party-id="'+parties[x].id+'" class="shout_bottom_item party_item attending">Attending</li>';
            }
            else
            {
                party_item_attend = '<li data-action="party_vote" data-party-id="'+parties[x].id+'" class="shout_bottom_item party_item">Attend</li>';
            }
            party_item_bottom = '<ul class="shout_bottom">'+party_item_info+party_item_attend+'</ul>';

            if(is_admin)
            {
                party_edit = '<a class="tooltip" title="Edit party settings." href="/parties/edit/'+parties[x].id+'" style="position:absolute;right:-7px;"><span class="settings_small_dark sprite"></span></a>';
            }
            else
            {
                party_edit = '';
            }

            party_item = '<li data-party-id='+party.id+' class="follow_item party_item"><div class="follow_item_contents">'+party_item_left+party_item_right+party_item_bottom+party_edit+'</div></li>';

            rendered_parties = rendered_parties+party_item;
        }
        rendered_parties = '<ul class="list_followed_users">'+rendered_parties+'</ul>';
    }
    $('.profile_contents').hide().html(rendered_parties).fadeIn(100);
    initialize_party_buttons();
    initialize_tooltip();
}

var invited_users = new Array();
render_invite_options = function(class_name, id) // This function loads and creates a list of possible users to invite to a group.
{
    var users;
    switch(class_name)
    {
        case 'Group':
            users = get_possible_users_for_invite(class_name, id);
            break;
        case 'Party':
            users = get_possible_users_for_invite(class_name, id);
            break;
    }
    var users_keys = Object.keys(users);
    var users_length = users_keys.length;
    var rendered_users = "";

    if(users_length != 0)
    {
        // The following creates HTML using the retrieved JSON objects from the server.
        var user_avatar, user_id, user_item, user_item_left, user_item_name, user_item_right, user_item_year, user_name, user_school, user_year;
        for(var x = 0; x < users_length; x++)
        {
            user_avatar = users[x].avatar_location;
            user_id = users[x].id;
            user_name = users[x].name;
            user_school = users[x].school;
            user_year = users[x].year;

            if(users[x].available)
            {
                user_item_left = '<div class="follow_item_left"><img onclick="load_user('+user_id+')" src="'+user_avatar+'" style="border:1px solid rgb(255,255,255);"></div>';

                user_item_name = '<div class="user_name" onclick="load_user('+user_id+')">'+user_name+'</div><br>';
                user_item_year = '<div class="school_item">'+user_year+'</div>';
                user_item_right = '<div class="follow_item_right">'+user_item_name+user_item_year+'</div>';

                user_item = '<li data-user-id='+user_id+' class="follow_item invite_item" style="cursor:pointer;margin:15px;width:300px;"><div class="follow_item_contents">'+user_item_left+user_item_right+'</div></li>';
            }
            else
            {
                user_item_left = '<div class="follow_item_left"><img onclick="load_user('+user_id+')" src="'+user_avatar+'" style="border:1px solid rgb(255,255,255);"></div>';

                user_item_name = '<div class="user_name" onclick="load_user('+user_id+')">'+user_name+'</div><br>';
                user_item_year = '<div class="school_item">'+user_year+'</div>';
                user_item_right = '<div class="follow_item_right">'+user_item_name+user_item_year+'</div>';

                user_item = '<li  class="follow_item invite_item greyed_out" style="margin:15px;width:300px;"><div class="follow_item_contents">'+user_item_left+user_item_right+'</div></li>';
            }

            rendered_users = rendered_users+user_item;
        }
        $('.content_body').hide().html('<ul class="">'+rendered_users+'</ul>').fadeIn(100);
    }
    else
    {
        $('.content_body').hide().html('<div class="warning" style="left:15px;">You don\'t have any followers to invite from.</div>').fadeIn(100);
    }
    // The following makes it so the user blocks and the invite button are clickable and do something (in this case: add to array of users to invite).
    $('.follow_item').click(function(){
        if(!$(this).hasClass('greyed_out'))
        {
            var user_id = $(this).data('user-id');
            if($(this).hasClass('follow_item_selected'))
            {
                $(this).removeClass('follow_item_selected');
                // This removes the element from the array.
                var index = $.inArray(user_id, invited_users);
                if(index != -1)
                {
                    invited_users.splice(index, 1);
                }
            }
            else
            {
                if($.inArray(user_id, invited_users) == -1)
                {
                    $(this).addClass('follow_item_selected');
                    invited_users[invited_users.length] = user_id;
                }
            }
        }
    });
    $('#button_invite').ready(function(){
        $('#button_invite').click(function(){
            invite_users(class_name, id, invited_users);
        });
    });
}


create_button_admin = function(user_id, is_admin, group_id)
{
    var button;
    if(is_admin)
    {
        button = '<div data-user-id='+user_id+' data-group-id='+group_id+' data-type="admin_remove" class="button_admin  tooltip_left" title="Remove admin."><span data-user-id='+user_id+' class="admin sprite"></span></div>';
        return button;
    }
    else
    {
        button = '<div data-user-id='+user_id+' data-group-id='+group_id+' data-type="admin_add" class="button_admin tooltip_left" title="Make admin."><span data-user-id='+user_id+' class="not_admin sprite"></span></div>';
        return button;
    }
}

admin_add = function(group_id, user_id)
{
    $.ajax({
        type: "POST",
        url: "/groups/admin_add/"+group_id,
        data: {
            "user_id": user_id
        },
        success: function() {
            admin_count_change('add');
        }
    });
}

admin_remove = function(group_id, user_id)
{
    $.ajax({
        type: "POST",
        url: "/groups/admin_remove/"+group_id,
        data: {
            "user_id": user_id
        },
        success: function() {
            admin_count_change('subtract');
        }
    });
}

admin_count_change = function(math)
{

}

invite_users = function(class_name, id, user_ids)
{
    var url;
    switch(class_name)
    {
        case 'Group':
            url = "/groups/invite_users/";
            break;
        case 'Party':
            url = "/parties/invite_users/";
            break;
    }
    $.ajax({
        type: "POST",
        url: url+id,
        dataType: "json",
        data: {
            "user_ids": JSON.stringify(user_ids)
        },
        success: function() {
            $(function(){
                window.location = '/groups/'+id;
            });
        }
    });
}