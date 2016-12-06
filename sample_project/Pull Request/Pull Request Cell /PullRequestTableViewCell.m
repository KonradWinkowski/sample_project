//
//  PullRequestTableViewCell.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "PullRequestTableViewCell.h"
#import "PullRequestItem.h"

#import <ChameleonFramework/Chameleon.h>

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

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.titleLabel.text = @"";
    self.detailLabel.text = @"";
    
    self.statusIndicatorView.backgroundColor = [UIColor flatRedColor];
}

- (void)setupCellInfo {
    self.titleLabel.text = self.pullRequest.title;
    
    switch (self.pullRequest.state) {
        case Request_State_Open:
            self.statusIndicatorView.backgroundColor = [UIColor flatLimeColor];
            break;
        case Request_State_Closed:
        default:
            self.statusIndicatorView.backgroundColor = [UIColor flatRedColor];
            break;
    }
    
    [self generateDetailLabel];
}

- (void)generateDetailLabel {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSDate *createdDate = [dateFormatter dateFromString:self.pullRequest.created_date];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:createdDate toDate:[NSDate date] options:NSCalendarMatchFirst];
    
    NSMutableString *tempString = [NSMutableString new];
    
    [tempString appendString:[NSString stringWithFormat:@"#%d", self.pullRequest.itemNumber]];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    if (dayComponents.day < 10) {
        if (dayComponents.day == 1) {
            [tempString appendString:@" opened 1 day ago by "];
        } else {
            [tempString appendString:[NSString stringWithFormat:@" opened %d days ago by ", dayComponents.day]];
        }
    } else {
        [tempString appendString:[NSString stringWithFormat:@" opened on %@ by ", [dateFormatter stringFromDate:createdDate]]];
    }
    
    [tempString appendString:self.pullRequest.userName];
    
    self.detailLabel.text = tempString;
}

- (void)setPullRequest:(PullRequestItem *)pullRequest {
    _pullRequest = pullRequest;
    [self setupCellInfo];
}

@end
