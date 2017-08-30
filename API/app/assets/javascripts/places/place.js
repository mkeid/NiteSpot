/**
 * Created with JetBrains RubyMine.
 * User: mohamedeid
 * Date: 7/1/13
 * Time: 11:01 PM
 * To change this template use File | Settings | File Templates.
 */


function getPlace(place_id, avatar_size){
    var response = $.ajax({ type: "GET",
        url: "/places/"+place_id.toString()+".json",
        async: false,
        data: {
            avatar_size: avatar_size
        }
    }).responseText;
    return jQuery.parseJSON(response);
}