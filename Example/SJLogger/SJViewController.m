//
//  SJViewController.m
//  SJLogger
//
//  Created by tom on 08/30/2021.
//  Copyright (c) 2021 tom. All rights reserved.
//

#import "SJViewController.h"

#import "SJLoggerManager.h"

@interface SJViewController ()

@end

@implementation SJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    debugLog(@"hello");
    debugNameLog(@"cin", @"hello world");
    
    static int i = 0;
    ++i;
    
    if (i >= 5) {
        [SJLoggerManager setLoggerOpen:NO ofName:nil];
        [SJLoggerManager setLoggerOpen:NO ofName:@"cin"];
    }
    
    
}

@end
