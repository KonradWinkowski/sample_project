//
//  Commit.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commit : NSObject



/*
 * Convinence init for a commit to populate all of the required fields from the data provided.
 */
+(Commit*)commitFromData:(NSDictionary*)data;

@end
