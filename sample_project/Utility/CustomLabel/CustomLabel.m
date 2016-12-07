//
//  CustomLabel.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(void)setText:(NSString *)text {
    [super setText:text];
    
    if ([text hasPrefix:@"-"]) {
        self.backgroundColor = [[UIColor colorWithRed:.675 green:.157 blue:.110 alpha:1.0] colorWithAlphaComponent:0.45];
    } else if ([text hasPrefix:@"+"]) {
        self.backgroundColor = [[UIColor colorWithRed:.596 green:.749 blue:0.0 alpha:1.0] colorWithAlphaComponent:0.45];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
