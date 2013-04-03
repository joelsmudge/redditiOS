//
//  REDImageManager.h
//  Reddit
//
//  Created by Joel Harrison on 4/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REDImageManager : NSObject

+(REDImageManager *) sharedREDImageManager;

- (BOOL)isImageCached:(NSString *)name;
- (UIImage *)loadImage:(NSString *)name;
- (void)saveImage:(UIImage *)image withName:(NSString *)name;
- (UIImage*) getImage: (NSString*) url;


@end
