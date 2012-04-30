//
//  JSONRequest.m
//  MyStuff
//
//  Created by Porter Hoskins on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONRequest.h"

@implementation JSONRequest

+(NSDictionary*)makeWebRequestWithURL:(NSURL*)url
{    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSError *errorReturned = nil;
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorReturned];    

    if(errorReturned)
    {
        //Check to see if there was an error
        NSLog(@"%@",[errorReturned localizedDescription]);
    }
    
    NSError *jsonError = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
}

@end