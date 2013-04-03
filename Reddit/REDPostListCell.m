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

    // Configure the view for the selected state
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
    
    [self performSelectorInBackground:@selector(loadThumbnail:) withObject:post.thumbnail];
    
}

- (void)loadThumbnail: (NSString*) thumbnailURL
{
    //NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailURL]];
    //UIImage *myimage = [[UIImage alloc] initWithData:mydata];
    [self.thumbnail setImage:[[REDImageManager sharedREDImageManager] getImage:thumbnailURL]];
}



@end
