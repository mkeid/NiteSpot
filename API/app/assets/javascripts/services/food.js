/**
 * Name: Mohamed Eid
 * Date: 3/21/13
 * Time: 5:04 AM
 */

load_foods = function()
{
    if(window.location != 'http://nitesite.co/food')
    {
        window.location = '/food';
    }
    else
    {
        load_foods_page();
    }
}
load_foods_page = function()
{
    $('.bar_support').remove();
    $('.ns_title').html('Food');
   /* reset_slides();
    update_browser("Food", "food", "");
    service_page = "food";
    $('.item_food span').addClass("food-selected");
    var services_switch = '<div class="segmented_control" style="left:121px;"><div data-label="delis" class="button plain_button_selected button_food_category">Delis</div><div data-label="pizzerias" class="button button_food_category">Pizzerias</div><div data-label="restaurants" class="button button_food_category">Restaurants</div></div>';
    var button_favorites = '<div class="button_edit">Favorites</div>';
    render_navigator(services_switch+button_favorites);
    initialize_foods();

    var foods = get_food();
    var foods_keys = Object.keys(foods);
    var foods_length = foods_keys.length;
    var rendered_foods = "";

    // The following creates HTML using the retrieved JSON objects from the server.
    for(var x = 0; x < foods_length; x++)
    {
        var food_avatar = foods[x].avatar_location;
        var food_id = foods[x].food_id;
        var food_label = foods[x].label.capitalize();
        var food_name = foods[x].name;
        var food_phone_number = foods[x].phone_number;

        var food_item_avatar = '<div class="accordion_image"><img src="'+food_avatar+'"></div>';

        var food_item_name = '<li>'+food_name+'</li>';
        var food_item_label = '<li>Type: '+food_label+'</li>';
        var food_item_phone_number = '<li>Phone Number: '+food_phone_number+'</li>';
        var food_item_information = '<div class="accordion_information"><ul>'+food_item_name+food_item_label+food_item_phone_number+'</ul></div>';

        var food_list_item = '<li class="accordion_item" data-type="food" data-label="'+food_label+'" onclick="load_service('+food_id+')">'+food_item_avatar+food_item_information+'</li>';
        rendered_foods = rendered_foods+food_list_item;
    }
    $('.content_body').html('<div class="body_food"><ul>'+rendered_foods+'</ul></div>').show().css('display', 'block'); // This will put all the new HTML into the content body.
    load_foods_delis();*/
    $('.content_body').html('<div class="warning">This feature is coming soon to NiteSite.</div>');
};

load_foods_delis = function()
{
    $('li[data-type=food]').hide();
    $('li[data-type=food][data-label=Deli]').fadeIn(20);
}

load_foods_pizzerias = function()
{
    $('li[data-type=food]').hide();
    $('li[data-type=food][data-label=Pizzeria]').fadeIn(20);
}

load_foods_restaurants = function()
{
    $('li[data-type=food]').hide();
    $('li[data-type=food][data-label=Restaurant]').fadeIn(20);
}

load_food = function(id)
{
    if(window.location != 'http://nitesite.co/food/'+id)
    {
        window.location = '/food/'+id+'.json';
    }
    else
    {
        load_cab_page();
    }
}
load_food_page = function(id)
{

}

get_food = function()
{
    var response = $.ajax({ type: "GET",
        url: "/services/list.json",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}