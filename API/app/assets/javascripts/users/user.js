/**
 * Name: Mohamed Eid
 * Date: 3/22/13
 * Time: 6:14 AM
 */

var UserModel = Backbone.Model.extend({
    urlRoot: '/users',
    follow: function(isPrivate) {
        var id = this.id
        $.ajax({
            type: "POST",
            url: "/users/"+this.id+"/follow",
            success: function() {
                if(isPrivate == undefined)isPrivate = false;
                if(isPrivate == true) {
                    $('.action[data-id='+id+'][data-action=ask_to_follow]').data('action', 'pending').html('Pending').attr('data-action', 'pending').removeClass('action').addClass('greyed_out').css('cursor', 'default');
                }
                else {
                    $('.action[data-id='+id+'][data-action=follow]').data('action', 'unfollow').attr('data-action', 'unfollow').html('Unfollow');
                }
            }
        });
    },
    unfollow: function (){
        var id = this.id;
        $.ajax({
            type: "POST",
            url: "/users/"+this.id+"/unfollow",
            success: function() {
                $('.action[data-id='+id+'][data-action=unfollow]').data('action', 'follow').attr('data-action', 'follow').html('Follow');
            }
        });
    }
});

function getUser(id, avatar_size)
{
    if(avatar_size == undefined)avatar_size = null;
    var response = $.ajax({ type: "GET",
        url: "/users/"+id+".json",
        async: false,
        data: {
            avatar_size: avatar_size
        }
    }).responseText;
    return jQuery.parseJSON(response);
}

load_user = function(id)
{
    if(id != account_id)
    {
        if(window.location != 'http://nitesite.co/users/'+id)
        {
            window.location = '/users/'+id;
        }
        else
        {
            load_user_page(id);
        }
    }
    else
    {
        window.location = '/me';
    }
}

followers_count_add = function()
{
    var followers_html_element = $('div[data-label=count_followers]');
    var followers_count_html = followers_html_element.html();
    var followers_count_integer = parseInt(followers_count_html);
    var followers_new_count = followers_count_integer + 1;
    followers_html_element.html(followers_new_count);

    if($('.list_followers').css('display') != undefined)
    {
        load_followers(account_id);
    }
}

get_followed_users = function(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/"+user_id+"/followed_users.json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_followers = function(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/followers/"+user_id,
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_groups = function(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/groups/"+user_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_shouts = function(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/feed/"+user_id+".json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

get_stats = function(user_id)
{
    var response = $.ajax({ type: "GET",
        url: "/users/stats/"+user_id,
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

render_user_stats = function(user_id)
{
    var stats = get_stats(user_id);

    var place_attendances = stats.place_attendances;

    var stat_item, stat_item_top, stat_item_bottom;

    stat_item_top = '<div class="heading_stat">Places Distribution</div><br>';
    stat_item_bottom = '<canvas id="user_radar_chart" width="450" height="400" class="follow_item_left" style="position:relative;bottom:35px;"></canvas>';
    stat_item = '<li class="follow_item" style="height:360px;margin-bottom:5px;">'+stat_item_top+stat_item_bottom+'</li>';

    stat_item_top = '<div class="heading_stat">Places VS. Parties</div><br>';
    stat_item_bottom = '<canvas id="user_pie_chart" width="225" height="200" class="follow_item_left" style="margin-top:20px;"></canvas>';
    stat_item = stat_item+'<li class="follow_item" style="margin-bottom:5px;">'+stat_item_top+stat_item_bottom+'</li>';

    $('.profile_contents').hide().html('<ul data-user-id='+user_id+' data-label="list_shouts">'+stat_item+'</ul>').fadeIn(100);
    render_user_radar_chart(place_attendances)
    render_user_pie_chart(stats.count_place_attendances, stats.count_party_attendances);
}
render_user_radar_chart = function(place_attendances)
{
    var ctx = $("#user_radar_chart").get(0).getContext("2d");
    //This will get the first returned node in the jQuery collection.

    var place_names = new Array();
    for(var x = 0; x < Object.keys(place_attendances).length; x++)
    {
        place_names[place_names.length] = place_attendances[x].place_name;
    }
    var place_counts = new Array();
    for(var x = 0; x < Object.keys(place_attendances).length; x++)
    {
        place_counts[place_counts.length] = place_attendances[x].count_attendance;
    }

    var data = {
        labels : place_names,
        datasets : [
            {
                fillColor : "rgba(20,173,255,.5)",
                strokeColor : "rgba(20,173,255,1)",
                pointColor : "rgb(140,198,63)",
                pointStrokeColor : "#fff",
                data : place_counts
            }
        ]
    }
    var radar_chart = new Chart(ctx).Radar(data);
}
render_user_pie_chart = function(count_places, count_parties)
{
    var ctx = $("#user_pie_chart").get(0).getContext("2d");
    //This will get the first returned node in the jQuery collection.
    var data = [
        {
            value: count_places,
            color:"rgba(20,173,255,1)"
        },
        {
            value : count_parties,
            color : "rgb(140,198,63)"
        }
    ]
    var pie_chart = new Chart(ctx).Pie(data);
}


function load_followed_users(id)
{
    window.location = '/users/'+id+'/followed_users'
}
function load_followers(id)
{
    window.location = '/users/'+id+'/followers'
}
function load_user_shouts(id)
{
    window.location = '/users/'+id+'/shouts'
}