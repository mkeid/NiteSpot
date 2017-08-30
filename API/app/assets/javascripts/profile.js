/**
 * Name: Mohamed Eid
 * Date: 3/22/13
 * Time: 2:13 AM
 */

load_profile = function(account_type, id)
{
    switch(account_type)
    {
        case 'group':
            load_group(id);
            break;
        case 'place':
            load_place(id);
            break;
        case 'service':
            load_service(id);
            break;
        case 'user':
            load_user_page(id);
            break;
        default:
            break;
    }
}
