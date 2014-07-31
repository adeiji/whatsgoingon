$(document).ready(function () {

	var signUpButton = $("#sign-up-button");
	var INPUT_USERNAME = "username";
    var INPUT_PASSWORD = "password";
   	var INPUT_EMAIL = "email";

    //Update the initialization call with my Application ID and Javascript Key
    Parse.initialize("3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR", "qqfASuIFfbkcr8mmLIFsxdkI1AGHJZy4cNKl7ujd");

	signUpButton.click(function () {
		
		var user = new Parse.User();

		// get all the inputs into an array.
	    var $inputs = $('#signup-form :input');

	    //traverse through all the inputs and store them by name in the values array
	    var values = {};
	    $inputs.each(function() {
	        values[this.name] = $(this).val();
	    });

	    var username = values[INPUT_USERNAME];
	    var password = values[INPUT_PASSWORD];
	    var email = values[INPUT_EMAIL];

	 	user.set("username", username);
	 	user.set("password", password);
	 	user.set("email", email);

	 	user.signUp(null, {
	 		success: function user () {
	 			// Let them use the app now
	 		},
	 		error: function  () {
	 			//Show error message and let the user try again.
	 		}
	 	})
	});

});