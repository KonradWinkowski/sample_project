//
//  CustomLabel.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/6/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//
//  Custom label used to easily set the background color to identify a line addition or deletion.
//  Since we know that a addition starts with '+' and a deletion starts with '-'
//  We can make checks for that when text of the label is set and then change the color of the labels
//  background to match that of what we need.

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

@end
