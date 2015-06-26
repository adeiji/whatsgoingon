
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

var ParseImage = require("parse-image");

Parse.Cloud.afterSave("Event", function(request, response) {

	// Make sure that we only run this code when the object is first saved
	if (!request.object.get("imageHeight"))
	{
		var file = request.object.get("images")[0];	// Get the main image for the event
		console.log(file.url());				
		// Get the actual image from the file url and then store that image width and height
		Parse.Cloud.httpRequest({
			url : file.url()
		}).then(function (response) {
			var image = new ParseImage();
			image.setData(response.buffer, {
				success: function () {
					request.object.set('imageWidth', image.width());
					request.object.set('imageHeight', image.height());
					request.object.save();
				}
			});
		}, function (response) {
			console.log("Request failed with response code: " + response.status);
		});
	}	

	console.log(request);
	var query = new Parse.Query(Parse.User);
	query.equalTo("username", request.object.get("username"));
	console.log(request.object.get("username"));
	query.find({
		success: function (results) {
			console.log(results);
			if (results[0].get("active") == false) {
				request.object.destroy({
					error : function () {
						console.log("User is invalid but object was not succesfully deleted");
					},
					success : function () {
						console.log("Object was deleted because user is invalid");	
					}
				});
			}
			else {
				console.log("User is valid");
			}
		},
		error : function () {
			console.log("Error after saving of the object");
		}
	});
});
