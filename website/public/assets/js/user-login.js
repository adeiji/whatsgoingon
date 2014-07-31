$(document).ready(function () {

	var signUpButton = $("#sign-up-button");
	var signInButton = $("#sign-in-button");
	var INPUT_USERNAME = "username";
    var INPUT_PASSWORD = "password";
   	var INPUT_EMAIL = "email";
   	var logoutButton = $("#logout");

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
	 			window.location.replace('../index.html');
	 		},
	 		error: function  () {
	 			//Show error message and let the user try again.
	 		}
	 	})
	});
	//Get the username and the password from the input boxes and then sign in using parse
	signInButton.click(function  () {

		var username = $('input[name=' + INPUT_USERNAME + ']').val();
		var password = $('input[name=' + INPUT_PASSWORD + ']').val();

		Parse.User.logIn(username, password, {
			success: function (user) {
				window.location.replace('../index.html');
			},
			error: function (user, error) {
				console.log('Error logging in: ', error);
			}
		});
	})


});