//
//  MemberSurvey.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface MemberSurvey : NSManagedObject

@property (nonatomic, retain) NSString * activities;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * callingPref;
@property (nonatomic, retain) NSString * emergContract;
@property (nonatomic, retain) NSString * emergPhone;
@property (nonatomic, retain) NSString * employed;
@property (nonatomic, retain) NSString * endowed;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * homeAddress;
@property (nonatomic, retain) NSString * homeBishop;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * homeWardStake;
@property (nonatomic, retain) NSString * interests;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSString * missionInformation;
@property (nonatomic, retain) NSNumber * musicSkill;
@property (nonatomic, retain) NSString * musicTalent;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * pastCallings;
@property (nonatomic, retain) NSString * patriarchalBlessings;
@property (nonatomic, retain) NSString * prevBishops;
@property (nonatomic, retain) NSString * priesthood;
@property (nonatomic, retain) NSNumber * publishCell;
@property (nonatomic, retain) NSNumber * publishEmail;
@property (nonatomic, retain) NSString * religionClass;
@property (nonatomic, retain) NSString * schoolInfo;
@property (nonatomic, retain) NSString * selfDescription;
@property (nonatomic, retain) NSNumber * teachDesire;
@property (nonatomic, retain) NSNumber * teachSkill;
@property (nonatomic, retain) NSString * templeExpDate;
@property (nonatomic, retain) NSString * templeRecommend;
@property (nonatomic, retain) NSString * templeWorker;
@property (nonatomic, retain) NSString * timeInWard;
@property (nonatomic, retain) User *member;

@end
