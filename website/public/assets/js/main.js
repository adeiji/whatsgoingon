$(document).ready(function () {

	var pictures= [];
	var pictureIndex = 0;

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

	$('#fileupload').on('change', function (ev) {
		var file = ev.target.files[0];
		var fileReader = new FileReader();

		fileReader.onload = function (ev2) {
			console.dir(ev2);
			pictureIndex = pictureIndex + 1;
			$('.post-image[index=' + pictureIndex + ']').attr('src', ev2.target.result);
			
			pictures[pictureIndex] = file;
			// Attach the pictures array to the document DOM element to allow reading within a different javascript file
			$(document).data("pictures", pictures);
		};

		fileReader.readAsDataURL(file);
	});

	$('#post-button').on('click', function  () {
		//Call this method within AWSManager.js and post the images to Amazon S3 and the data to parse
		
		addPicturesToBucket(pictures);			
				
	});
});

