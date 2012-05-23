//
//  JSONRequest.h
//  MyStuff
//
//  Created by Porter Hoskins on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONRequest : NSObject

#define MSWRequestURL @"https://www.mysinglesward.com/"
#define MSWPhotoURL @"https://www.mysinglesward.com/Photo/"
#define LOGGED_IN @"LOGGED_IN"
#define NEEDS_NOTHING @"NEEDS_NOTHING"
#define NEEDS_PHOTO @"NEEDS_PHOTO"
#define NEEDS_SURVEY @"NEEDS_SURVEY"
#define UNAUTHORIZED @"UNAUTHORIZED"
#define DATA_LOADED @"DATA_LOADED"
#define MEMBER_STATUS @"MEMBER_STATUS"
#define REGISTRATION @"REGISTRATION"
#define REGISTRATION_STEP @"REGISTRATION_STEP"
#define WARD @"WARD"
#define SURVEY @"SURVEY"
#define DONE @"DONE"
#define MEMBERID @"memberID"
#define NO_WARD 0
#define BACKGROUND_IMAGE @"app_bg.png"
#define ISBISHOPRIC @"ISBISHOPRIC"

+(NSDictionary*)makeWebRequestWithURL:(NSString *)url withJSONData:(NSData *)jsonData;

+(NSDictionary *)requestForBishopricData;
+(NSDictionary *)requestForWardListData;
+(NSDictionary *)requestForMemberData;
+(void)requestForMemberStatus;

@end
