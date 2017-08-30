/**
 * Name: Mohamed Eid
 * Date: 5/29/13
 * Time: 3:46 PM
 */

create_button_follow = function(user_id, relation)
{
    switch(relation)
    {
        case 'following':
            return '<div data-id='+user_id+' data-class="user" data-action="unfollow" data-label="button_relationship" data-location="list_profile" data-type="button_unfollow"  class="action button_edit">Unfollow</div>';
            break;
        case 'not_following':
            return '<div data-id='+user_id+' data-class="user" data-action="follow" data-label="button_relationship" data-location="list_profile" data-type="button_follow" class="action button_edit">Follow</div>';
            break;
        case 'not_following_private':
            return '<div data-id='+user_id+' data-class="user" data-action="follow" data-label="button_relationship" data-location="list_profile" data-type="button_ask" class="action button_edit">Follow</div>';
            break;
        case 'pending':
            return '<div data-id='+user_id+' data-label="button_relationship" data-location="list_profile" data-type="button_pending" class="button_edit greyed_out" style="cursor:default;">Pending</div>';
            break;
        case 'you':
            return '';
            break;
        default:
            return '';
            break;
    }
}