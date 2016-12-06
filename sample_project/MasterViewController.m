//
//  MasterViewController.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PullRequestTableViewCell.h"
#import "GitHubDataManager.h"
#import <ChameleonFramework/Chameleon.h>

#define kCellReuseIdentifier @"pull_request_cell"

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource, GitHubDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) GitHubDataManager *dataManager;
@property (strong, nonatomic) NSArray *pullRequests;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.dataManager = [[GitHubDataManager alloc] init];
    self.dataManager.delegate = self;
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // adds a pull to refresh control for the "Pull Requests" table view
    self.refreshControl = [self addPullToRefreshControl];
    
    [self getDataFromGitHub];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPullRequests:(NSArray *)pullRequests {
    _pullRequests = pullRequests;
    
    if (self.detailViewController.pullRequestItem == nil) {
        self.detailViewController.pullRequestItem = _pullRequests.firstObject;
    }
}

#pragma mark - Data 

-(void)getDataFromGitHub {
        
    if (self.dataManager) {
        [self.dataManager updatePullRequests];
    }
    
}

#pragma mark - View 

/*
 * Creates the UIRefreshControl with a custom look and adds it to the table view.
 */
-(UIRefreshControl*)addPullToRefreshControl {
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control setBackgroundColor:[UIColor flatCoffeeColorDark]];
    [control setTintColor:[UIColor flatWhiteColor]];
    [control addTarget:self action:@selector(getDataFromGitHub) forControlEvents:UIControlEventValueChanged];
    
    NSString *title = @"Pull To Refresh";
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor flatWhiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    
    [control setAttributedTitle:attributedTitle];
    
    [self.tableView addSubview:control];
    
    return control;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pullRequests.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PullRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    cell.pullRequest = [self.pullRequests objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - GitHubDelegate 

- (void)didDownloadLatestPullRequests:(NSArray *)pullRequests {
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
    
    self.pullRequests = pullRequests;
    [self.tableView reloadData];
}

- (void)failedToGetLatestPullRequests {
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
    
}

@end

