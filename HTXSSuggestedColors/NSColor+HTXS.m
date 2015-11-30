//
//  NSColor+HTXS.m
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import "NSColor+HTXS.h"

@implementation NSColor (HTXS)

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [str stringByTrimmingCharactersInSet:set];
    str = [str uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    }
    else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    // RGB, RGBA, RRGGBB, RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4) {
            *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        }
        else {
            *a = 1;
        }
    }
    else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) {
            *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        }
        else {
            *a = 1;
        }
    }
    return YES;
}

#pragma mark - Create a UIColor Object

+ (NSColor *)htxs_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        if ([NSColor respondsToSelector:@selector(colorWithRed:green:blue:)]) {
            return [NSColor colorWithRed:r green:g blue:b alpha:a];
        }
        else {
            return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
        }
    }
    return [NSColor whiteColor];
}

@end
