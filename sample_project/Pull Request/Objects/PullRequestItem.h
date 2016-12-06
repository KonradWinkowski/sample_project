//
//  PullRequestItem.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

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

@property (strong, nonatomic) NSURL *commitsURL;

/*
 * Convinence init for a pull request item to populate all of the required fields from the data provided.
 */
+(PullRequestItem*)itemFromInfo:(NSDictionary*)info;

@end
