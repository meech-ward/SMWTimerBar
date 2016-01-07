//
//  SMWViewController.m
//  SMWTimerBar
//
//  Created by Sam Meech-Ward on 01/04/2016.
//  Copyright (c) 2016 Sam Meech-Ward. All rights reserved.
//

#import "SMWViewController.h"

#import <SMWTimerBar/SMWTimerBar.h>

@interface SMWViewController () <SMWTimerBarViewDelegate>

@property (weak, nonatomic) IBOutlet SMWTimerBarView *timerBar;

@end

@implementation SMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _timerBar.backgroundColors = @[[UIColor blueColor]];
    _timerBar.timerColors = @[[UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.5], [UIColor colorWithRed:255.0/255.0 green:1.0 blue:0 alpha:0.5]];
    _timerBar.dividerColors = @[[UIColor whiteColor], [UIColor lightGrayColor], [UIColor grayColor]];
    _timerBar.time = 3;
    _timerBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleAnimation:(id)sender {
    switch (_timerBar.state) {
        case SMWTimerBarViewStateAnimating:
            [_timerBar pauseAnimations];
            break;
        case SMWTimerBarViewStatePaused:
            [_timerBar resumeAnimations];
            break;
        case SMWTimerBarViewStateNormal:
            [_timerBar startAnimating];
            break;
        case SMWTimerBarViewStateCompletedAnimation:
            [_timerBar reset];
            break;
    }
}


#pragma mark -
#pragma mark - Delegate

- (void)timerBarViewDidFinishCountdown:(SMWTimerBarView *)timerBarView {
//    [timerBarView reset];
}

- (void)timerBarView:(SMWTimerBarView *)timerBarView willCountdownSection:(NSInteger)section {
    
}

- (void)timerBarView:(SMWTimerBarView *)timerBarView didCountdownSection:(NSInteger)section {
    
}

@end
