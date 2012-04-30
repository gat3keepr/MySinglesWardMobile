//
//  JSONRequest.h
//  MyStuff
//
//  Created by Porter Hoskins on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONRequest : NSObject

+(NSDictionary*)makeWebRequestWithURL:(NSString *)url withJSONData:(NSData *)jsonData;

@end
