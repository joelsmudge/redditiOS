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
    post.score = [NSString stringWithFormat:@"%@", [data objectForKey:@"score"]];
    post.over_18 = [data objectForKey:@"over_18"];
    post.downs = [NSString stringWithFormat:@"%@", [data objectForKey:@"downs"]];
    post.name = [data objectForKey:@"name"];
    post.created = [data objectForKey:@"created"];
    post.domain = [data objectForKey:@"domain"];
    post.url = [data objectForKey:@"url"];
    post.author = [data objectForKey:@"author"];
    post.thumbnail = [data objectForKey:@"thumbnail"];
    post.numComments = [NSString stringWithFormat:@"%@", [data objectForKey:@"num_comments"]];
    post.ups = [NSString stringWithFormat:@"%@", [data objectForKey:@"ups"]];
    
    return post;
        
}


@end
