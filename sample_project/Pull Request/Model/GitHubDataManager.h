//
//  GitHubDataManager.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubDataManagerDelegate;

@interface GitHubDataManager : NSObject

@property (nonatomic, weak) id<GitHubDataManagerDelegate> delegate;

/*
 * Goes out to the GitHub REST API and grabs the latest Pull Requests for 'MagicalRecord'
 * Will call delegate methods depending on success or failure
 * NOTE: since the URL is hard coded in the implementation file we dont need to pass in the URL to go out to
 */
-(void)getPullRequests;

/*
 * Goes out to the GitHub REST API and grabs the files info for the provided URL 
 * Will call delegate methods depending on success or failure
 */
-(void)getFilesInfo:(NSURL*)filesURL;

@end

@protocol GitHubDataManagerDelegate <NSObject>

@optional
/*
 * Gets called when the web request is done and data is parsed into an Array of PullRequestItems
 */
-(void)didDownloadLatestPullRequests:(NSArray*)pullRequests;

/*
 * Gets called when the web request is done and data is parsed into an Array of FileItems
 */
-(void)didDownloadLatestFilesInformation:(NSArray*)commits;

@required
/*
 * Gets called when any error occurs. Delegates should inform UI that something went wrong....
 */
-(void)failedToGetLatestGitHubData;

@end
