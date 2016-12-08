//
//  GitHubDataManager.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "GitHubDataManager.h"
#import "PullRequestItem.h"
#import "FileItem.h"

#define kPullRequestsURL @"https://api.github.com/repos/magicalpanda/MagicalRecord/pulls?state=all"

@interface GitHubDataManager() <NSURLSessionDelegate>

@end

@implementation GitHubDataManager

#pragma mark - Data Ready / Failed

-(void)failedToGetData {
    if (self.delegate) {
        [self.delegate failedToGetLatestGitHubData];
    }
}

-(void)finishedReceivingPullRequestData:(NSArray*)data {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadLatestPullRequests:)]) {
        [self.delegate didDownloadLatestPullRequests:data];
    }
}

-(void)finishedReceivingFilesData:(NSArray*)data {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadLatestFilesInformation:)]) {
        [self.delegate didDownloadLatestFilesInformation:data];
    }
    
}

#pragma mark - Network Calls 

-(void)getPullRequests {
    
    NSAssert(self.delegate, @"A Delegate is Required for this object!");
    
    __weak typeof(self) weakself = self;
    
    [self performFetchRequestToURL:[NSURL URLWithString:kPullRequestsURL] withCompletion:^(BOOL result, NSData *data) {
        if (result) {
            [weakself parseArrayOfRawPullRequests:[weakself parseResponsData:data]];
        } else {
            [weakself failedToGetData];
        }
    }];
    
}

-(void)getFilesInfo:(NSURL*)filesURL {
    
    NSAssert(self.delegate, @"A Delegate is Required for this object!");
    
    __weak typeof(self) weakself = self;
    
    [self performFetchRequestToURL:filesURL withCompletion:^(BOOL result, NSData *data) {
        
        if (result) {
            [weakself parseArrayOfRawFiles:[weakself parseResponsData:data]];
        } else {
            [weakself failedToGetData];
        }
        
    }];
    
}

/*
 * Reusable fetch request call to go out and get the data from the provided URL. 
 * Will call the completion block (if it is there) with the reuslts and data.
 */
-(void)performFetchRequestToURL:(NSURL*)url withCompletion:(void (^)(BOOL result, NSData *data))completion {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error && completion) {
            completion(NO, nil);
        } else if (completion) {
            completion(YES, data);
        }
    }];
    
    [dataTask resume];
    
}

#pragma mark - Parsers

/*
 * Since we know that the values we are requesting always return a NSArray from the JSON data.
 * We can safely reutrn an array ( or nil ) from the json data.
 */
-(NSArray*)parseResponsData:(NSData*)data {
    
    NSError *error;
    NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [self failedToGetData];
        return nil;
    }
    
    return items;
}

/*
 * Files from the GitHub api is just an array of dictionarys that contain the data with the file changes. This is what we'll use to get the data to display the 
 * side by side view.
 */
-(void)parseArrayOfRawFiles:(NSArray*)items {
    
    if (!items) { return; }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *item in items) {
        [temp addObject:[FileItem itemWithData:item]];
    }
    
    [self finishedReceivingFilesData:[NSArray arrayWithArray:temp]];
    
}

/*
 * This is what we use to get the data to populate the avaiable "Pull Requests". The items feed in are just NSDictinarys that contain
 * the data that we need to get all of the info about the pull and to get the changed files with that pull request.
 */
-(void)parseArrayOfRawPullRequests:(NSArray*)items {
    
    if (!items) { return; }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *item in items) {
        [temp addObject:[PullRequestItem itemFromInfo:item]];
    }
    
    [self finishedReceivingPullRequestData:[NSArray arrayWithArray:temp]];
    
}

@end
