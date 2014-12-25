//
//  Constants.h
//  whatsgoinon
//
//  Created by adeiji on 8/12/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const PARSE_CLASS_NAME_EVENT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_ACTIVE;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_TITLE;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_ADDRESS;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_DESCRIPTION;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_START_TIME;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_END_TIME;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_COST;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_CATEGORY;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_POST_RANGE;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_USER;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_LOCATION;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_IMAGES;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_OBJECT_ID;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_COMMENTS;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_RATING;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_QUICK_DESCRIPTION;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_NUMBER_GOING;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_EVENT_USERNAME;

// PFObject - Report
FOUNDATION_EXPORT NSString *const PARSE_CLASS_NAME_REPORT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_REPORT_WHATS_WRONG;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_REPORT_OTHER;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_REPORT_EVENT_ID;
FOUNDATION_EXPORT NSString *const REPORT_VULGAR_OR_ABUSIVE_LANGUAGE;
FOUNDATION_EXPORT NSString *const REPORT_CRUDE_CONTENT;
FOUNDATION_EXPORT NSString *const REPORT_NOT_REAL_POST;
FOUNDATION_EXPORT NSString *const REPORT_POST_NOT_APPROPRIATE;

//PFObject - Miscategorized
FOUNDATION_EXPORT NSString *const PARSE_CLASS_NAME_MISCATEGORIZED_EVENT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_MISCATEGORIZED_EVENT_CATEGORY;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_MISCATEGORIZED_EVENT_ID;


// Parse - Comment
FOUNDATION_EXPORT NSString *const PARSE_CLASS_NAME_COMMENT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_COMMENT_COMMENT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_COMMENT_USER;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_COMMENT_THUMBS_UP;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_COMMENT_EVENT_ID;

// Parse - User
FOUNDATION_EXPORT NSString *const PARSE_CLASS_NAME_USER;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_USERNAME;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_EMAIL;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_PASSWORD;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_VISIBLE_PASSWORD;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_EMAIL_VERIFIED;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_PROFILE_PICTURE;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_EVENTS_GOING;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_EVENTS_MAYBE;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_POST_COUNT;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_RANK;
FOUNDATION_EXPORT NSString *const PARSE_CLASS_USER_CREATED_AT;

// Places Google Maps API
FOUNDATION_EXPORT NSString *const PLACES_API_DATA_RESULT_TYPE_CITIES;
FOUNDATION_EXPORT NSString *const PLACES_API_DATA_RESULT_TYPE_GEOCODE;
FOUNDATION_EXPORT NSString *const PLACES_API_NO_RESULTS;


// Orb Button View
FOUNDATION_EXPORT NSString *const ORB_BUTTON_VIEW;;
FOUNDATION_EXPORT CGFloat const BUTTON_CORNER_RADIUS;

// Notifications
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_ALL_EVENTS_LOADED;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_CITY_CHANGED;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_NO_DATA;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_NONE_IN_CATEGORY;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_ALL_COMMENTS_LOADED;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_POST_FROM_USER_RETRIEVED;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_USER_RANK_RETRIEVED;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_CATEGORY;
FOUNDATION_EXPORT NSString *const NOTIFICATION_CENTER_USER_RETRIEVED;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_EVENTS_COUNT;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_RANK_OBJECT_INFO;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_STILL_LOADING;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW;
FOUNDATION_EXPORT NSString *const kNOTIFICATION_CENTER_EVENT_USER_AT;


// View Controllers
FOUNDATION_EXPORT NSString *const PROMPT_LOGIN_VIEW_CONTROLLER;
FOUNDATION_EXPORT NSString *const LOGIN_ADD_PROFILE_IMAGE_VIEW_CONTROLLER;

// NSUserDefaults
FOUNDATION_EXPORT NSString *const NSUSER_DEFAULTS_PROFILE_PICTURE;

// User Ranks
FOUNDATION_EXPORT NSString *const USER_RANK_AMBASSADOR;
FOUNDATION_EXPORT NSString *const USER_RANK_ADMIN;
FOUNDATION_EXPORT NSString *const USER_RANK_STANDARD;

// Categories
FOUNDATION_EXPORT NSString *const CATEGORY_TRENDING;