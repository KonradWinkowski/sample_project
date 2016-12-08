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
        
        [self parseOutBaseInfo:data]; // Get / Set basic info about the File change //
        
        [self generateStringData]; // Generates the equal arrays of strings //
        
        [self generateLineNumbers]; // Generates the line numbers accociated with the file changes //
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

#pragma mark - Line Number Generator

-(void)generateLineNumbers {
    
    self.originalStartingLineStrings = [self generateLineNumberFromArray:self.origianStrings andLineSkipIndex:1];
    
    self.changedStartingLineStrings = [self generateLineNumberFromArray:self.changedStrings andLineSkipIndex:2];
    
}

/*
 * This method does the heavy lifting for generating the line numbers for each of the string arrays 
 * Based in the data provided we know the starting line number of each array.
 * Using that and checking againts my own "blank string" we can easily generate a line number string
 * This also takes into account line skips in the stirngs. If one of our data strings starts with '@@' 
 * we know that GitHub put that there to indicate a line skip. so we parse that out and set that to our line number 
 * this gives us nice clean skips whenever they occur.
 */
- (NSArray*)generateLineNumberFromArray:(NSArray*)array andLineSkipIndex:(int)lineSkipIndex {
    
    NSArray *components = [self.changesInfo componentsSeparatedByString:@" "];
    
    if (components.count == 0) { return @[]; }
    
    int startIndex = [self getLineFumberFromComponents:[components objectAtIndex:lineSkipIndex]];
    
    NSMutableArray *numbersTemp = [NSMutableArray new];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *stringToValidate = [array objectAtIndex:i];
        
        if ([stringToValidate hasPrefix:@"@@"]) {
            NSArray *components = [stringToValidate componentsSeparatedByString:@" "];
            
            if (components.count == 0) { continue; }
            
            int skipValue = [self getLineFumberFromComponents:[components objectAtIndex:lineSkipIndex]];
            
            startIndex = skipValue;
            [numbersTemp addObject:@" "];
            
        } else if ([stringToValidate isEqualToString:KEMPTYSPACESTRING] == NO) {
            [numbersTemp addObject:[NSString stringWithFormat:@"%d", startIndex]];
            startIndex++;
        } else {
            [numbersTemp addObject:@" "];
        }
        
    }

    return [NSArray arrayWithArray:numbersTemp];
    
}

/*
 * Since we know that the data passed in will always be ##,## (starting line number , addition/deletion) we can easily parse out the first number to get our starting line number
 */
-(int)getLineFumberFromComponents:(NSString*)component {
    NSArray *values = [component componentsSeparatedByString:@","];
    return ABS([values.firstObject intValue]);
}

#pragma mark - File Strings Generator

/*
 * This method starts the generation of the two original/changed string arrays.
 * Since we know for a fact that a line starting with '-' is a deletion we can put it in the origianl array
 * and a line staring with '+' we can put in the additions column.
 * Anything else gets added to both columns as there are no changes and both sides should show the same stirng.
 * Once that is done, we start the recursion to make the two arrays equal and fill in any blanks that may be there
 */
-(void)generateStringData {
    
    NSMutableArray *originalTemp = [NSMutableArray new];
    NSMutableArray *changesTemp = [NSMutableArray new];
    
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

/*
 * This is the recursive method that fills in the "empty space" strings to easily display them on a table view 
 * Each time it is called it checks to see if the two arrays are of equal item count. If they are the recursion ends.
 * If they are not we do string comparison and add a empty line to fill in the gaps in the array. Once we find a spot
 * to add a empty string we break out of the for loop and continue the recursion.
 */
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
        
        // if one array is smaller then the other and we are at the end of the other array we just add an empty string till they even out //
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
