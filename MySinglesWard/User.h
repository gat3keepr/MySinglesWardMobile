//
//  User.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MemberSurvey, NotificationPreference, Photo, Ward;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * wardID;
@property (nonatomic, retain) NSNumber * isBishopric;
@property (nonatomic, retain) MemberSurvey *survey;
@property (nonatomic, retain) Ward *ward;
@property (nonatomic, retain) NotificationPreference *notificationPreference;
@property (nonatomic, retain) Photo *photo;

@end
