//
//  FileChangesHeaderTableViewCell.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileChangesHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileChangesLabel;

@end
