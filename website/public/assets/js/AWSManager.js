// Configure credentials in the SDK
AWS.config.update({accessKeyId: 'AKIAI2AM7WJCCZUUMILQ', secretAccessKey: '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'});

// Region configuration is not necessary for s3

// Create a bucket for each category
// Potentially, if there are too many objects inside of one bucket, then we create a new bucket for that category

// Each created bucket needs to be stored within a database and pulled from that database to keep track of the buckets that we have.
// Granted that will be impossible for an app made by Adebayo Ijidakinro because he gets far too many buckets to keep track of/

// Add our post images to the bucket

function addPicturesToBucket (pictures) {

	var s3 = new AWS.S3({ params: { Bucket: 'whatsgoingonnow-familyfriendly' } } );
	pictures = $(document).data("pictures");

	for (var i = pictures.length - 1; i >= 0; i--) {
		var params = { Key: 'image', Body: pictures[i] };
		s3.putObject(params, function (err, data) {
			console.log(err);
		});
	};
};