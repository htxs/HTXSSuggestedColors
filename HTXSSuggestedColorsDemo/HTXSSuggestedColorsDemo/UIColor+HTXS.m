//
//  UIColor+HTXS.m
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import "UIColor+HTXS.h"

@implementation UIColor (HTXS)

#pragma mark - Helper methods

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

+ (UIColor *)htxs_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return [UIColor whiteColor];
}

#pragma mark - Get color's description

- (NSString *)htxs_hexString {
    return [self htxs_hexStringWithAlpha:NO];
}

- (NSString *)htxs_hexStringWithAlpha {
    return [self htxs_hexStringWithAlpha:YES];
}

- (NSString *)htxs_hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    }
    else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(CGColorGetAlpha(self.CGColor) * 255.0 + 0.5)];
    }
    return hex;
}

#pragma mark - UIColor for specified project

+ (UIColor *)htxs_common_list_bg_color {
    return UIColorHex(@"#f4f4f4");
}

+ (UIColor *)htxs_common_text_tint_color {
    return UIColorHex(@"#ff8712");
}

+ (UIColor *)htxs_common_dark_text_color {
    return UIColorHex(@"#333333");
}

+ (UIColor *)htxs_common_mid_dark_text_color {
    return UIColorHex(@"#666666");
}

+ (UIColor *)htxs_common_light_dark_text_color {
    return UIColorHex(@"#999999");
}

@end
