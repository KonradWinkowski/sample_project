//
//  PullRequestTableViewCell.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "PullRequestTableViewCell.h"

#define kCornerRadius 4.0

@implementation PullRequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shadowView.layer.cornerRadius = kCornerRadius;
    self.containerView.layer.cornerRadius = kCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
