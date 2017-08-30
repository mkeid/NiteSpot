/**
 * Name: Mohamed Eid
 * Date: 3/21/13
 * Time: 5:06 AM
 */

function load_feed()
{

}

function get_feed()
{
    var response = $.ajax({ type: "GET",
        url: "/shouts/list",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}