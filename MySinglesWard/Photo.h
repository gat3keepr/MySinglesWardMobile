//
//  Photo.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * newPhotoFileName;
@property (nonatomic, retain) User *member;

@end
