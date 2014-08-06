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
		var pictureIds = [];

		for (var i = pictures.length - 1; i >= 0; i--) {
			pictureIds[i] = $('#event-title').val().replace(/\s/g, '') + createGuid().substring(0, 8);
			//Call this method within AWSManager.js and post the images to Amazon S3 and the data to parse.  
			addPicturesToBucket(pictures[i], pictureIds[i]);
		};

		myEvent.set('imageids', pictureIds);

		myEvent.save(null, {
			success: function (myEvent) {
				console.log('New object created with objectId: ' + myEvent.id);
			},
			error: function (myEvent, error) {
				alert('Failed to create new object, with error code: ' + error.message);
			}
		});

	});

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
		var startTime = $('#start-time-combodate').combodate('getValue', 'DD-MM-YYYY HH:mm');
		var endTime = $('#end-time-combodate').combodate('getValue', 'DD-MM-YYYY HH:mm');
		var cost = $('#cost-box').text();
		var category = $('#category-box').text();
		var postRange = $('#post-range-box').text();

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

