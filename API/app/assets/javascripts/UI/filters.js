// This filters the year of people.
year_filter = function(year, fade)
{
    $('.warning').remove();
    hide_all_years = function()
    {
        $(".year_all").hide();
        $(".year_freshmen").hide();
        $(".year_sophomore").hide();
        $(".year_junior").hide();
        $(".year_senior").hide();
    }
    edit_selection = function(year)
    {
        // The following resets all the CSS for the buttons in the selection controller.
        $("#button_all").addClass("button").removeClass("plain_button_selected");
        $("#button_fr").addClass("button").removeClass("plain_button_selected");
        $("#button_so").addClass("button").removeClass("plain_button_selected");
        $("#button_jr").addClass("button").removeClass("plain_button_selected");
        $("#button_sr").addClass("button").removeClass("plain_button_selected");

        // The following will make the year selection controller buttton appear clicked.
        switch(year)
        {
            case "all":
                $("#button_all").addClass("plain_button_selected");
                break;
            case "freshmen":
                $("#button_fr").addClass("plain_button_selected");
                break;
            case "sophomore":
                $("#button_so").addClass("plain_button_selected");
                break;
            case "junior":
                $("#button_jr").addClass("plain_button_selected");
                break;
            case "senior":
                $("#button_sr").addClass("plain_button_selected");
                break;
        }
    }
    switch(year)
    {
        case "all":
            selected_year = "all";
            hide_all_years();
            edit_selection(year);
            if(fade == false)
            {
                $(".year_all").show();
            }
            else
            {
                $(".year_all").fadeIn(100);
            }
            if($('.year_all').length == 0)
            {
                $('.profile_contents').append('<div class="warning">No users were found.</div>');
            }
            break;
        case "freshmen":
            selected_year = "freshmen";
            hide_all_years();
            edit_selection(year);
            if(fade == false)
            {
                $(".year_freshmen").show();
                edit_selection(year);
            }
            else
            {
                $(".year_freshmen").fadeIn(100);
            }
            if($('.year_freshmen').length == 0)
            {
                $('.profile_contents').append('<div class="warning">No freshmen were found.</div>');
            }
            break;
        case "sophomore":
            selected_year = "sophomore";
            hide_all_years();
            edit_selection(year);
            if(fade == false)
            {
                $(".year_sophomore").show();
            }
            else
            {
                $(".year_sophomore").fadeIn(100);
            }
            if($('.year_sophomore').length == 0)
            {
                $('.profile_contents').append('<div class="warning">No sophomores were found.</div>');
            }
            break;
        case "junior":
            selected_year = "junior";
            hide_all_years();
            edit_selection(year);
            if(fade == false)
            {
                $(".year_junior").show();
            }
            else
            {
                $(".year_junior").fadeIn(100);
            }
            if($('.year_junior').length == 0)
            {
                $('.profile_contents').append('<div class="warning">No juniors were found.</div>');
            }
            break;
        case "senior":
            selected_year = "senior";
            hide_all_years();
            edit_selection(year);
            if(fade == false)
            {
                $(".year_senior").show();
            }
            else
            {
                $(".year_senior").fadeIn(100);
            }
            if($('.year_senior').length == 0)
            {
                $('.profile_contents').append('<div class="warning">No seniors were found.</div>');
            }
            break;
    }
}