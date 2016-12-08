//
//  PullRequestItem.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//
//  This class holds all of the data that we'll need to display to the user information about the pull request.
//  It also has the URL we'll need to get the 'Files' data which is what we use to show the changes in the pull request

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Request_State) {
    Request_State_Closed,
    Request_State_Open
};

@interface PullRequestItem : NSObject

@property (assign, nonatomic) Request_State state;
@property (assign, nonatomic) int itemNumber;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *created_date;

@property (strong, nonatomic) NSURL *filesURL;

/*
 * Convinence init for a pull request item to populate all of the required fields from the data provided.
 */
+(PullRequestItem*)itemFromInfo:(NSDictionary*)info;

@end
