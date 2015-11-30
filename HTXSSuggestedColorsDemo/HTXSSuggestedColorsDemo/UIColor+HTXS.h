//
//  UIColor+HTXS.h
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Create UIColor with a hex string.
 Example: UIColorHex(@"0xF0F"), UIColorHex(@"66ccff"), UIColorHex(@"#66CCFF88")
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor htxs_colorWithHexString:((_hex_))]
#endif

@interface UIColor (HTXS)

#pragma mark - Create a UIColor Object
/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or [NSColor whiteColor] if an error occurs.
 */
+ (UIColor *)htxs_colorWithHexString:(NSString *)hexStr;

#pragma mark - Get color's description
/**
 Returns the color's RGB value as a hex string (lowercase).
 Such as @"0066cc".
 
 It will return nil when the color space is not RGB
 
 @return The color's value as a hex string.
 */
- (NSString *)htxs_hexString;

/**
 Returns the color's RGBA value as a hex string (lowercase).
 Such as @"0066ccff".
 
 It will return nil when the color space is not RGBA
 
 @return The color's value as a hex string.
 */
- (NSString *)htxs_hexStringWithAlpha;

#pragma mark - UIColor for specified project

/**
 通用列表背景色: #f4f4f4
 */
+ (UIColor *)htxs_common_list_bg_color;

/**
 通用输入框光标高亮色: #ff8712
 */
+ (UIColor *)htxs_common_text_tint_color;

/**
 通用文本字体黑色: #333333
 */
+ (UIColor *)htxs_common_dark_text_color;

/**
 通用文本字体中等黑色: #666666
 */
+ (UIColor *)htxs_common_mid_dark_text_color;

/**
 通用文本字体浅黑色: #999999
 */
+ (UIColor *)htxs_common_light_dark_text_color;

@end
