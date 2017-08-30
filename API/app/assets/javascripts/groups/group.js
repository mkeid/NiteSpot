/**
 * Created with JetBrains RubyMine.
 * User: mohamedeid
 * Date: 6/29/13
 * Time: 10:44 PM
 * To change this template use File | Settings | File Templates.
 */

var GroupModel = Backbone.Model.extend({
    urlRoot: '/groups',
    addAdmin: function(userID) {
        var groupID = this.id;
        $.ajax({
            type: "POST",
            url: "/groups/"+this.id+"/admin_add",
            data: {
                "user_id": userID
            },
            success: function() {
                $('.button_special[data-id='+groupID+'][data-user-id='+userID+'][data-action=addAdmin]').addClass('liked').data('action', 'removeAdmin').attr('data-action', 'removeAdmin').prop('title', "Remove administrative\nprivileges from this user.");
                initialize_tooltip();
            }
        });
    },
    removeAdmin: function(userID) {
        var groupID = this.id;
        $.ajax({
            type: "POST",
            url: "/groups/"+this.id+"/admin_remove",
            data: {
                "user_id": userID
            },
            success: function() {
                $('.button_special[data-id='+groupID+'][data-user-id='+userID+'][data-action=removeAdmin]').removeClass('liked').data('action', 'addAdmin').attr('data-action', 'addAdmin').prop('title', "Give administrative\nprivileges from this user.");
                initialize_tooltip();
            }
        });
    },
    removeUser: function(userID) {
        var groupID = this.id;
        $.ajax({
            type: "POST",
            url: "/groups/"+this.id+"/user_remove",
            data: {
                "user_id": userID
            },
            success: function() {
                $('li[data-class=group][data-user-id='+userID+']').remove();
            }
        });
    }
});

var GroupsView = Backbone.View.extend({
    initialize: function() {
        window.onhashchange = function(){
            switch(location.hash) {
                case '#invite':
                    this.launchInviteToGroupModal();
                    break;
                case '#requests':
                    this.launchRequestsModal();
                    break;
            }
        }
    },
    launchRequestsModal: function() {
        $('#requestsModal').modal();
    },
    launchInviteToGroupModal: function() {
        $('#inviteModal').modal();
    },
    launchInviteToPartyModal: function(partyID) {
    },
    launchSuccessModal: function(type) {
        switch(type) {
            case 'party':
                $('#successPartyModal').modal();
                break;
            case 'settings':
                break;
        }
    }
});

function getGroup(group_id, avatar_size)
{
    var response = $.ajax({ type: "GET",
        url: "/groups/"+group_id+".json",
        async: false,
        data: {
            avatar_size: avatar_size
        }
    }).responseText;

    return jQuery.parseJSON(response);
}