//
//  GitHubDataManager.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "GitHubDataManager.h"

@implementation GitHubDataManager

+(GitHubDataManager*)manager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GitHubDataManager alloc] init];
    });
    return instance;
}

@end
