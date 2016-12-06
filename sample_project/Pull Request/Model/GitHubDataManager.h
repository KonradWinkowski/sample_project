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
 * Will call delegate methods depending on succes or failure
 */
-(void)updatePullRequests;

@end

@protocol GitHubDataManagerDelegate <NSObject>

@required
/*
 * Gets called when the web request is done and data is parsed into an Array of PullRequestItems
 */
-(void)didDownloadLatestPullRequests:(NSArray*)pullRequests;

/*
 * Gets called when any error occurs. Delegates should inform UI that something went wrong....
 */
-(void)failedToGetLatestPullRequests;

@end
