//
//  FileItem.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEMPTYSPACESTRING @"__EMPTY__SPACE_STRING__"

@interface FileItem : NSObject

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *blob_url;
@property (strong, nonatomic) NSString *raw_url;
@property (strong, nonatomic) NSString *patch;
@property (strong, nonatomic) NSString *changesInfo;

@property (assign, nonatomic) int additions;
@property (assign, nonatomic) int deletions;
@property (assign, nonatomic) int changes;

@property (strong, nonatomic) NSArray *origianStrings;
@property (strong, nonatomic) NSArray *changedStrings;

/*
 * Convinence init for a file to populate all of the required fields from the data provided.
 */
+(FileItem*)itemWithData:(NSDictionary*)data;

@end
