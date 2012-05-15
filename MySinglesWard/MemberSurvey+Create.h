//
//  MemberSurvey+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberSurvey.h"

@interface MemberSurvey (Create)

+(MemberSurvey *) surveyWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context;
+(MemberSurvey *) surveyWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context;
-(NSDictionary *) toDictionary;
-(void) saveSurveyToServer;

@end
