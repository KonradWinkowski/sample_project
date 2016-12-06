//
//  DetailViewController.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRequestItem;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) PullRequestItem *pullRequestItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

