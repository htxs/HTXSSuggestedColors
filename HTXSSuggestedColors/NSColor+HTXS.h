//
//  NSColor+HTXS.h
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 Create NSColor with a hex string.
 Example: NSColorHex(@"0xF0F"), NSColorHex(@"66ccff"), NSColorHex(@"#66CCFF88")
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef NSColorHex
#define NSColorHex(_hex_)   [NSColor htxs_colorWithHexString:((_hex_))]
#endif

@interface NSColor (HTXS)

#pragma mark - Create a NSColor Object
/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An NSColor object from string, or [NSColor whiteColor] if an error occurs.
 */
+ (NSColor *)htxs_colorWithHexString:(NSString *)hexStr;

@end
