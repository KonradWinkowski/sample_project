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
        [self parseOutFileData:data];
    }
    return self;
}

-(void)parseOutFileData:(NSDictionary*)data {
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSArray *files = [data objectForKey:@"files"];
    
    for (NSDictionary *info in files) {
        [temp addObject:info];
    }
    
    self.commitData = [NSArray arrayWithArray:temp];
}

@end
