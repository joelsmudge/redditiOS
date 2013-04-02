//
//  REDPost.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDPost.h"

@implementation REDPost

+ initCreatePostFromJson: (NSDictionary*) json
{
    REDPost* post = [[REDPost alloc] init];
    NSDictionary* data = [json objectForKey:@"data"];
    post.title = [data objectForKey:@"title"];
    post.postid = [data objectForKey:@"id"];
    post.score = [data objectForKey:@"score"];
    post.over_18 = [data objectForKey:@"over_18"];
    post.downs = [data objectForKey:@"downs"];
    post.name = [data objectForKey:@"name"];
    post.created = [data objectForKey:@"created"];
    post.url = [data objectForKey:@"url"];
    post.author = [data objectForKey:@"author"];
    post.numComments = [data objectForKey:@"numComments"];
    post.ups = [data objectForKey:@"ups"];

    NSLog([NSString stringWithFormat:@"The Post Title is %@", post.title]);
    
    return post;
        
}


@end
