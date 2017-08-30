/**
 * Created with JetBrains RubyMine.
 * Name: Mohamed Eid
 * Date: 4/12/13
 * Time: 3:34 PM
 */

var search_ready = true;
search = function(input) // This function searches for users, groups, and services.
{
    $('.content_body').hide();
    $('.bar_support').hide();
    if(search_ready)
    {
        var response = $.ajax({ type: "GET",
            url: "/search/list.json?query="+input,
            async: false
        }).responseText;
        var results = jQuery.parseJSON(response);
        if(results != '')
        {
            var results_keys = Object.keys(results);
            var results_length = results_keys.length;
            var rendered_results = "";

            var exists_group = false;
            var exists_place = false;
            var exists_service = false;
            var exists_user = false;

            for(var x = 0; x < results_length; x++)
            {
                var result_left, result_right;
                var avatar_location = results[x].avatar_location;
                var result_name = results[x].name;
                var result_id = results[x].id;

                if(results[x].class == 'User')
                {
                    if(exists_user == false)
                    {
                        rendered_results = rendered_results+'<li class="search_head">People [<a style="color:rgb(85,85,85);" href="/search/search_users?query='+input+'">see all</a>]</li>';
                    }
                    result_left = '<div><img src="'+avatar_location+'"></div>';
                    result_right = '<div><span>'+result_name+'</span><br><span class="school_item">'+results[x].year.capitalize()+'</span></div>';
                    rendered_results = rendered_results+'<li class="search_result" onclick="load_user('+result_id+')">'+result_left+result_right+'</li>';
                    exists_user = true;
                }
                if(results[x].class == 'Group')
                {
                    if(exists_group == false)
                    {
                        rendered_results = rendered_results+'<li class="search_head">Groups [<a style="color:rgb(85,85,85);" href="/search/search_groups?query='+input+'">see all</a>]</li>';
                    }
                    result_left = '<div><img src="'+avatar_location+'"></div>';
                    result_right = '<div><span>'+result_name+'</span><br><span class="school_item">'+results[x].group_type+'</span></div>';
                    rendered_results = rendered_results+'<li class="search_result" onclick="load_group('+result_id+')">'+result_left+result_right+'</li>';
                    exists_group = true;
                }
                if(results[x].class == 'Place')
                {
                    if(exists_place == false)
                    {
                        rendered_results = rendered_results+'<li class="search_head">Places [<a style="color:rgb(85,85,85);" href="/search/search_places?query='+input+'">see all</a>]</li>';
                    }
                    result_left = '<div><img src="'+avatar_location+'"></div>';
                    result_right = '<div><span>'+result_name+'</span><br><span class="school_item">Bar / Club</span></div>';
                    rendered_results = rendered_results+'<li class="search_result" onclick="load_place('+result_id+')">'+result_left+result_right+'</li>';
                    exists_place = true;
                }
                if(results[x].class == 'Service')
                {
                    if(exists_service == false)
                    {
                        rendered_results = rendered_results+'<li class="search_head">Food [<a style="color:rgb(85,85,85);" href="/search/search_services?query='+input+'">see all</a>]</li>';
                    }
                    result_left = '<div><img src="'+avatar_location+'"></div>';
                    result_right = '<div><span>'+result_name+'</span><br><span class="school_item">'+results[x].label+'</span></div>';
                    rendered_results = rendered_results+'<li class="search_result" onclick="load_service('+result_id+')">'+result_left+result_right+'</li>';
                    exists_service = true;
                }
            }
            $('.bar_search').html(rendered_results+'<div class="warning" onclick="search_close()" style="color:rgb(110,110,110);font-size:25px;height:40px;width:100%;">Click anywhere here to close the search box.</div>').css('display', 'inline-block');
        }
        else
        {
            $('.bar_search').hide();
        }
    }
}

search_check = function()
{
    if($('#search').val().length > 0)
    {
        $('.content_body').hide();
        $('.bar_support').hide();
        $(".bar_search").show();
    }
}

search_close = function()
{
    $(".bar_search").hide();
    $('.content_body').show();
    $('.bar_support').show();
}