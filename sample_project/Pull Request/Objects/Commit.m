//
//  Commit.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "Commit.h"

@implementation Commit

+(Commit*)commitFromData:(NSDictionary*)data {
    return [[Commit alloc] initWithData:data];
}

-(instancetype)initWithData:(NSDictionary*)data {
    if (self = [super init]) {
        
    }
    return self;
}

@end
