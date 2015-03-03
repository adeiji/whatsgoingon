//
//  Constants.m
//  whatsgoinon
//
//  Created by adeiji on 8/12/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "Constants.h"

// Parse - Event Class

NSString *const PARSE_CLASS_NAME_EVENT = @"Event";
NSString *const PARSE_CLASS_EVENT_ACTIVE = @"active";
NSString *const PARSE_CLASS_EVENT_TITLE = @"name";
NSString *const PARSE_CLASS_EVENT_ADDRESS = @"address";
NSString *const PARSE_CLASS_EVENT_DESCRIPTION = @"description";
NSString *const PARSE_CLASS_EVENT_START_TIME = @"starttime";
NSString *const PARSE_CLASS_EVENT_END_TIME = @"endtime";
NSString *const PARSE_CLASS_EVENT_COST = @"cost";
NSString *const PARSE_CLASS_EVENT_CATEGORY = @"category";
NSString *const PARSE_CLASS_EVENT_POST_RANGE = @"postrange";
NSString *const PARSE_CLASS_EVENT_USER = @"user";
NSString *const PARSE_CLASS_EVENT_LOCATION = @"location";
NSString *const PARSE_CLASS_EVENT_IMAGES = @"images";
NSString *const PARSE_CLASS_EVENT_OBJECT_ID = @"objectId";
NSString *const PARSE_CLASS_EVENT_COMMENTS = @"comments";
NSString *const PARSE_CLASS_EVENT_RATING = @"rating";
NSString *const PARSE_CLASS_EVENT_QUICK_DESCRIPTION = @"quickDescription";
NSString *const PARSE_CLASS_NAME_REPORT = @"Report";
NSString *const PARSE_CLASS_EVENT_NUMBER_GOING = @"numberGoing";
NSString *const PARSE_CLASS_EVENT_USERNAME = @"username";
NSString *const PARSE_CLASS_EVENT_VIEW_COUNT = @"viewCount";
NSString *const PARSE_CLASS_EVENT_THUMBS_UP_COUNT = @"thumbsUpCount";
NSString *const PARSE_CLASS_EVENT_STATUS = @"Status";
NSString *const PARSE_CLASS_EVENT_STATUS_POSTED = @"posted";

NSString *const LOCATION_LATITUDE = @"latitude";
NSString *const LOCATION_LONGITUDE = @"longitude";

// Parse - Report

NSString *const REPORT_VULGAR_OR_ABUSIVE_LANGUAGE = @"Vulgar or Abusive Language";
NSString *const REPORT_CRUDE_CONTENT = @"Crude Content";
NSString *const REPORT_NOT_REAL_POST = @"Not a Real Post";
NSString *const REPORT_POST_NOT_APPROPRIATE = @"Post is Simply Not Appropriate";
NSString *const PARSE_CLASS_REPORT_WHATS_WRONG = @"whatswrong";
NSString *const PARSE_CLASS_REPORT_OTHER = @"other";
NSString *const PARSE_CLASS_REPORT_EVENT_ID = @"eventid";

// Parse - Miscategorized

NSString *const PARSE_CLASS_NAME_MISCATEGORIZED_EVENT = @"MiscategorizedEvent";
NSString *const PARSE_CLASS_MISCATEGORIZED_EVENT_CATEGORY = @"category";
NSString *const PARSE_CLASS_MISCATEGORIZED_EVENT_ID = @"eventId";

// Parse - Comment

NSString *const PARSE_CLASS_NAME_COMMENT = @"Comment";
NSString *const PARSE_CLASS_COMMENT_COMMENT = @"comment";
NSString *const PARSE_CLASS_COMMENT_USER = @"user";
NSString *const PARSE_CLASS_COMMENT_THUMBS_UP = @"thumbs_up";
NSString *const PARSE_CLASS_COMMENT_EVENT_ID = @"event_id";

// Parse - User

NSString *const PARSE_CLASS_NAME_USER = @"UserDetails";
NSString *const PARSE_CLASS_USER_USERNAME = @"username";
NSString *const PARSE_CLASS_USER_EMAIL = @"email";
NSString *const PARSE_CLASS_USER_PASSWORD = @"password";
NSString *const PARSE_CLASS_USER_VISIBLE_PASSWORD = @"visiblePassword";
NSString *const PARSE_CLASS_USER_EMAIL_VERIFIED = @"emailVerified";
NSString *const PARSE_CLASS_USER_PROFILE_PICTURE = @"profilePicture";
NSString *const PARSE_CLASS_USER_EVENTS_GOING = @"eventsGoing";
NSString *const PARSE_CLASS_USER_EVENTS_MAYBE = @"eventsMaybe";
NSString *const PARSE_CLASS_USER_POST_COUNT = @"postCount";
NSString *const PARSE_CLASS_USER_RANK = @"rank";
NSString *const PARSE_CLASS_USER_CREATED_AT = @"createdAt";

