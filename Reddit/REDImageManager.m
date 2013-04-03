//
//  REDImageManager.m
//  Reddit
//
//  Created by Joel Harrison on 4/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDImageManager.h"

@implementation REDImageManager

+(REDImageManager *) sharedREDImageManager{
    static REDImageManager *sharedREDImageManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedREDImageManager = [[REDImageManager alloc] init];
    });
    
    return sharedREDImageManager;
}

-(id) init{
    self = [super init];
    
    if (self) {
        
    } 
    
    return self;
}

- (UIImage*)getImage: (NSString*) url
{
    // Check cache for image
    if([self isImageCached:url]){
        NSLog(@"Image is Cached");
        return [self loadImage:url];
    }
    
    // If not there then download it and cache
    NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *myImage = [[UIImage alloc] initWithData:myData];
    [self saveImage:myImage withName:url];
    return myImage;
}



- (void)saveImage:(UIImage *)image withName:(NSString *)name {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[name stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

- (UIImage *)loadImage:(NSString *)name {
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[name stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
    return img;
}

- (BOOL)isImageCached:(NSString *)name {
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[name stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]];
}

@end
