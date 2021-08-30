//
//  SJViewController.m
//  SJLogger
//
//  Created by tom on 08/30/2021.
//  Copyright (c) 2021 tom. All rights reserved.
//

#import "SJViewController.h"

//#import "SJLogger.h"
#import "SJLogger.h"


@interface SJViewController ()

@end

@implementation SJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SJLogger open:YES];
    [SJLogger saveLog2Disk:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    debugLog(@"1");
}

@end
