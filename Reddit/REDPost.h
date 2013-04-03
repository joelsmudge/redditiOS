//
//  REDPost.h
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REDPost : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* postid;
@property (strong, nonatomic) NSString* score;
@property (strong, nonatomic) NSString* over_18;
@property (strong, nonatomic) NSString* downs;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSNumber* created;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* domain;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* numComments;
@property (strong, nonatomic) NSString* thumbnail;
@property (strong, nonatomic) NSString* ups;
+ initCreatePostFromJson: (NSDictionary*) json;

@end
