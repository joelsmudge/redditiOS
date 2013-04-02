//
//  REDPostListCell.h
//  Reddit
//
//  Created by Joel Harrison on 3/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDPostListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubSubTitleLabel;

@end
