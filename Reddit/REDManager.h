//
//  REDManager.h
//  Reddit
//
//  Created by Joel Harrison on 3/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface REDManager : NSObject

+(REDManager *) sharedREDManager;

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* modhash;
@property (strong, nonatomic) NSString* redditCookie;

-(BOOL)reachable;
-(BOOL) checkReachableWithMessage;
-(BOOL) login:(NSString*)username pass:(NSString*) password;
@end
