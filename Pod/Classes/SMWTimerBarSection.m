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
#import "CALayer+SMWUtility.h"

@interface SMWTimerBarSection()

@property (strong, nonatomic) CALayer *backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *timerLayer;
@property (strong, nonatomic) CAShapeLayer *dividerLayer;
@property (strong, nonatomic) UIImageView *imageView;

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
    self.imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    
    // Add them to the superview
    [_barView.layer addSublayer:_backgroundLayer];
    [_barView.layer addSublayer:_timerLayer];
    [_barView.layer addSublayer:_dividerLayer];
    [_barView addSubview:_imageView];
}

- (void)updateFrames {
    _backgroundLayer.frame = _frame;
    _timerLayer.frame = _frame;
    _imageView.frame = _frame;
    CGFloat dividerWidth = 4.0;
    _dividerLayer.frame = CGRectMake(CGRectGetMinX(_frame)-(dividerWidth/2.0), 0, dividerWidth, CGRectGetHeight(_frame));
}

- (void)removeFromBar {
    [self.backgroundLayer removeFromSuperlayer];
    [self.timerLayer removeFromSuperlayer];
    [self.dividerLayer removeFromSuperlayer];
    [self.imageView removeFromSuperview];
}


#pragma mark -
#pragma mark - Animation

- (void)animateTimerLayerWithDuration:(NSTimeInterval)time key:(NSString *)key completion:(void(^)(BOOL flag))completion {
    
    // Check a key exists
    if (!key || key.length == 0) {
        key = @"timer_size_animation";
    }
    
    // Animate
    [CATransaction begin];
    [CATransaction setAnimationDuration:time];
    [CATransaction setCompletionBlock:^{
        
        CABasicAnimation *layerSizeAnimation = (CABasicAnimation *)[self.timerLayer animationForKey:key];
        if (layerSizeAnimation) {
            // Set the timerlayer's final state
            [CATransaction smw_unanimateBlock:^{
                self.timerLayer.bounds = [layerSizeAnimation.toValue CGRectValue];
                [self.timerLayer removeAnimationForKey:key];
            }];
        }
        
        if (completion) {
            completion(layerSizeAnimation != nil);
        }
    }];
    
    [self addTimerAnimationWithKey:key];
    
    [CATransaction commit];
}

- (void)addTimerAnimationWithKey:(NSString *)key {
    
    CABasicAnimation *layerSizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    layerSizeAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    layerSizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
    
    layerSizeAnimation.removedOnCompletion = NO;
    layerSizeAnimation.fillMode = kCAFillModeBoth;
    
    [self.timerLayer addAnimation:layerSizeAnimation forKey:key];
}

- (void)pauseAnimations {
    [_timerLayer pauseAnimations];
}

- (void)resumeAniamtions {
    [_timerLayer resumeAniamtions];
}

- (void)stopAnimations {
    [_timerLayer removeAllAnimations];
    [self reset];
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
