//
//  FileItem.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "FileItem.h"

#define kFileNameKey        @"filename"
#define kStatusKey          @"status"
#define kAdditionsKey       @"additions"
#define kDeletionsKey       @"deletions"
#define kChangesKey         @"changes"
#define kBlobURLKey         @"blob_url"
#define kRawURLKey          @"raw_url"
#define kContentsURLKey     @"contents_url"
#define kPatchKey           @"patch"

@implementation FileItem

+(FileItem*)itemWithData:(NSDictionary*)data {
    return [[FileItem alloc] initWithData:data];
}

-(instancetype)initWithData:(NSDictionary*)data {
    if (self = [super init]) {
        [self parseOutBaseInfo:data];
        
        [self generateStringData];
    }
    return self;
}

-(void)parseOutBaseInfo:(NSDictionary*)data {
    
    self.fileName = [data objectForKey:kFileNameKey];
    self.status = [data objectForKey:kStatusKey];
    self.additions = [[data objectForKey:kAdditionsKey] intValue];
    self.deletions = [[data objectForKey:kDeletionsKey] intValue];
    self.changes = [[data objectForKey:kChangesKey] intValue];
    self.blob_url = [data objectForKey:kBlobURLKey];
    self.raw_url = [data objectForKey:kRawURLKey];
    self.patch = [data objectForKey:kPatchKey];
    
}

-(void)generateStringData {
    
    NSMutableArray *originalTemp = [NSMutableArray new];
    NSMutableArray *changesTemp = [NSMutableArray new];
    
//    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"@@"];
//    NSRange range = [self.patch rangeOfCharacterFromSet:charSet];
//    
//    if (range.location == NSNotFound) { return; }
//    
//    self.changesInfo = [self.patch substringToIndex:range.location];
//    
//    NSString *dataStirng = [self.patch substringFromIndex:range.location];
    
    NSArray *components = [self.patch componentsSeparatedByString:@"\n"];
    
    self.changesInfo = components.firstObject;
    
    NSMutableArray *temp_removed = [components mutableCopy];
    [temp_removed removeObjectAtIndex:0];
    
    components = [NSArray arrayWithArray:temp_removed];
    
    for (NSString *item in components) {
        
        if ([item hasPrefix:@"-"]) {
            [originalTemp addObject:item];
        } else if ([item hasPrefix:@"+"]) {
            [changesTemp addObject:item];
        } else {
            [originalTemp addObject:item];
            [changesTemp addObject:item];
        }
        
    }
    
    self.origianStrings = [NSArray arrayWithArray:originalTemp];
    self.changedStrings = [NSArray arrayWithArray:changesTemp];
    
    [self fillInBlankSpaces];
}

- (void)fillInBlankSpaces {
    
    if (self.origianStrings.count == self.changedStrings.count) {
        return;
    }
    
    NSMutableArray *original_copy = self.origianStrings.mutableCopy;
    NSMutableArray *changed_copy = self.changedStrings.mutableCopy;
    
    for (int i = 0; i < MAX(self.origianStrings.count, self.changedStrings.count); i ++) {
        
        NSString *original_string, *changed_string;
        
        if (i < self.changedStrings.count) {
            changed_string = [self.changedStrings objectAtIndex:i];
        }
        
        if (i < self.origianStrings.count) {
            original_string = [self.origianStrings objectAtIndex:i];
        }
        
        if (!original_string) {
            [original_copy insertObject:KEMPTYSPACESTRING atIndex:original_copy.count];
            break;
        } else if (!changed_string) {
            [changed_copy insertObject:KEMPTYSPACESTRING atIndex:changed_copy.count];
            break;
        }
        else if ([original_string hasPrefix:@"-"] && ![changed_string hasPrefix:@"+"]) {
            if ([changed_string isEqualToString:KEMPTYSPACESTRING] == NO) {
                [changed_copy insertObject:KEMPTYSPACESTRING atIndex:i];
                break;
            }
        } else if (![original_string hasPrefix:@"-"] && [changed_string hasPrefix:@"+"]) {
            if ([original_string isEqualToString:KEMPTYSPACESTRING] == NO) {
                [original_copy insertObject:KEMPTYSPACESTRING atIndex:i];
                break;
            }
        }
        
    }
    
    self.origianStrings = [NSArray arrayWithArray:original_copy];
    self.changedStrings = [NSArray arrayWithArray:changed_copy];
    
    [self fillInBlankSpaces];
}

@end
