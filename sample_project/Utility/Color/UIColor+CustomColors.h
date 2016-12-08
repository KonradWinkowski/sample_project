//
//  UIColor+CustomColors.h
//  sample_project
//
//  Created by Konrad Winkowski on 12/7/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//
//  Utility class to easily use custom 'Flat' UI colors.

#import <UIKit/UIKit.h>

@interface UIColor (CustomColors)

+(UIColor*)colorWithHexString:(NSString*)hex;

+ (UIColor *)flatYellow;
+ (UIColor *)flatYellowDark;

+ (UIColor *)flatLime;
+ (UIColor *)flatLimeDark;

+ (UIColor *)flatRed;
+ (UIColor *)flatRedDark;

+ (UIColor *)flatCoffee;
+ (UIColor *)flatCoffeeDark;

+ (UIColor *)flatSand;
+ (UIColor *)flatSandDark;

+ (UIColor *)flatWhite;
+ (UIColor *)flatWhiteDark;

+ (UIColor *)flatGray;
+ (UIColor *)flatGrayDark;

+ (UIColor *)flatMaroon;
+ (UIColor *)flatMaroonDark;

+ (UIColor *)flatForestGreen;
+ (UIColor *)flatForestGreenDark;

+ (UIColor *)flatPlum;
+ (UIColor *)flatPlumDark;

@end
