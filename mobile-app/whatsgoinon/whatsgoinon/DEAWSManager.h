//
//  DEAWSManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEAWSManager : NSObject

// Connect to the AWS Server
- (NSError *) connectToAWS;
// Upload the given data to the Amazon S3 server.  If there is an error then we return it so it can be handled.
- (NSError *) uploadDataToS3;


@end
