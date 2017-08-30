signup_success = function()
{
	create_alert("An confirmation link to activate your account has been sent to your email address. Click it to start using NiteSite");
	window.history.pushState("object or string", "Title", "/signup");
}

signup_taken = function()
{
	create_alert("An account has already been signed up with that email.");
	window.history.pushState("object or string", "Title", "/signup");
}