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
#import "FileItem.h"
#import "FileChangesTableViewCell.h"
#import "FileChangesHeaderTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>

#define kFileChangesCellIdentifier @"file_changes_cell"
#define kFileChangesHeaderIdentifier @"header_cell"

#define kEstimatedCellHeight 44
#define kHeaderCellHeight 68

@interface DetailViewController () <GitHubDataManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) GitHubDataManager *dataManager;

@property (weak, nonatomic) IBOutlet UIView *workingContainer;
@property (weak, nonatomic) IBOutlet UIView *workingHolder;
@property (weak, nonatomic) IBOutlet UIView *workingShadow;
@property (weak, nonatomic) IBOutlet UILabel *workingLabel;
@property (weak, nonatomic) IBOutlet WorkingSpinner *workingSpinner;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIColor *clearColor;
@property (strong, nonatomic) UIColor *additionsColor;
@property (strong, nonatomic) UIColor *deletionsColor;

@property (strong, nonatomic) NSArray *commits;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    
    self.dataManager = [[GitHubDataManager alloc] init];
    self.dataManager.delegate = self;
    
    self.workingShadow.layer.cornerRadius = 4.0;
    self.workingHolder.layer.cornerRadius = 4.0;
    
    self.clearColor = [UIColor clearColor];
    self.additionsColor = [[UIColor flatLimeColor] colorWithAlphaComponent:0.45];
    self.deletionsColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.45];
    
    [self configureView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedCellHeight;
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
    self.commits = commits;
    [self.tableView reloadData];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kEstimatedCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commits.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FileItem *item = [self.commits objectAtIndex:section];
    return item.origianStrings.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FileChangesHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileChangesHeaderIdentifier];

    FileItem *item = [self.commits objectAtIndex:section];
    
    cell.fileNameLabel.text = item.fileName;
    cell.fileChangesLabel.text = item.changesInfo;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileChangesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileChangesCellIdentifier forIndexPath:indexPath];
    
    FileItem *item = [self.commits objectAtIndex:indexPath.section];
    
    NSString *originalText = [item.origianStrings objectAtIndex:indexPath.row];
    NSString *changedText = [item.changedStrings objectAtIndex:indexPath.row];
    
    if ([originalText isEqualToString:KEMPTYSPACESTRING]) {
        cell.originalLabel.text = @" ";
    } else {
        cell.originalLabel.text = originalText;
    }
    
    if ([changedText isEqualToString:KEMPTYSPACESTRING]) {
        cell.changedLabel.text = @" ";
    } else {
        cell.changedLabel.text = changedText;
    }
    
    cell.originalLineNumberLabel.text = [item.originalStartingLineStrings objectAtIndex:indexPath.row];
    cell.changedLineNumberLabel.text = [item.changedStartingLineStrings objectAtIndex:indexPath.row];
    
    return cell;
}

@end
