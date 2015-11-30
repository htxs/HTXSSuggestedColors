//
//  HTXSSuggestedColors.m
//  HTXSSuggestedColors
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import <objc/runtime.h>
#import "HTXSSuggestedColors.h"
#import "NSColor+HTXS.h"
#import "Aspects.h"
#import "Headers.h"
#import "XcodeEditor.h"

static NSString *const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";

static NSString *const SuggestedColorsImplementationFileName = @"UIColor+HTXS.m";

static NSString *UIColorMethodPattern = @"\\+\\s*\\(UIcolor\\s*\\*\\s*\\)\\s*htxs_(\\w+)\\s*\\{\\s*\\n*.*UIColorHex\\(\\s*\\@\"(.*)\"\\s*\\)\\s*\\;\\s*\\n*.*\\n*\\}";

static NSMutableDictionary *suggestedColorsDict;

static Class IDEWorkspaceWindowControllerClass;

@interface HTXSSuggestedColors()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *projectBundlePath;
@property (nonatomic, strong) NSString *projectWorkspacePath;

@end

@implementation HTXSSuggestedColors

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (instancetype)initWithBundle:(NSBundle *)plugin {
    
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        
        IDEWorkspaceWindowControllerClass = NSClassFromString(@"IDEWorkspaceWindowController");
        
        // Xcode 启动完成
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        // 工作区激活
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(workspaceWindowDidBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];
        
        // 文件修改通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentDidChange:)
                                                     name:IDEEditorDocumentDidChangeNotification
                                                   object:nil];
        
        // Hook DVTAbstractColorPicker's setSuggestedColors: 方法
        NSError *error;
        [objc_getClass("DVTAbstractColorPicker") aspect_hookSelector:@selector(setSuggestedColors:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> par) {
            if (suggestedColorsDict && [[suggestedColorsDict allKeys] count] > 0) {
                DVTAbstractColorPicker *colorPicker = (DVTAbstractColorPicker *)par.instance;
                DVTMutableOrderedDictionary *dict = [[objc_getClass("DVTMutableOrderedDictionary") alloc] initWithObjects:[suggestedColorsDict allValues]
                                                                                                                  forKeys:[suggestedColorsDict allKeys]];
                
                [colorPicker setValue:dict forKey:@"_suggestedColors"];
            }
        } error:&error];
    }
    return self;
}


#pragma mark - NSNotification
// Xcode 启动完成，添加重新加载颜色的按钮
- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Reload Colors" action:@selector(reloadColors:) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// 工作区激活
- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification {
    
    if ([[notification object] isKindOfClass:[IDEWorkspaceWindow class]]) {
        NSWindow *workspaceWindow = (NSWindow *) [notification object];
        NSWindowController *workspaceWindowController = (NSWindowController *) workspaceWindow.windowController;
        IDEWorkspace *workspace = (IDEWorkspace *) [workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath *representingFilePath = workspace.representingFilePath;
        
        self.projectWorkspacePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcworkspace"
                                                                                               withString:@".xcodeproj"];
        
        self.projectBundlePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcodeproj"
                                                                                            withString:@"/"];
        [self reloadColors:nil];
    }
}

// 文件修改通知
- (void)documentDidChange:(NSNotification *)notification {
    
    id doc = notification.object;
    if ([doc isKindOfClass:objc_getClass("IDEEditorDocument")]) {
        if ([[[doc filePath] fileName] isEqualToString:SuggestedColorsImplementationFileName]) {
            [self reloadColors:nil];
        }
    }
}

#pragma mark - Private Methods
// 重新加载颜色
- (void)reloadColors:(id)sender {
    
    if ([self.projectBundlePath length] == 0) {
        return;
    }
    NSLog(@"[HTXS] Project Bundle Path: %@", self.projectBundlePath);
    
    NSString *filePath = [HTXSSuggestedColors taskFindFileWithRelativePath:[self.projectBundlePath stringByDeletingLastPathComponent] fileName:SuggestedColorsImplementationFileName];
    if ([filePath length] == 0) {
        return;
    }
    NSLog(@"[HTXS] File:%@ at Path: %@", SuggestedColorsImplementationFileName, filePath);
    
    suggestedColorsDict = [HTXSSuggestedColors matchesSuggestedColorsWithFilePath:filePath];
}

// 通过 NSTask 执行 find 命令，查找相对路径下的指定文件，并返回文件路径
+ (NSString *)taskFindFileWithRelativePath:(NSString *)relativePath fileName:(NSString *)fileName {
    
    if ([relativePath length] == 0 || [fileName length] == 0) {
        return nil;
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/xcrun";
    task.arguments = @[@"find", [relativePath stringByStandardizingPath], @"-name", fileName];
    task.standardOutput = [NSPipe pipe];
    NSFileHandle *file = [task.standardOutput fileHandleForReading];
    
    [task launch];
    
    // For some reason [task waitUntilExit]; does not return sometimes. Therefore this rather hackish solution:
    int count = 0;
    while (task.isRunning && (count < 10)) {
        [NSThread sleepForTimeInterval:0.1];
        count++;
    }
    
    NSString *output = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    output = [output stringByTrimmingCharactersInSet:set];
    return output;
}

// 通过正则表达式解析源文件，提取一定格式的颜色名和颜色值
+ (NSMutableDictionary *)matchesSuggestedColorsWithFilePath:(NSString *)filePath {
    
    if ([filePath length] == 0) {
        return nil;
    }
    
    NSString *sourceCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if ([sourceCode length] == 0) {
        return nil;
    }
    
    NSMutableDictionary *colors = [NSMutableDictionary dictionary];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:UIColorMethodPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:sourceCode options:NSMatchingReportProgress range:NSMakeRange(0, sourceCode.length)];
    if (matches) {
        for (NSTextCheckingResult *match in matches) {
            if (match.numberOfRanges >= 2) {
                NSString *colorName = [sourceCode substringWithRange:[match rangeAtIndex:1]];
                NSString *colorValue = [sourceCode substringWithRange:[match rangeAtIndex:2]];
                if ([colorName length] == 0 || [colorValue length] == 0) {
                    continue;
                }
                NSLog(@"[HTXS] ColorName: %@, ColorValue: %@", colorName, colorValue);
                
                NSColor *color = [NSColor htxs_colorWithHexString:colorValue];
                [colors setObject:color forKey:colorName];
            }
        }
    }
    
    return colors;
}

@end
