//
//  GitHubDataManager.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "GitHubDataManager.h"
#import "PullRequestItem.h"
#import "Commit.h"

#define kPullRequestsURL @"https://api.github.com/repos/magicalpanda/MagicalRecord/pulls"

@interface GitHubDataManager() <NSURLSessionDelegate>

@end

@implementation GitHubDataManager

+(GitHubDataManager*)manager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GitHubDataManager alloc] init];
    });
    return instance;
}

-(void)failedToGetData {
    if (self.delegate) {
        [self.delegate failedToGetLatestPullRequests];
    }
}

-(void)finishedReceivingPullRequestData:(NSArray*)data {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadLatestPullRequests:)]) {
        [self.delegate didDownloadLatestPullRequests:data];
    }
}

-(void)finishedReceivingCommitInformation:(NSArray*)data {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDownloadLatestCommitsInformation:)]) {
        [self.delegate didDownloadLatestCommitsInformation:data];
    }
}

-(void)getCommitInfo:(NSURL*)commitURL {
    
    NSAssert(self.delegate, @"A Delegate is Required for this object!");
    
    __weak typeof(self) weakself = self;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:commitURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"%@", response);
        if (error) {
            [weakself failedToGetData];
        } else {
            [weakself parseArrayOfRawCommits:[weakself parseResponsData:data]];
        }
    }];
    
    [dataTask resume];
    
}

-(void)updatePullRequests {
    
    NSAssert(self.delegate, @"A Delegate is Required for this object!");
    
    [self downloadPullRequests];
}

-(void)downloadPullRequests {
 
    __weak typeof(self) weakself = self;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:[NSURL URLWithString:kPullRequestsURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"%@", response);
        if (error) {
            [weakself failedToGetData];
        } else {
            [weakself parseArrayOfRawItems:[weakself parseResponsData:data]];
        }
    }];
    
    [dataTask resume];
    
}

-(NSArray*)parseResponsData:(NSData*)data {
    
    NSError *error;
    NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [self failedToGetData];
        return nil;
    }
    
    return items;
}

-(void)parseArrayOfRawCommits:(NSArray*)items {
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *item in items) {
        [temp addObject:[Commit commitFromData:item]];
    }
    
    [self finishedReceivingCommitInformation:[NSArray arrayWithArray:temp]];
    
}

-(void)parseArrayOfRawItems:(NSArray*)items {
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *item in items) {
        [temp addObject:[PullRequestItem itemFromInfo:item]];
    }
    
    [self finishedReceivingPullRequestData:[NSArray arrayWithArray:temp]];
    
}

@end
