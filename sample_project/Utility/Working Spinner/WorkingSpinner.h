//
//  WorkingSpinner.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/5/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkingSpinner : UIView

@property (nonatomic, strong) UIColor *outsideLineColor;
@property (nonatomic, strong) UIColor *insideLineColor;

@property (nonatomic, assign) IBInspectable float outsideLineWidth;
@property (nonatomic, assign) IBInspectable float insideLineWidth;

@end
