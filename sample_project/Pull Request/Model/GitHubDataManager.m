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


-(void)downloadCommitInfoFor:(NSArray*)data toCommits:(NSMutableArray*)commits {
    
    if (data.count == 0) {
        [self finishedReceivingCommitInformation:commits];
        return;
    }
    
    NSURL *commitURL = data.firstObject;
    __weak typeof(self) weakself = self;
    
    [self getFullCommitItemInfoForURL:commitURL withCompletion:^(BOOL result, Commit *item) {
        
        if (result) {
            NSMutableArray *newData = [data mutableCopy];
            [newData removeObjectAtIndex:0];
            
            [commits addObject:item];
            
            [weakself downloadCommitInfoFor:[NSArray arrayWithArray:newData] toCommits:commits];
        } else {
            [weakself failedToGetData];
        }
        
    }];
}

-(void)getFullCommitItemInfoForURL:(NSURL*)commitURL withCompletion:(void (^)(BOOL result, Commit *item))completion{
        
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:commitURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"%@", response);
        if (error) {
            completion(NO, nil);
        } else {
            
            NSError *error;
            NSDictionary *commitInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                completion(NO, nil);
            } else {
                completion(YES, [Commit commitFromData:commitInfo]);
            }
        }
    }];
    
    [dataTask resume];
}

-(void)getCommitsInfo:(NSURL*)commitsURL {
    
    NSAssert(self.delegate, @"A Delegate is Required for this object!");
    
    __weak typeof(self) weakself = self;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:commitsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
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
        [temp addObject:[NSURL URLWithString:[item objectForKey:@"url"]]];
    }
    
    [self downloadCommitInfoFor:[NSArray arrayWithArray:temp] toCommits:[NSMutableArray new]];
    
}

-(void)parseArrayOfRawItems:(NSArray*)items {
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *item in items) {
        [temp addObject:[PullRequestItem itemFromInfo:item]];
    }
    
    [self finishedReceivingPullRequestData:[NSArray arrayWithArray:temp]];
    
}

@end
