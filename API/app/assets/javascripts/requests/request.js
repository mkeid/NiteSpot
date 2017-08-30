/**
 * Name: Mohamed Eid
 * Date: 6/28/13
 * Time: 9:17 PM
 */

var RequestModel = Backbone.Model.extend({
    urlRoot: '/requests',
    accept: function() {
        $.ajax({
            type: "POST",
            url: "/requests/"+this.id+"/accept",
            success: function()
            {
                adjust_alerts(1);
                var listItem = $('li[data-request-id="'+String(this.id)+'"]');
                listItem.ready(function() {
                    listItem.remove();
                });
                requestsView.updateCounter();
            }
        });
    },
    deny: function (){
        $.ajax({
            type: "POST",
            url: "/requests/"+this.id+"/destroy",
            success: function()
            {
                adjust_alerts(1);
                var listItem = $('li[data-request-id="'+String(this.id)+'"]');
                listItem.ready(function() {
                    listItem.remove();
                });
                requestsView.updateCounter();
            }
        });
    }
});

var RequestsView = Backbone.View.extend({
    initialize: function() {
        this.counter = 0;
        this.render(getRequestsList());
    },
    appendItem: function(item) { // This will append create and append a list item into the notifications list.
        this.counter++;

        var alert_left, message;
        switch(item.get('request_type'))
        {
            case 'group_invite':
                alert_left = '<div class="alert_left"><a href="/groups/'+item.get('from_group')+'"><img src="'+item.get('avatar_location')+'"></a></div>';
                message = '<a class="user_name" href="/groups/'+item.get('from_group')+'">'+item.get('name')+'</a> ' +
                    'wants you to join its group.';
                break;
            case 'user_follow':
                alert_left = '<div class="alert_left"><a href="/users/'+item.get('from_user')+'"><img src="'+item.get('avatar_location')+'"></a></div>';
                message = '<a class="user_name" href="/users/'+item.get('from_user')+'">'+item.get('name')+'</a> ' +
                    'wants to follow you.';
                break;
        }
        var button_field = '<div class="request_button_field">' +
            '<div data-request-id="'+item.get('id')+'" class="action button_accept" data-id="'+item.get("id")+'" data-class="request" data-action="accept">Accept</div>' +
            '<div data-request-id="'+item.get('id')+'" class="action button_deny" data-id="'+item.get("id")+'" data-class="request" data-action="deny">Deny</div>' +
            '</div>';

        var alert_right = '<div class="alert_right">'+message+button_field+'</div>';
        var alert = '<li class="alert_item " data-request-id="'+item.get('id')+'" data-id="'+item.get('id')+'" data-class="request">'+alert_left+alert_right+'</li>';
        
        $(this.el).append(alert);
    },
    render: function(list) {
        var template = _.template($("#requests_list").html(), {});
        this.$el.html(template);
        var self = this;
        _(list.models).each(function(item){
            self.appendItem(item);
            initialize_actions();
        }, this);
    },
    update: function() {
    },
    updateCounter: function() {
        var countElement = $('span[data-label=count_requests]');
        countElement.html(parseInt(countElement.html())-1);
    }
});

var RequestsList = Backbone.Collection.extend({
    Model: RequestModel
});

function getRequests()
{
    var response = $.ajax({ type: "GET",
        url: "/requests/list",
        async: false
    }).responseText;
    return jQuery.parseJSON(response);
}

function getRequestsList() {
    var requestsList = new RequestsList([]);
    var requests = getRequests();
    $.each(requests, function(index, request) {
        requestsList.push(new NotificationModel(request));
    });
    return requestsList;
}

var requestsView;
function renderRequestsList() {
    $('#notifications_list').hide();
    $('.button_notifications').css('border', '1px solid rgba(0,0,0,0)');
    $('#requests_list').show();
    $('.button_requests').css('border', '1px solid rgba(0,153,255,1)');
    if(requestsView != undefined) {
        requestsView.update();
    }
    else {
        requestsView = new RequestsView({el: $("#requests_list")});
    }
}