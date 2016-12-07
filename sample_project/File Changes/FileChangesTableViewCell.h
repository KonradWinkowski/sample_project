//
//  FileChangesTableViewCell.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface FileChangesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CustomLabel *originalLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLineNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *changedLineNumberLabel;
@property (weak, nonatomic) IBOutlet CustomLabel *changedLabel;

@end
