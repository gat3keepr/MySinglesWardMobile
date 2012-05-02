//
//  BishopricData.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface BishopricData : NSManagedObject

@property (nonatomic, retain) NSString * wifeName;
@property (nonatomic, retain) NSString * wifePhone;
@property (nonatomic, retain) NSString * sortID;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) User *member;

@end
