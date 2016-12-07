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
        self.backgroundColor = [[UIColor flatRed] colorWithAlphaComponent:0.45];
    } else if ([text hasPrefix:@"+"]) {
        self.backgroundColor = [[UIColor flatLime] colorWithAlphaComponent:0.45];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
