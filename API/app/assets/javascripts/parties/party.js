/**
 * Created with JetBrains RubyMine.
 * User: mohamedeid
 * Date: 7/1/13
 * Time: 8:29 AM
 * To change this template use File | Settings | File Templates.
 */

var PartyModel = Backbone.Model.extend({
    create: function() {
        $.ajax({
            type: "POST",
            url: "/parties",
            data: {
                "group_id": this.group_id,
                "party[name]": this.name,
                "party[address]": this.address,
                "party[description]": this.description,
                "party[public]": this.public,
                "party[month]": this.month,
                "party[day]": this.day,
                "party[hour]": this.hour,
                "party[minute]": this.minute
            },
            success: function(){
                window.location = '/groups/'+group_id.toString()+'/members#sucessParty'
            }
        });
    }
});