$('.action').ready(function(){
    initialize_actions();
});

initialize_actions = function()
{
    $('.action').unbind('click').click(function(){
        var ui_element = $(this);
        var ui_class = ui_element.data('class');
        var ui_action = ui_element.data('action');
        var ui_id = ui_element.data('id');
        var url;
        switch(ui_class)
        {
            case 'group':
                url = '/groups/'+ui_id+'/';
                var group = new GroupModel({id: ui_id});
                var userID = ui_element.data('user-id');
                switch(ui_action)
                {
                    case 'addAdmin':
                        group.addAdmin(userID);
                        break;
                    case 'admins':
                        window.location = url+'admins';
                        break;
                    case 'members':
                        window.location = url+'members';
                        break;
                    case 'removeAdmin':
                        group.removeAdmin(userID);
                        break;
                    case 'removeUser':
                        group.removeUser(userID);
                        break;
                    case 'show':
                        window.location = url+'members';
                        break;
                    case 'statistics':
                        window.location = url+'statistics';
                        break;
                    case 'top_partiers':
                        window.location = url+'top_partiers';
                        break;
                }
                break;
            case 'party':
                url = '/parties/'+ui_id+'/';
                switch(ui_action)
                {
                    case 'attend':
                        party_vote(ui_id);
                        break;
                    case 'attending_users':
                        window.location = url+'attending_users';
                        break;
                    case 'list':
                        window.location = url;
                        break;
                    case 'show':
                        window.location = url+'attending_users';
                        break;
                    case 'throwParty':
                        break;
                }
                break;
            case 'place':
                url = '/places/'+ui_id+'/';
                switch(ui_action)
                {
                    case 'attend':
                        place_attend(ui_id);
                        break;
                    case 'attending_users':
                        window.location = url+'attending_users';
                        break;
                    case 'change_attendance':
                        window.location = url+'change_attendance';
                        break;
                    case 'list':
                        window.location = url;
                        break;
                    case 'show':
                        window.location = url+'attending_users';
                        break;
                    case 'statistics':
                        if(ui_id != undefined)
                        {
                            window.location = url+'statistics';
                        }
                        else
                        {
                            window.location = '/places/statistics';
                        }
                        break;
                    case 'top_attendees':
                        window.location = url+'top_attendees';
                        break;
                }
                break;
            case 'request':
                var request = new RequestModel({id: ui_id});
                switch(ui_action) {
                    case 'accept':
                        request.accept();
                        break;
                    case 'deny':
                        request.deny();
                        break;
                }
                break;
            case 'shout':
                switch(ui_action) {
                    case 'destroy':
                        shout_destroy(ui_id);
                        break;
                    case 'like':
                        shout_liking(ui_id);
                        break;
                    case 'alter':
                        shout_alter(ui_id);
                        break;
                    case 'show':
                        window.location = '/shouts/'+ui_id+'/likes';
                        break;
                    case 'unlike':
                        shout_unlike(ui_id);
                        break;
                }
                break;
            case 'user':
                url = '/users/'+ui_id+'/';
                var user = new UserModel({id: ui_id});
                switch(ui_action) {
                    case 'ask_to_follow':
                        user.follow(true);
                        break;
                    case 'feed':
                        window.location = url+'feed';
                        break;
                    case 'follow':
                        user.follow();
                        break;
                    case 'followed_users':
                        window.location = url+'followed_users';
                        break;
                    case 'followers':
                        window.location = url+'followers';
                        break;
                    case 'groups':
                        window.location = url+'groups';
                        break;
                    case 'settings':
                        window.location = '/settings';
                        break;
                    case 'show':
                        window.location = url+'feed';
                        break;
                    case 'statistics':
                        window.location = url+'statistics';
                        break;
                    case 'unfollow':
                        user.unfollow()
                        break;
                }
                break;
        }
    });
}