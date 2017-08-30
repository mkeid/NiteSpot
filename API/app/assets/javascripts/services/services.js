var service_page = "food";
load_services = function()
{
  switch(service_page)
  {
      case "food":
          load_foods();
          break;
      case "cabs":
          load_cabs();
          break;
      default:
          load_foods();
          break;
  }
};

load_service = function(id)
{
    reset_slides();
    if(id == account_id)
    {
    }
    else
    {
    }
    var button_settings = "";
    render_navigator(button_settings);
};