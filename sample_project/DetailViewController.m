//
//  DetailViewController.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "DetailViewController.h"
#import "PullRequestItem.h"
#import "GitHubDataManager.h"
#import "WorkingSpinner.h"

@interface DetailViewController () <GitHubDataManagerDelegate>

@property (strong, nonatomic) GitHubDataManager *dataManager;

@property (weak, nonatomic) IBOutlet UIView *workingContainer;
@property (weak, nonatomic) IBOutlet UIView *workingHolder;
@property (weak, nonatomic) IBOutlet UIView *workingShadow;
@property (weak, nonatomic) IBOutlet UILabel *workingLabel;
@property (weak, nonatomic) IBOutlet WorkingSpinner *workingSpinner;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataManager = [[GitHubDataManager alloc] init];
    self.dataManager.delegate = self;
    
    self.workingShadow.layer.cornerRadius = 4.0;
    self.workingHolder.layer.cornerRadius = 4.0;
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (!self.pullRequestItem) { return; }
    
    [self showWorkingPopoverWithTitle:@"Getting Commit Info..."];
    
    self.detailDescriptionLabel.text = self.pullRequestItem.title;
    
    [self.dataManager getFilesInfo:self.pullRequestItem.filesURL];
}

-(void)showWorkingPopoverWithTitle:(NSString*)text {
    
    self.workingLabel.text = text;
    
    if (self.workingContainer.hidden) {
        self.workingContainer.hidden = NO;
        self.workingSpinner.hidden = NO;
    }
    
}

-(void)hideWorkingPopover {
    self.workingContainer.hidden = YES;
    self.workingSpinner.hidden = YES;
}

#pragma mark - Managing the detail item

- (void)setPullRequestItem:(PullRequestItem *)pullRequestItem {
    if (_pullRequestItem != pullRequestItem) {
        _pullRequestItem = pullRequestItem;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - Git Hub Data Manager 

- (void)failedToGetLatestPullRequests {
    
}

- (void)didDownloadLatestFilesInformation:(NSArray *)commits {
    NSLog(@"%@", commits);
    [self hideWorkingPopover];
}


@end
