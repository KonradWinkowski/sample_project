//
//  FileChangesTableViewCell.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

/*
 * Simple Cell that sets up each of the "split view" lines with the line numbrs and text for that line. 
 */

@interface FileChangesTableViewCell : UITableViewCell

// 'Original Side' //
@property (weak, nonatomic) IBOutlet CustomLabel *originalLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLineNumberLabel;

// 'Changed Side' // 
@property (weak, nonatomic) IBOutlet UILabel *changedLineNumberLabel;
@property (weak, nonatomic) IBOutlet CustomLabel *changedLabel;

@end
