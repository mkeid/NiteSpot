/**
 * Name: Mohamed Eid
 * Date: 6/28/13
 * Time: 4:34 PM
 */

var NotificationModel = Backbone.Model.extend({
    urlRoot: '/notifications'
});

var NotificationsView = Backbone.View.extend({
    initialize: function() {
        this.counter = 0;
        this.render(getNotificationsList());
    },
    appendItem: function(item) { // This will append create and append a list item into the notifications list.
        this.counter++;
        if(item.get('unchecked'))adjust_alerts(1);

        var listItemAvatar = '<img src="'+item.get("avatar_location")+'">';
        var listItemLeft;
        if(item.get("from_user") != null) {
            listItemLeft = '<div class="alert_left"><a href="/users/'+item.get("from_user")+'/feed">'+listItemAvatar+'</a></div>';
        }
        else if(item.get("from_group") != null) {
            listItemLeft = '<div class="alert_left"><a href="/groups/'+item.get("from_group")+'/members">'+listItemAvatar+'</a></div>';
        }

        var listItemMessage;
        switch(item.get("notification_type")) {
            case 'follow_accept':
                listItemMessage = '<a href="/users/'+item.get("from_user")+'/feed">'+item.get("name")+'</a> accepted your follow request';
                break;
            case 'party_invite':
                listItemMessage = '<a href="/groups/'+item.get("from_group")+'/members">'+item.get("name")+'</a> invited you to its <a>party</a>';
                break;
            case 'shout_like':
                listItemMessage = '<a href="/users/'+item.get("from_user")+'/feed">'+item.get("name")+'</a> liked your <a>shout</a>';
                break;
            case 'user_follow':
                listItemMessage = '<a href="/users/'+item.get("from_user")+'/feed">'+item.get("name")+'</a> started following you';
                break;
        }
        var listItemTime = ' <div class="alert_time">'+item.get("time")+'</div>';
        var listItemRight = '<div class="alert_right">'+listItemMessage+listItemTime+'</div>';

        var listItem = '<li class="alert_item unchecked_'+item.get('unchecked')+'" data-unchecked='+item.get('unchecked')+'>'+listItemLeft+listItemRight+'</li>';
        $(this.el).append(listItem);
    },
    render: function(list) {
        var template = _.template($("#notifications_list").html(), {});
        this.$el.html(template);
        var self = this;
        _(list.models).each(function(item){
            self.appendItem(item);
        }, this);
        $('span[data-label=count_notifications]').html('0');
    },
    update: function() {
    }
});

var NotificationsList = Backbone.Collection.extend({
    Model: NotificationModel
});

function getNotifications()
{
    var response = $.ajax({ type: "GET",
        url: "/notifications/list",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

function getNotificationsList() {
    var notificationsList = new NotificationsList([]);
    var notifications = getNotifications();
    $.each(notifications, function(index, notification) {
        notificationsList.push(new NotificationModel(notification));
    });
    return notificationsList;
}

var notificationsView;
function renderNotificationsList() {
    $('#requests_list').hide();
    $('.button_requests').css('border', '1px solid rgba(0,0,0,0)');
    $('#notifications_list').show();
    $('.button_notifications').css('border', '1px solid rgba(0,153,255,1)');
    if(notificationsView != undefined) {
        notificationsView.update();
    }
    else {
        notificationsView = new NotificationsView({el: $("#notifications_list")});
    }
}