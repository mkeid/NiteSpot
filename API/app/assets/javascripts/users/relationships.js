/**
 * Name: Mohamed Eid
 * Date: 3/22/13
 * Time: 10:14 AM
 */


follow_user = function(id, refresh)
{
    $.ajax({
        type: "POST",
        url: "/users/"+id+"/follow",
        success: function() {
            if(refresh == true)
            {
                load_user(id);
            }
            $('.action[data-id='+id+'][data-action=follow]').data('action', 'unfollow').html('Unfollow');
        }
    });
}

unfollow_user = function(id, refresh)
{
    $.ajax({
        type: "POST",
        url: "/users/"+id+"/unfollow",
        success: function() {
            if(refresh == true)
            {
                load_user(id);
            }
            $('.action[data-id='+id+'][data-action=unfollow]').data('action', 'follow').html('Follow');
        }
    });
}

followed_users_count_change = function(user_id, math)
{
    var followed_users_html_element = $('div[data-label=count_following]');
    var followed_users_count_html = followed_users_html_element.html();
    var followed_users_count_integer = parseInt(followed_users_count_html);
    var followed_users_new_count;
    switch(math)
    {
        case "add":
            followed_users_new_count = followed_users_count_integer + 1;
            break;
        case "subtract":
            followed_users_new_count = followed_users_count_integer - 1;
            break;
    }
    if(user_id == account_id || math == "subtract")
    {
        followed_users_html_element.html(followed_users_new_count);
        button_opposite = 'button_follow';
        html_opposite = 'Follow';
    }
    var button_opposite, html_opposite;
    if(math == 'add')
    {
        followed_users_html_element.html(followed_users_new_count);
        button_opposite = 'button_unfollow';
        html_opposite = 'Unfollow';
    }
    else if(math == 'none')
    {
        button_opposite = 'button_pending';
        html_opposite = 'Pending';
        $('.follow_item[data-user-id='+user_id+'] div[data-label=button_relationship]').addClass('greyed_out');
    }
    $('.follow_item[data-user-id='+user_id+'] div[data-label=button_relationship]').data('type', button_opposite).html(html_opposite);
}