//
//  User.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BishopricData, Calling, MemberSurvey, NotificationPreference, Photo, Ward;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * cellphone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSNumber * isBishopric;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSString * prefname;
@property (nonatomic, retain) NSString * residence;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * wardID;
@property (nonatomic, retain) Calling *calling;
@property (nonatomic, retain) NotificationPreference *notificationPreference;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) MemberSurvey *survey;
@property (nonatomic, retain) Ward *ward;
@property (nonatomic, retain) BishopricData *bishopricData;

@end
