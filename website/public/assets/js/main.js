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
			pictures[pictureIndex - 1] = file;
			
			// Attach the pictures array to the document DOM element to allow reading within a different javascript file
			$(document).data("pictures", pictures);
		};

		fileReader.readAsDataURL(file);
	});

	$('#post-button').on('click', function  () {

		var postParams = createPost();

		var MyEvent = Parse.Object.extend("Event");
		var myEvent = new MyEvent();

		myEvent.set('name', postParams.eventName);
		myEvent.set('address', postParams.eventAddress);
		myEvent.set('description', postParams.eventDescription);
		myEvent.set('starttime', postParams.startTime);
		myEvent.set('endtime', postParams.endTime);
		myEvent.set('cost', postParams.cost);
		myEvent.set('category', postParams.category);
		myEvent.set('postrange', postParams.postRange);
		myEvent.set('user', Parse.User.current()); //Gets the current user that is uploading this item
		myEvent.set('active', true);

		myEvent.save(null, {
			success: function (myEvent) {
				console.log('New object created with objectId: ' + myEvent.id);

				addImage(myEvent);
			},
			error: function (myEvent, error) {
				console.log('Failed to create new object, with error code: ' + error.message);
			}
		});

	});

	function addImage (myEvent) {
		// Create a new Parse Object that will only store images
		// The image will be stored with an ID corresponding to the event
		
		var pictureFiles = [];

		for (var i = 0; i < pictures.length; i++) {
			var pictureFile = new Parse.File("post-image.jpg", pictures[i]);
			
			pictureFiles[i] = pictureFile;
			pictureFile.save().then(function () {
				// The file was saved to parse
				var images = new Parse.Object("Images");

				images.set("eventId", myEvent.id);
				images.set("image", pictureFile);	

				images.save(null, {
					success: function(image) {
						// Execute any logic that should take place after the object is saved.
						console.log('New object created with objectId: ' + image.id);
					},
					error: function(image, error) {
					 	// Execute any logic that should take place if the save fails.
					 	// error is a Parse.Error with an error code and description.
				  		console.log('Failed to create new object, with error code: ' + error.message);
					}
				});
			}, function (error) {
				// Handle the error appropriately
			});
		}
	}

	function createGuid() {
    	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        	var r = Math.random()*16|0, v = c === 'x' ? r : (r&0x3|0x8);
        	return v.toString(16);
    	});
	};

	//Get all the information for this post inputed

	function createPost () {
		var eventName = $('#event-title').val();
		var eventAddress = $('#event-address').val();
		var eventDescription = $('#event-description').val();
		var startTimeString = $('#start-time-combodate').combodate('getValue', 'YYYY-MM-DDTHH:MM:SS');
		var startTime = new Date(startTimeString);
		var endTimeString = $('#end-time-combodate').combodate('getValue', 'YYYY-MM-DDTHH:MM:SS');
		var endTime = new Date(endTimeString);
		var costString = $('#cost-box').text();
		var cost = parseFloat(costString.substring(3));
		var category = $('#category-box').text();
		var postRangeString = $('#post-range-box').text();
		var postRange = parseInt(postRangeString.substring(0, 2));

		var postParams = { 
			eventName : eventName,
			eventAddress : eventAddress,
			eventDescription : eventDescription,
			startTime : startTime,
			endTime : endTime,
			cost : cost,
			category : category,
			postRange : postRange
		};

		return postParams;
	}
});

