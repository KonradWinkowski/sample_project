//
//  PullRequestTableViewCell.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "PullRequestTableViewCell.h"
#import "PullRequestItem.h"

#define kCornerRadius 4.0

@implementation PullRequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shadowView.layer.cornerRadius = kCornerRadius;
    self.containerView.layer.cornerRadius = kCornerRadius;
    
    self.statusIndicatorView.layer.cornerRadius = self.statusIndicatorView.frame.size.width / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:.478 green:.373 blue:.286 alpha:1.0];
    } else {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)prepareForReuse {
    self.titleLabel.text = @"";
    self.detailLabel.text = @"";
    
    self.statusIndicatorView.backgroundColor = [UIColor colorWithRed:.675 green:.157 blue:.110 alpha:1.0];
}

- (void)setupCellInfo {
    self.titleLabel.text = self.pullRequest.title;
    
    switch (self.pullRequest.state) {
        case Request_State_Open:
            self.statusIndicatorView.backgroundColor = [UIColor colorWithRed:.596 green:.749 blue:0.0 alpha:1.0];
            break;
        case Request_State_Closed:
        default:
            self.statusIndicatorView.backgroundColor = [UIColor colorWithRed:.675 green:.157 blue:.110 alpha:1.0];
            break;
    }
    
    [self generateDetailLabel];
}

- (void)generateDetailLabel {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSDate *createdDate = [dateFormatter dateFromString:self.pullRequest.created_date];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:createdDate toDate:[NSDate date] options:NSCalendarMatchFirst];
    
    NSMutableString *tempString = [NSMutableString new];
    
    [tempString appendString:[NSString stringWithFormat:@"#%d", self.pullRequest.itemNumber]];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    if (dayComponents.day == 1) {
        [tempString appendString:@" opened 1 day ago by "];
    } else {
        [tempString appendString:[NSString stringWithFormat:@" opened %d days ago by ", dayComponents.day]];
    }
    
    [tempString appendString:self.pullRequest.userName];
    
    self.detailLabel.text = tempString;
}

- (void)setPullRequest:(PullRequestItem *)pullRequest {
    _pullRequest = pullRequest;
    [self setupCellInfo];
}

@end
