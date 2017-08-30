/**
 * Name: Mohamed Eid
 * Date: 6/27/13
 * Time: 1:53 PM
] */

$('[rel=popover]').ready(function() {
    var feedItem = $('[rel=popover]');
    feedItem.mouseenter(function() {
        var element = $(this);
        setTimeout(function() {
            if(element.is(':hover')) {
                var id = element.data('id');
                var object;
                var url;
                switch(element.data('class')) {
                    case 'group':
                        object = getGroup(id, 'tiny');
                        url = '/groups/'+object.id+'/members';
                        element.popover({
                            html: true,
                            animation: true,
                            placement: 'left',
                            title: '<a href="'+url+'" class="user_name"><img src="'+object.avatar_location+'"> '+object.name+'</a>',
                            content: generate_html({
                                tag: 'ul',
                                html: '<a href="/groups/'+object.id+'/members">'+generate_html({tag: 'li', html: object.count_members+' Members'})+'</a>' + '<hr>' +
                                    '<a href="/groups/'+object.id+'/admins">'+generate_html({tag: 'li', html: object.count_admins+' Admins'})+'</a>' + '<hr>' +
                                    '<a href="/groups/'+object.id+'/parties">'+generate_html({tag: 'li', html: object.count_parties+' Parties'})+'</a>'
                            }),
                            container: 'body'
                        });
                        break;
                    case 'place':
                        object = getPlace(id, 'tiny');
                        url = '/places/'+object.id+'/attending_users';
                        element.popover({
                            html: true,
                            animation: true,
                            placement: 'left',
                            title: '<a href="'+url+'" class="user_name"><img src="'+object.avatar_location+'"> '+object.name+'</a>',
                            content: generate_html({
                                tag: 'ul',
                                html: '<a href="/places/'+object.id+'/attending_users">'+generate_html({tag: 'li', html: 'Attending Users'})+'</a>' + '<hr>' +
                                    '<a href="/places/'+object.id+'/top_attendees">'+generate_html({tag: 'li', html: 'Top Attendees'})+'</a>'
                            }),
                            container: 'body'
                        });
                        break;
                    case 'user':
                        object = getUser(id, 'tiny');
                        url = '/users/'+object.id+'/feed';
                        element.popover({
                            html: true,
                            animation: true,
                            placement: 'left',
                            title: '<a href="'+url+'" class="user_name"><img src="'+object.avatar_location+'"> '+object.name+'</a>',
                            content: generate_html({
                                tag: 'ul',
                                html: '<a href="/users/'+object.id+'/followed_users">'+generate_html({tag: 'li', html: object.following_count+' Following'})+'</a>' + '<hr>' +
                                    '<a href="/users/'+object.id+'/followers">'+generate_html({tag: 'li', html: object.follower_count+' Followers'})+'</a>' + '<hr>' +
                                    '<a href="/users/'+object.id+'/groups">'+generate_html({tag: 'li', html: object.group_count+' Groups'})+'</a>' + '<hr>' +
                                    '<a href="/users/'+object.id+'/feed">'+generate_html({tag: 'li', html: object.shout_count+' Shouts'})+'</a>'
                            }),
                            container: 'body'
                        });
                        break;
                }
                element.popover('show');
            }
        }, 500);
    });
    feedItem.mouseleave(function() {
        var element = $(this);
        setTimeout(function() {
            if(!element.is(':hover') && !$('.popover').is(':hover')) {
                element.popover('hide');
            }
            else {
                $('.popover').ready(function() {
                    $('.popover').mouseleave(function() {
                        element.popover('hide');
                    });
                });
            }
        }, 30);
    });
});