/**
 * Name: Mohamed Eid
 * Date: 6/26/13
 * Time: 8:31 PM
 */

function get_attending_users_place(place_id)
{
    var response = $.ajax({ type: "GET",
        url: "/places/attending_users/"+place_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

function get_groups(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/groups/"+user_id+".json",
        async: false
    }).responseText;

    return jQuery.parseJSON(response);
}


function get_places(change_place_vote)
{
    var response = $.ajax({ type: "GET",
        url: "/places/list.json?change="+change_place_vote.toString(),
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_shout = function(shout_id)
{
    var response = $.ajax({ type: "GET",
        url: "/shouts/"+shout_id+".json",
        data: {
            "preview": true
        },
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

function get_user(id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/"+id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}