//
//  SMWTimerBarSection.m
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import "SMWTimerBarSection.h"
#import "SMWTimerBarView.h"

#import "CATransaction+SMWUtility.h"

@interface SMWTimerBarSection()

@property (strong, nonatomic) CALayer *backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *timerLayer;
@property (strong, nonatomic) CAShapeLayer *dividerLayer;

@end

@implementation SMWTimerBarSection

#pragma mark - SetUp

- (instancetype)init {
    return [self initWithFrame:CGRectZero barView:[SMWTimerBarView new]];
}

- (instancetype)initWithFrame:(CGRect)frame barView:(SMWTimerBarView *)barView {
    self = [super init];
    if (self) {
        self.barView = barView;
        [self setUp];
        self.frame = frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    [self updateFrames];
}

- (void)setUp {
    [self setUpLayers];
}

- (void)setUpLayers {
    // Create the layers
    self.backgroundLayer = [CALayer layer];
    self.timerLayer = [CAShapeLayer layer];
    _timerLayer.anchorPoint = CGPointZero;
    self.dividerLayer = [CAShapeLayer layer];
    
    // Add them to the superview
    [_barView.layer addSublayer:_backgroundLayer];
    [_barView.layer addSublayer:_timerLayer];
    [_barView.layer addSublayer:_dividerLayer];
}

- (void)updateFrames {
    _backgroundLayer.frame = _frame;
    _timerLayer.frame = _frame;
    CGFloat dividerWidth = 4.0;
    _dividerLayer.frame = CGRectMake(CGRectGetMinX(_frame)-(dividerWidth/2.0), 0, dividerWidth, CGRectGetHeight(_frame));
}

- (void)removeFromBar {
    [self.backgroundLayer removeFromSuperlayer];
    [self.timerLayer removeFromSuperlayer];
    [self.dividerLayer removeFromSuperlayer];
}


#pragma mark -
#pragma mark - Animation

-(void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark -
#pragma mark - Reset

- (void)reset {
    // Remove any animation
    [_backgroundLayer removeAllAnimations];
    [_timerLayer removeAllAnimations];
    [_dividerLayer removeAllAnimations];
    
    // Reset the frames
    [CATransaction smw_unanimateBlock:^{
        [self updateFrames];
    }];
}

@end
