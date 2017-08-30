/**
 * User: Mohamed Eid
 * Date: 3/21/13
 * Time: 10:14 PM
 */
load_cabs = function()
{
    if(window.location != 'http://nitesite.co/cabs')
    {
        window.location = '/cabs';
    }
    else
    {
        load_cabs_page();
    }
}
load_cabs_page = function()
{
    reset_slides();
    update_browser("Cabs", "cabs", "");
    service_page = "cabs";
    var services_switch = '<div class="segmented_control" style="left:121px;"><div class="button" onclick="load_foods()">Food</div><div class="button plain_button_selected">Cabs</div></div>';
    render_navigator(services_switch);

    var response = $.ajax({ type: "GET",
        url: "/cabs/list",
        async: false
    }).responseText;
    var cabs = jQuery.parseJSON(response);
    var cabs_keys = Object.keys(cabs);
    var cabs_length = cabs_keys.length;
    var rendered_cabs = "";

    // The following creates HTML using the retrieved JSON objects from the server.
    for(var x = 0; x < cabs_length; x++)
    {
        var cab_avatar;
        var cab_id = cabs[x].cab_id;
        var cab_name = cabs[x].name;
        var cab_phone_number = cabs[x].phone_number;

        var avatar_location = '/services/'+cab_id+'/avatar.png';
        $.ajax({
            url: avatar_location,
            type: 'HEAD',
            error: function()
            {
                // The cab service has not uploaded a picture yet. This will render the default cab account image for the group list item.
                cab_avatar = '/cabs/avatar.png';
            },
            success: function()
            {
                // The cab service has previously uploaded a picture. This will render the cab avatar for the group list item.
                cab_avatar = avatar_location;
            }
        });
        var cab_item_avatar = '<div class="accordion_image"><img src="'+cab_avatar+'"></div>';

        var cab_item_name = '<li>'+cab_name+'</li>';
        var cab_item_phone_number = '<li>Phone Number: '+cab_phone_number+'</li>';
        var cab_item_information = '<div class="accordion_information"><ul>'+cab_item_name+cab_item_phone_number+'</ul></div>';

        var cab_list_item = '<li class="accordion_item" onclick="load_cab('+cab_id+')">'+cab_item_avatar+cab_item_information+'</li>';
        rendered_cabs = rendered_cabs+cab_list_item;
    }
    $('.content_body').html('<div class="body_cabs"><ul>'+rendered_cabs+'</ul></div>').fadeIn(100); // This will put all the new HTML into the content body.
};

load_cab = function(id)
{
    if(window.location != 'http://nitesite.co/cabs/'+id)
    {
        window.location = '/cabs/'+id;
    }
    else
    {
        load_cab_page();
    }
}
load_cab_page = function(id)
{
    reset_slides();

}
