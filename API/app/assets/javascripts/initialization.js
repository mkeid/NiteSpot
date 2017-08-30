/**
 * Name: Mohamed Eid
 * Date: 4/6/13
 * Time: 12:43 PM
 */

initialize_buttons = function()
{
    $('div[data-label=button_relationship]').click(function()
    {
        var user_id = $(this).data('user-id');
        var type = $(this).data('type');
        switch(type)
        {
            case "button_follow":
                follow_user(user_id);
                followed_users_count_change(user_id, "add");
                break;
            case "button_unfollow":
                unfollow_user(user_id);
                followed_users_count_change(user_id, "subtract");
                break;
            case "button_ask":
                follow_user(user_id);
                followed_users_count_change(user_id, "none");
                break;
        }
    });
    $('.button_admin').click(function(){
        var group_id = $(this).data('group-id');
        var user_id = $(this).data('user-id');
        var type = $(this).data('type');
        var location = $(this).data('location');
        switch(type)
        {
            case "admin_add":
                admin_add(group_id, user_id);
                //$(this).html('<span data-user-id='+user_id+' class="admin sprite"></span>').attr('title', 'Remove admin.');
                break;
            case "admin_remove":
                admin_remove(group_id, user_id);
                //$(this).html('<span data-user-id='+user_id+' class="not_admin sprite"></span>').attr('title', 'Make admin.');
                break;
        }
    });
}

initialize_party_throw = function()
{
    // The following makes the css generated radio buttons in the throw party page act as actual radio buttons.
    $('.radio[data-name=party_privacy]').click(function(){
        $('div[data-name=party_privacy]').removeClass('radio_selected');
        $(this).addClass('radio_selected');
        party_public = $(this).attr('value');
    });
}

initialize_shout = function()
{
    /**************************************************
     * The following makes it so the deletion, liking, and
     * opening functions of shouts are accessible through
     * the clicking of their corresponding HTML elements.
     *************************************************/
    $('.shout_item').click(function(e){
        var shout_id = $(this).data('id');
        var clickedOn = $(e.target);
        if(clickedOn.parents().andSelf().is('.shout_like'))
        {
            shout_liking(shout_id);
        }
        else if(clickedOn.parents().andSelf().is('.shout_unlike'))
        {
            shout_unlike(shout_id);
        }
        else if(clickedOn.parents().andSelf().is('.shout_destroy'))
        {
            shout_destroy(shout_id);
        }
        else if(clickedOn.parents().andSelf().is('.shout_load'))
        {
            load_shout(shout_id);
        }
        else
        {
            shout_alter(shout_id);
        }
    });
}

initialize_foods = function()
{
    /**************************************************
     * The following makes it so the segmented switch
     * rendered on the foods page switches between
     * food service types.
     *************************************************/
    $('.button_food_category').click(function(e){
        $('.button_food_category').removeClass('plain_button_selected');
        $(this).addClass('plain_button_selected');
        var food_category = $(this).data('label');
        switch(food_category)
        {
            case 'delis':
                load_foods_delis();
                break;
            case 'pizzerias':
                load_foods_pizzerias();
                break;
            case 'restaurants':
                load_foods_restaurants();
                break;
            default:
                break;
        }
    });
}

initialize_group = function()
{
    /**************************************************
     * The following makes it so the joining and leaving
     * the group functions in group pages are accessible
     * through the clicking of their corresponding HTML
     * elements.
     *************************************************/
    $('.group_item').click(function(e){
        var group_id = $(this).data('group-id');
        var clickedOn = $(e.target);
        var action = $(this).data('action');
        switch(action)
        {
            case 'group_join':
                group_join(group_id);
                break;
            case 'group_ask':
                group_join(group_id, true);
                break;
            case 'group_leave':
                group_leave(group_id);
                break;
            case 'group_delete':
                group_delete(group_id);
                break;
            case 'load_admins':
                load_admins(group_id);
                break;
            case 'load_members':
                load_members(group_id);
                break;
            case 'load_parties':
                load_parties(group_id);
                break;
            case 'load_requests':
                if($('.menu_requests').css('display') == 'none')
                {
                    open_menu_requests('group', group_id); // This opens up the user's requests menu. [private]
                }
                else
                {
                    close_menu_requests(); // This closes the requests' menu.
                }
                break;
        }
    });
    initialize_menu_propagations();
}

initialize_party_buttons = function()
{
    /**************************************************
     * The following makes it so the joining and leaving
     * the group functions in group pages are accessible
     * through the clicking of their corresponding HTML
     * elements.
     *************************************************/
    $('.party_item').click(function(e){
        var party_id = $(this).data('party-id');
        var clickedOn = $(e.target);
        var action = $(this).data('action');
        switch(action)
        {
            case 'party_info':
                load_party(party_id);
                break;
            case 'party_vote':
                party_vote(party_id, false);
                $(this).addClass('attending').html('Attending');
        }
    });
    //initialize_menu_propagations();
}

initialize_menu_propagations = function()
{
    /**************************************************
     * The following makes it so that when the document
     * is clicked, the notification and request menu
     * items close.
     **************************************************/
    $(document).click(function(){
        close_menu_notifications();
        close_menu_requests();
    });
    $('.menu_notifications').click(function(event)
    {
        event.stopPropagation();
    });
    $('.menu_requests').click(function(event)
    {
        event.stopPropagation();
    });
    $('.user_page_button[data-label=notifications]').click(function(event)
    {
        event.stopPropagation();
    });
    $('.user_page_button[data-label=requests]').click(function(event)
    {
        event.stopPropagation();
    });
}

initialize_place = function()
{
    $('.place_item').click(function(e){
        var place_id = $(this).data('place-id');
        var clickedOn = $(e.target);
        var action = $(this).data('action');
        switch(action)
        {
            case 'load_users_attending':
                render_attending_users(place_id, 'place');
                break;
            case 'load_top_attendees':
                break;
            case 'load_place_stats':
                break;
        }
    });
}

initialize_tooltip = function()
{
    $(document).ready(function() {
        $('.tooltip').tooltipster({
            position: 'bottom'
        });
        $('.tooltip_left').tooltipster({
            position: 'left'
        });
    });
}
$(document).ready(function() {
    initialize_tooltip();
});

// Search Initialization
$(function(){
    $('html').click(function(){
        $('.bar_search').hide();
        $('.bar_support').show();
        $('.content_body').show();
    });
    $('.bar_search').click(function(event){
        event.stopPropagation();
    });
    $('#search').click(function(event){
        event.stopPropagation();
    });
});
