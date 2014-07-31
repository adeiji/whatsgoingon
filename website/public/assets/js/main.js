$(document).ready(function () {

	//Update the initialization call with my Application ID and Javascript Key
    Parse.initialize("3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR", "qqfASuIFfbkcr8mmLIFsxdkI1AGHJZy4cNKl7ujd");
    
    //Get necessary dom elements
    var logoutButton = $("#logout");

	//Check to see if there is already a user logged in, and if not we take the user to the login screen.
	var currentUser = Parse.User.current();

	if (currentUser) {
		//If there is a user already logged in then we stay on this page		
	}
	else {
		//show the sign up - login screen
		window.location.replace('../login.html');
	}

	logoutButton.click(function  () {
		Parse.User.logOut();
	});

	$(function () {
	    $('#fileupload').fileupload({
	        dataType: 'json',
	        done: function (e, data) {
	            $.each(data.result.files, function (index, file) {
	                alert('We were successful');
	            });
	    }
    });
});
});