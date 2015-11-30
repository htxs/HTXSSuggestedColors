//
//  ViewController.m
//  HTXSSuggestedColorsDemo
//
//  Created by jtian on 11/30/15.
//  Copyright © 2015 htxs.me. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HTXS.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button setBackgroundColor:[UIColor htxs_common_list_bg_color]];
    [self.button setTitleColor:[UIColor htxs_common_mid_dark_text_color] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
