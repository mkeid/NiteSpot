/**
 * Name: Mohamed Eid
 * Date: 6/24/13
 * Time: 5:04 AM
 */

$('.ns').ready(function(){
    var logo = $('.ns');
    var bar = $('.bar_left');
    logo.mouseover(function(){
        open_menu();
    });
    logo.click(function(){
        open_menu();
    });
    $('html').mouseover(function(){
        logo.removeClass('active');
        bar.animate({
            'left': -220
        }, 80);
    });
    logo.mouseover(function(event){
        event.stopPropagation();
    });
    bar.mouseover(function(event){
        event.stopPropagation();
    });
    open_menu = function()
    {
        bar.show().animate({
            'left': 0
        }, 80);
    }
});

$('.button_alerts').ready(function(){
    $('.button_alerts').click(function(){
        show_alerts();
    });
});
$('.button_alerts_new').ready(function(){
    $('.button_alerts_new').click(function(){
        show_alerts();
    });
});

signout = function()
{
    window.location = '/signout';
}

var alerts_open = false;
show_alerts = function()
{
    if(!alerts_open)
    {
        $('body').css('overflow', 'none');
        var backdrop = $('.backdrop');
        var alerts =  $('.bar_alerts');
        var label = $('.alerts_label');
        backdrop.fadeIn(80).animate({
            left: '-=250px'
        },80);
        alerts.fadeIn(80).animate({
            right: 0
        },80);
        backdrop.click(function(){
            hide_alerts();
        });
        label.fadeIn(80);
        alerts_open = true;
        renderNotificationsList();
    }
    else
    {
        hide_alerts();
    }
}

hide_alerts = function()
{
    $('body').css('overflow', 'auto');
    var backdrop = $('.backdrop');
    var alerts =  $('.bar_alerts');
    var label = $('.alerts_label');
    if(backdrop.css('display') != 'none')
    {
        backdrop.fadeOut(120, function(){
            $(this).css('left', '0');
        });
    }
    alerts.animate({
        right: -250
    },80, function(){
        alerts.hide();
    });
    label.fadeOut(80);
    alerts_open = false;
}

render_requests = function()
{
    $('.button_notifications').css('border', '1px solid rgba(0,0,0,0)');
    $('.button_requests').css('border', '1px solid rgba(0,153,255,1)');
    var list = $('.alerts_list');
    list.html('');
    var requests = get_requests('user', null);
    var keys = Object.keys(requests);

    var alert, alert_left, alert_right, message, button_field;
    for(var x = 0; x < keys.length; x++)
    {
        switch(requests[x].request_type)
        {
            case 'group_invite':
                alert_left = '<div class="alert_left"><a href="/groups/'+requests[x].from_group+'"><img src="'+requests[x].avatar_location+'"></a></div>';
                message = '<a class="user_name" href="/groups/'+requests[x].from_group+'">'+requests[x].name+'</a> ' +
                    'wants you to join its group.';
                break;
            case 'user_follow':
                alert_left = '<div class="alert_left"><a href="/users/'+requests[x].from_user+'"><img src="'+requests[x].avatar_location+'"></a></div>';
                message = '<a class="user_name" href="/users/'+requests[x].from_user+'">'+requests[x].name+'</a> ' +
                    'wants to follow you.';
                break;
        }
        button_field = '<div class="request_button_field">' +
            '<div data-request-id="'+requests[x].id+'" class="button_accept">Accept</div>' +
            '<div data-request-id="'+requests[x].id+'" class="button_deny">Deny</div>' +
            '</div>';

        alert_right = '<div class="alert_right">'+message+button_field+'</div>';
        alert = '<li data-request-id="'+requests[x].id+'" class="alert_item ">'+alert_left+alert_right+'</li>';

        list.append(alert);
    }
    $('.button_accept').ready(function(){
        $('.button_accept').click(function(){
            request_accept($(this).data('request-id'));
        });
    });
    $('.button_deny').ready(function(){
        $('.button_deny').click(function(){
            request_deny($(this).data('request-id'));
        });
    });
}

adjust_alerts = function(number)
{
    var button = $('.button_alerts_new');
    var count_alerts = parseInt(button.html());
    var new_count_alerts = count_alerts - number;
    button.html(new_count_alerts);
    if(new_count_alerts == 0)button.removeClass('button_alerts_new').addClass('button_alerts');
}

$('.button_requests').ready(function(){
    $('.button_requests').click(function(){
        renderRequestsList();
    });
});
$('.button_notifications').ready(function(){
    $('.button_notifications').click(function(){
        renderNotificationsList();
    });
});
