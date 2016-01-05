//
//  SMWViewController.m
//  SMWTimerBar
//
//  Created by Sam Meech-Ward on 01/04/2016.
//  Copyright (c) 2016 Sam Meech-Ward. All rights reserved.
//

#import "SMWViewController.h"

#import <SMWTimerBar/SMWTimerBar.h>

@interface SMWViewController ()

@property (weak, nonatomic) IBOutlet SMWTimerBarView *timerBar;

@end

@implementation SMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _timerBar.backgroundColors = @[[UIColor blueColor]];
    _timerBar.timerColors = @[[UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.5]];
    _timerBar.dividerColors = @[[UIColor whiteColor], [UIColor lightGrayColor], [UIColor grayColor]];
    _timerBar.time = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleAnimation:(id)sender {
    [_timerBar startAnimating];
}

@end
