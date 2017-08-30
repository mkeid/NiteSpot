/**
 * Name: Mohamed Eid
 * Date: 3/31/13
 * Time: 8:21 PM
 *
 * This function allows you to generate an HTML item instead of having to manually type it out.
 */

function generate_html(object)
{
    var element_tag = object.tag;
    var element_id = object.id;
    var element_class = object.class;
    var element_title = object.title;
    var element_src = object.src;
    var element_href = object.href;
    var element_onclick = object.onclick;
    var element_data = object.data;
    var element_html = object.html;

    if(element_id != null){
        element_id = 'id="'+element_id+'"';
    }
    else{
        element_id = '';
    }

    if(element_class != null){
        element_class = 'class="'+element_class+'"';
    }
    else{
        element_class = '';
    }

    if(element_title != null){
        element_title = 'title="'+element_title+'"';
    }
    else{
        element_title = '';
    }

    if(element_src != null){
        element_src = 'src="'+element_src+'"';
    }
    else{
        element_src = '';
    }

    if(element_href != null){
        element_href = 'href="'+element_href+'"';
    }
    else{
        element_href = '';
    }

    if(element_onclick != null){
        element_onclick = 'onclick="'+element_onclick+'"';
    }
    else{
        element_onclick = '';
    }

    var element_data2 = '';
    var data_keys = [];
    var data_values = [];
    if(element_data != null){
        for(var key in object.data)
        {
            if(object.data.hasOwnProperty(key))
            {
                data_keys.push(key);
                data_values.push(object.data[key]);
            }
        }
        for(var x = 0; x < Object.keys(object.data).length; x++)
        {
            element_data2 = element_data2+'data-'+data_keys[x]+'="'+data_values[x]+'" '
        }
    }

    if(element_html == null){
        element_html = '';
    }

    return '<'+element_tag+' '+element_id+' '+element_class+' '+element_title+'  '+element_src+' '+element_href+' '+element_onclick+'  '+element_data2+'>'+element_html+'</'+element_tag+'>';
}
