//
//  REDPostListCell.m
//  Reddit
//
//  Created by Joel Harrison on 3/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDPostListCell.h"
#import "REDPost.h"


@implementation REDPostListCell

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //self.contentView.backgroundColor = UIColor.
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) prepareForReuse{
    [super prepareForReuse];
    _thumbnail.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (NSString *) reuseIdentifier {
    return @"PostCell";
}

- (void) setPost: (REDPost*) post
{
    
    // Set text for the cell labels
    [self.TitleLabel setText:post.title];
    [self.SubTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", post.author, post.domain]];
    [self.SubSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", post.score, post.ups, post.downs, post.numComments]];
    self.myPost = post;
    [self.myPost addObserver:self forKeyPath:@"likes" options:0 context:nil];
    
    // Check voting
    if(![post.likes isEqualToString:@"<null>"]){
        if([post.likes isEqualToString:@"0"]){
            self.background.backgroundColor = [UIColor colorWithRed:0.33 green:0.4 blue:0.5 alpha:1];
        } else {
            self.background.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.33 alpha:1];
        }
    } else {
        self.background.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
    }
    
    // Add loading indicator to thumbnail
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [self.thumbnail addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    // Get image for thumbnail
    [self performSelectorInBackground:@selector(loadThumbnail:) withObject:post.thumbnail];
    
}

//remove activity indicator while connection did finish loadin
-(void)imageDidFinishLoading
{
    [loadingIndicator stopAnimating];
    [loadingIndicator removeFromSuperview];
}

- (void)loadThumbnail: (NSString*) thumbnailURL
{
    [self.thumbnail setImage:[[REDImageManager sharedREDImageManager] getImage:thumbnailURL]];
    [self performSelectorOnMainThread:@selector(imageDidFinishLoading) withObject:nil waitUntilDone:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.myPost && [keyPath isEqualToString:@"likes"]) {
        NSLog(@"Observing Results is: %@", self.myPost.likes);
        if(![self.myPost.likes isEqualToString:@"<null>"]){
            if([self.myPost.likes isEqualToString:@"0"]){
                self.background.backgroundColor = [UIColor colorWithRed:0.33 green:0.4 blue:0.5 alpha:1];
            } else {
                self.background.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.33 alpha:1];
            }
        } else {
            self.background.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
        }
    }
}

@end
