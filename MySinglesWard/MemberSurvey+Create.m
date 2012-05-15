//
//  MemberSurvey+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberSurvey+Create.h"
#import "User+Create.h"
#import "MSWRequest.h"
#import "JSONRequest.h"

@implementation MemberSurvey (Create)

#define MEMBER_SURVEY @"MemberSurvey"

+(MemberSurvey *) surveyWithJSON:(NSDictionary *) data
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    MemberSurvey *survey = nil;
    NSMutableDictionary *surveyData = [[NSMutableDictionary alloc] initWithDictionary:data];
    //Get memberID from data
    NSNumber *memberID = [surveyData objectForKey:@"memberID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:MEMBER_SURVEY];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *surveys = [context executeFetchRequest:request error:&error];
    
    if(!surveys || [surveys count] > 1)
    {
        
    }
    else if (![surveys count]) {
        survey = [NSEntityDescription insertNewObjectForEntityForName:MEMBER_SURVEY inManagedObjectContext:context];
    }
    else 
    {
        survey = [surveys lastObject];
    }
    
    if(survey)
    {
        for (NSString * value in [surveyData allKeys]) {
            if([[surveyData objectForKey:value] isKindOfClass:[NSNull class]])
                [surveyData setValue:nil forKey:value];
        }
        
        survey.activities = [surveyData objectForKey:@"activities"];
        survey.birthday = [surveyData objectForKey:@"birthday"];
        survey.callingPref = [surveyData objectForKey:@"callingPref"];
        survey.selfDescription = [surveyData objectForKey:@"description"];
        survey.emergContact = [surveyData objectForKey:@"emergContact"];
        survey.emergPhone = [surveyData objectForKey:@"emergPhone"];
        survey.employed = [surveyData objectForKey:@"employed"];
        survey.endowed = [surveyData objectForKey:@"endowed"];
        survey.gender = [surveyData objectForKey:@"gender"];
        survey.homeAddress = [surveyData objectForKey:@"homeAddress"];
        survey.homeBishop = [surveyData objectForKey:@"homeBishop"];
        survey.homePhone = [surveyData objectForKey:@"homePhone"];
        survey.homeWardStake = [surveyData objectForKey:@"homeWardStake"];
        survey.interests = [surveyData objectForKey:@"interests"];
        survey.major = [surveyData objectForKey:@"major"];
        survey.memberID = memberID;
        
        if(![[surveyData objectForKey:@"missionInformation"] isKindOfClass:[NSNull class]])
            survey.missionInformation = [surveyData objectForKey:@"missionInformation"];
        if(![[surveyData objectForKey:@"planMission"] isKindOfClass:[NSNull class]])
            survey.planMission = [surveyData objectForKey:@"planMission"];
        if(![[surveyData objectForKey:@"planMissionTime"] isKindOfClass:[NSNull class]])
            survey.planMissionTime = [surveyData objectForKey:@"planMissionTime"];
        if(![[surveyData objectForKey:@"mission"] isKindOfClass:[NSNull class]])
            survey.mission = [surveyData objectForKey:@"mission"];
        if(![[surveyData objectForKey:@"missionLocation"] isKindOfClass:[NSNull class]])
            survey.missionLocation = [surveyData objectForKey:@"missionLocation"];
        
        survey.musicSkill = [NSNumber numberWithInt:[[surveyData objectForKey:@"musicSkill"] intValue]];
        survey.musicTalent = [surveyData objectForKey:@"musicTalent"];
        survey.occupation = [surveyData objectForKey:@"occupation"];
        survey.pastCallings = [surveyData objectForKey:@"pastCallings"];
        survey.patriarchalBlessing = [surveyData objectForKey:@"patriarchalBlessing"];
        survey.prevBishops = [surveyData objectForKey:@"prevBishops"];
        survey.priesthood = [surveyData objectForKey:@"priesthood"];
        survey.publishCell = [surveyData objectForKey:@"publishCell"];
        survey.publishEmail = [surveyData objectForKey:@"publishEmail"];
        survey.religionClass = [surveyData objectForKey:@"religionClass"];
        survey.schoolInfo = [surveyData objectForKey:@"schoolInfo"];
        survey.teachDesire = [NSNumber numberWithInt:[[surveyData objectForKey:@"teachDesire"] intValue]];
        survey.teachSkill = [NSNumber numberWithInt:[[surveyData objectForKey:@"teachSkill"] intValue]];
        survey.templeExpDate = [surveyData objectForKey:@"templeExpDate"];
        survey.templeRecommend = [surveyData objectForKey:@"templeRecommend"];
        survey.templeWorker = [surveyData objectForKey:@"templeWorker"];
        survey.timeInWard = [surveyData objectForKey:@"timeInWard"];
        survey.enrolledSchool = [surveyData objectForKey:@"enrolledSchool"];
        survey.major = [surveyData objectForKey:@"major"];
        survey.school = [surveyData objectForKey:@"school"];
        survey.status = [surveyData objectForKey:@"status"];
        
        survey.member = [User userWithID:memberID inManagedObjectContext:context];
        
        survey.member.prefname = [surveyData objectForKey:@"prefName"];
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

-(NSDictionary *) toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self dictionaryWithValuesForKeys:[[[self entity] attributesByName] allKeys]]];
    
    //Get other fields from core data model
    [dictionary setObject:self.member.prefname forKey:@"prefName"];
    [dictionary setObject:self.member.cellphone forKey:@"cellPhone"];
    [dictionary setObject:self.member.residence forKey:@"residence"];
    
    if(self.selfDescription)
        [dictionary setObject:self.selfDescription forKey:@"description"];
    
    return [dictionary copy];
}

-(void) saveSurveyToServer
{
    //Create the URL for the web request to save the survey
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/savesurvey", MSWRequestURL];
    NSLog(@"SAVE SURVEY DATA URL request: %@", url);
    
    //get a dictionary of all the field
    NSError *error = nil;
    NSLog(@"SAVE SURVEY DATA: %@", [self toDictionary]);
    
    [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:[self toDictionary]  forKey:@"survey"] options:NSJSONWritingPrettyPrinted error:&error]];
}

@end
