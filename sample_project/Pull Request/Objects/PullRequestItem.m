//
//  PullRequestItem.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "PullRequestItem.h"

#define kTitleKey           @"title"
#define kStateKey           @"state"
#define kNumberKey          @"number"
#define kCreatedDateKey     @"created_at"

#define kUserKey            @"user"
#define kLoginKey           @"login"

#define kLinksKey           @"_links"
#define kSelfKey            @"self"
#define kHrefKey            @"href"

@implementation PullRequestItem

+(PullRequestItem*)itemFromInfo:(NSDictionary*)info {
    return [[PullRequestItem alloc] initWithInfo:info];
}

-(instancetype)initWithInfo:(NSDictionary*)info {
    if (self = [super init]) {
        [self parseOutData:info];
    }
    return self;
}

-(void)parseOutData:(NSDictionary*)data {
    
    [self parseOutBaseInfo:data]; // gets the basic info about the pull request
    [self parseOutStateInfo:data]; // gets and sets the state of the pull request
    [self parseOutUserName:data]; // gets and sets the username tied to the pull request
    [self parseOutCommitURL:data]; // gets and sets the commits url for the pull request
}

-(void)parseOutBaseInfo:(NSDictionary*)data {
    
    self.title = [data objectForKey:kTitleKey];
    self.itemNumber = [[data objectForKey:kNumberKey] intValue];
    self.created_date = [data objectForKey:kCreatedDateKey];
    
}

-(void)parseOutUserName:(NSDictionary*)data {
    
    NSDictionary *userInfo = [data objectForKey:kUserKey];
    
    if (!userInfo) return;
    
    self.userName = [userInfo objectForKey:kLoginKey];
    
}

-(void)parseOutCommitURL:(NSDictionary*)data {
    
    NSDictionary *linkInfo = [data objectForKey:kLinksKey];
    
    if (!linkInfo) return;
    
    NSDictionary *selfInfo = [linkInfo objectForKey:kSelfKey];
    
    if (!selfInfo) return;
    
    NSString *selfURL = [selfInfo objectForKey:kHrefKey];
    
    self.filesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/files", selfURL]];
}

-(void)parseOutStateInfo:(NSDictionary*)data {
    
    NSString *state = [data objectForKey:kStateKey];
    
    if (!state || state.length == 0) {
        self.state = Request_State_Closed;
    } else if ([state isEqualToString:@"open"]) {
        self.state = Request_State_Open;
    } else {
        self.state = Request_State_Closed;
    }
    
}

@end
