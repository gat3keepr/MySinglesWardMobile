//
//  MemberSurvey+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberSurvey+Create.h"
#import "User+Create.h"

@implementation MemberSurvey (Create)

#define MEMBER_SURVEY @"MemberSurvey"

+(MemberSurvey *) surveyWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context
{
    MemberSurvey *survey = nil;
    
    //Get memberID from data
    NSNumber *memberID = [data objectForKey:@"memberID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:MEMBER_SURVEY];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *surveys = [context executeFetchRequest:request error:&error];
    
    if(!surveys || [surveys count] > 1)
    {
        
    }
    else if (![surveys count]) {
        survey = [NSEntityDescription insertNewObjectForEntityForName:MEMBER_SURVEY inManagedObjectContext:context];
        
        survey.activities = [data objectForKey:@"activities"];
        survey.birthday = [data objectForKey:@"birthday"];
        survey.callingPref = [data objectForKey:@"callingPref"];
        survey.selfDescription = [data objectForKey:@"description"];
        survey.emergContact = [data objectForKey:@"emergContact"];
        survey.emergPhone = [data objectForKey:@"emergPhone"];
        survey.employed = [data objectForKey:@"employed"];
        survey.endowed = [data objectForKey:@"endowed"];
        survey.gender = [data objectForKey:@"gender"];
        survey.homeAddress = [data objectForKey:@"homeAddress"];
        survey.homeBishop = [data objectForKey:@"homeBishop"];
        survey.homePhone = [data objectForKey:@"homePhone"];
        survey.homeWardStake = [data objectForKey:@"homeWardStake"];
        survey.interests = [data objectForKey:@"interests"];
        survey.major = [data objectForKey:@"major"];
        survey.memberID = memberID;
        
        if(![[data objectForKey:@"missionInformation"] isKindOfClass:[NSNull class]])
            survey.missionInformation = [data objectForKey:@"missionInformation"];
        
        survey.musicSkill = [NSNumber numberWithInt:[[data objectForKey:@"musicSkill"] intValue]];
        survey.musicTalent = [data objectForKey:@"musicTalent"];
        survey.occupation = [data objectForKey:@"occupation"];
        survey.pastCallings = [data objectForKey:@"pastCallings"];
        survey.patriarchalBlessings = [data objectForKey:@"patriarchalBlessing"];
        survey.prevBishops = [data objectForKey:@"prevBishops"];
        survey.priesthood = [data objectForKey:@"priesthood"];
        survey.publishCell = [data objectForKey:@"publishCell"];
        survey.publishEmail = [data objectForKey:@"publishEmail"];
        survey.religionClass = [data objectForKey:@"religionClass"];
        survey.schoolInfo = [data objectForKey:@"schoolInfo"];
        survey.teachDesire = [NSNumber numberWithInt:[[data objectForKey:@"teachDesire"] intValue]];
        survey.teachSkill = [NSNumber numberWithInt:[[data objectForKey:@"teachSkill"] intValue]];
        survey.templeExpDate = [data objectForKey:@"templeExpDate"];
        survey.templeRecommend = [data objectForKey:@"templeRecommend"];
        survey.templeWorker = [data objectForKey:@"templeWorker"];
        survey.timeInWard = [data objectForKey:@"timeInWard"];
        
        survey.member = [User userWithID:memberID inManagedObjectContext:context];
    }
    else 
    {
        survey = [surveys lastObject];
        
        survey.activities = [data objectForKey:@"activities"];
        survey.birthday = [data objectForKey:@"birthday"];
        survey.callingPref = [data objectForKey:@"callingPref"];
        survey.selfDescription = [data objectForKey:@"description"];
        survey.emergContact = [data objectForKey:@"emergContact"];
        survey.emergPhone = [data objectForKey:@"emergPhone"];
        survey.employed = [data objectForKey:@"employed"];
        survey.endowed = [data objectForKey:@"endowed"];
        survey.gender = [data objectForKey:@"gender"];
        survey.homeAddress = [data objectForKey:@"homeAddress"];
        survey.homeBishop = [data objectForKey:@"homeBishop"];
        survey.homePhone = [data objectForKey:@"homePhone"];
        survey.homeWardStake = [data objectForKey:@"homeWardStake"];
        survey.interests = [data objectForKey:@"interests"];
        survey.major = [data objectForKey:@"major"];
        survey.memberID = memberID;
        
        if(![[data objectForKey:@"missionInformation"] isKindOfClass:[NSNull class]])
            survey.missionInformation = [data objectForKey:@"missionInformation"];
        
        survey.musicSkill = [NSNumber numberWithInt:[[data objectForKey:@"musicSkill"] intValue]];
        survey.musicTalent = [data objectForKey:@"musicTalent"];
        survey.occupation = [data objectForKey:@"occupation"];
        survey.pastCallings = [data objectForKey:@"pastCallings"];
        survey.patriarchalBlessings = [data objectForKey:@"patriarchalBlessing"];
        survey.prevBishops = [data objectForKey:@"prevBishops"];
        survey.priesthood = [data objectForKey:@"priesthood"];
        survey.publishCell = [data objectForKey:@"publishCell"];
        survey.publishEmail = [data objectForKey:@"publishEmail"];
        survey.religionClass = [data objectForKey:@"religionClass"];
        survey.schoolInfo = [data objectForKey:@"schoolInfo"];
        survey.teachDesire = [NSNumber numberWithInt:[[data objectForKey:@"teachDesire"] intValue]];
        survey.teachSkill = [NSNumber numberWithInt:[[data objectForKey:@"teachSkill"] intValue]];
        survey.templeExpDate = [data objectForKey:@"templeExpDate"];
        survey.templeRecommend = [data objectForKey:@"templeRecommend"];
        survey.templeWorker = [data objectForKey:@"templeWorker"];
        survey.timeInWard = [data objectForKey:@"timeInWard"];
        
        survey.member = [User userWithID:memberID inManagedObjectContext:context];
    }
    
    return survey;
}

+(MemberSurvey *) surveyWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context
{
    MemberSurvey *survey = nil;
    
    //Get memberID from data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:MEMBER_SURVEY];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *surveys = [context executeFetchRequest:request error:&error];
    
    if(!surveys || [surveys count] > 1)
    {
        
    }
    else 
    {
        survey = [surveys lastObject];
    }
    
    return survey;
}


@end
