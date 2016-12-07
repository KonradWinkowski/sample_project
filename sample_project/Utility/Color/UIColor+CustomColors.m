//
//  UIColor+CustomColors.m
//  sample_project
//
//  Created by Konrad Winkowski on 12/7/16.
//  Copyright © 2016 Konrad Winkowski. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)flatYellow {
    return [UIColor colorWithHexString:@"FBC700"];
}

+ (UIColor *)flatYellowDark {
    return [UIColor colorWithHexString:@"F99A00"];
}

+ (UIColor *)flatLime {
    return [UIColor colorWithHexString:@"98BF00"];
}

+ (UIColor *)flatLimeDark {
    return [UIColor colorWithHexString:@"7FA500"];
}

+ (UIColor *)flatRed {
    return [UIColor colorWithHexString:@"D93829"];
}

+ (UIColor *)flatRedDark {
    return [UIColor colorWithHexString:@"AC281C"];
}

+ (UIColor *)flatCoffee {
    return [UIColor colorWithHexString:@"90745B"];
}

+ (UIColor *)flatCoffeeDark {
    return [UIColor colorWithHexString:@"7A5F49"];
}

+ (UIColor *)flatSand {
    return [UIColor colorWithHexString:@"EBD89F"];
}

+ (UIColor *)flatSandDark {
    return [UIColor colorWithHexString:@"CAB77D"];
}

+ (UIColor *)flatWhite {
    return [UIColor colorWithHexString:@"E8ECEE"];
}

+ (UIColor *)flatWhiteDark {
    return [UIColor colorWithHexString:@"B0B6BB"];
}

+ (UIColor *)flatGray {
    return [UIColor colorWithHexString:@"849495"];
}

+ (UIColor *)flatGrayDark {
    return [UIColor colorWithHexString:@"6D797A"];
}

+ (UIColor *)flatMaroon {
    return [UIColor colorWithHexString:@"62231E"];
}

+ (UIColor *)flatMaroonDark {
    return [UIColor colorWithHexString:@"501C18"];
}

+ (UIColor *)flatForestGreen {
    return [UIColor colorWithHexString:@"2B4E2F"];
}

+ (UIColor *)flatForestGreenDark {
    return [UIColor colorWithHexString:@"254026"];
}

+ (UIColor *)flatPlum {
    return [UIColor colorWithHexString:@"49244E"];
}

+ (UIColor *)flatPlumDark {
    return [UIColor colorWithHexString:@"3C1D40"];
}

@end