// Geocoding

NSString *const PLACES_API_DATA_RESULT_TYPE_CITIES = @"(cities)";
NSString *const PLACES_API_DATA_RESULT_TYPE_GEOCODE = @"geocode";
NSString *const PLACES_API_NO_RESULTS = @"ZERO_RESULTS";

// Orb Button

NSString *const ORB_BUTTON_VIEW = @"orbButtonView";

// Notifications

CGFloat const BUTTON_CORNER_RADIUS = 6.0f;

NSString *const NOTIFICATION_CENTER_ALL_EVENTS_LOADED = @"com.happsnap.allEventsLoaded";
NSString *const NOTIFICATION_CENTER_ALL_NO_EVENTS_POSTED_BY_USER = @"com.happsnap.noeventspostedbyuser";
NSString *const NOTIFICATION_CENTER_USERS_EVENTS_LOADED = @"com.happsnap.userseventsloaded";
NSString *const NOTIFICATION_CENTER_PAST_EPIC_EVENTS_LOADED = @"com.happsnap.pastEpicEventsLoaded";
NSString *const NOTIFICATION_CENTER_CITY_CHANGED = @"com.happsnap.cityChanged";
NSString *const NOTIFICATION_CENTER_NO_DATA = @"com.happsnap.noData";
NSString *const NOTIFICATION_CENTER_NONE_IN_CATEGORY = @"com.happsnap.noneInCategory";
NSString *const NOTIFICATION_CENTER_ALL_COMMENTS_LOADED = @"com.happsnap.allCommentsLoaded";
NSString *const NOTIFICATION_CENTER_POST_FROM_USER_RETRIEVED = @"com.happsnap.postFromUserRetrieved";
NSString *const NOTIFICATION_CENTER_USER_RANK_RETRIEVED = @"com.happsnap.retrievedUserRank";
NSString *const NOTIFICATION_CENTER_USER_RETRIEVED = @"com.happsnap.retrievedUsername";
NSString *const NOTIFICATION_CENTER_NO_SAVED_EVENTS = @"com.happsnap.no.saved.events";
NSString *const NOTIFICATION_CENTER_SAVED_EVENTS_LOADED = @"com.happsnap.saved.events.loaded";
NSString *const NOTIFICATION_CENTER_LOAD_USER_EVENTS = @"com.happsnap.load.user.events";


// Notification Constants
NSString *const kNOTIFICATION_CENTER_USER_INFO_CATEGORY = @"category";
NSString *const kNOTIFICATION_CENTER_USER_RANK_RETRIEVED = @"retrievedUserRank";
NSString *const kNOTIFICATION_CENTER_USER_RANK_OBJECT_INFO = @"userRankObjectInfo";
NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_EVENTS_COUNT = @"eventCount";
NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS = @"com.happsnap.process";
NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_STILL_LOADING = @"com.happsnap.stillloading";
NSString *const kNOTIFICATION_CENTER_IS_CITY_CHANGE = @"com.happsnap.citychange";
NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING = @"com.happsnap.finishedLoading";
NSString *const NOTIFICATION_CENTER_ORB_CLICKED = @"com.happsnap.orbclicked";
NSString *const kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW = @"com.happsnap.new";
NSString *const kNOTIFICATION_CENTER_USER_INFO_IS_EPIC_EVENTS = @"com.happsnap.isEpicEvents";
NSString *const kNOTIFICATION_CENTER_EVENT_USER_AT = @"com.happsnap.event.user.at";
NSString *const kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE = @"com.happsnap.local.notification.future";
NSString *const NOTIFICATION_CENTER_USER_INFO_POSOTED_BY_ME = @"Posted By Me";

// View Controllers

NSString *const PROMPT_LOGIN_VIEW_CONTROLLER = @"promptLogin";
NSString *const LOGIN_ADD_PROFILE_IMAGE_VIEW_CONTROLLER = @"addProfileImageViewControler";

// NSUserDefaults
NSString *const NSUSER_DEFAULTS_PROFILE_PICTURE = @"profile-picture";

// User Ranks
NSString *const USER_RANK_AMBASSADOR = @"ambassador";
NSString *const USER_RANK_ADMIN = @"admin";
NSString *const USER_RANK_STANDARD = @"standard";

// Categories
NSString *const CATEGORY_TRENDING = @"Trending";

// Parse Image Dimensions Constants
NSString *const IMAGE_DIMENSION_WIDTH = @"width";
NSString *const IMAGE_DIMENSION_HEIGHT = @"height";

// Parse Local Datastore
NSString *const kGOING_POST_LOCAL_DATASTORE = @"com.happsnap.goingPostsInLocalDatastore";

