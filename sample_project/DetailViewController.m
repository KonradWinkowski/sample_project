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

@interface DetailViewController () <GitHubDataManagerDelegate>

@property (strong, nonatomic) GitHubDataManager *dataManager;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (!self.pullRequestItem) { return; }
    
    self.detailDescriptionLabel.text = self.pullRequestItem.title;
    
    [self.dataManager getCommitInfo:self.pullRequestItem.commitsURL];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataManager = [[GitHubDataManager alloc] init];
    self.dataManager.delegate = self;
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didDownloadLatestCommitsInformation:(NSArray *)commits {
    
}


@end
