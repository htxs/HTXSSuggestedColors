//
//  HTXSSuggestedColors.h
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import <AppKit/AppKit.h>

@class HTXSSuggestedColors;

static HTXSSuggestedColors *sharedPlugin;

@interface HTXSSuggestedColors : NSObject

+ (instancetype)sharedPlugin;
- (instancetype)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle *bundle;

@end
