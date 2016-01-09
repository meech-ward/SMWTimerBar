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
@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic) CGRect lastFrame;
@property (nonatomic) NSInteger frameUpdateTimes;

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
    self.lastFrame = _frame;
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
    _imageView.frame = _frame;
    CGFloat dividerWidth = 4.0;
    _dividerLayer.frame = CGRectMake(CGRectGetMinX(_frame)-(dividerWidth/2.0), 0, dividerWidth, CGRectGetHeight(_frame));
    
    if (++self.frameUpdateTimes == 1) {
        _timerLayer.frame = _frame;
    } else {
        if (_timerLayer.animationKeys && _timerLayer.animationKeys.count > 0) {
            // Currently animating
        } else if (!CGRectEqualToRect(_timerLayer.frame, _lastFrame)) {
            // Completed animation but was not reset
        } else {
            _timerLayer.frame = _frame;
        }
    }
}

- (void)removeFromBar {
    [self.backgroundLayer removeFromSuperlayer];
    [self.timerLayer removeFromSuperlayer];
    [self.dividerLayer removeFromSuperlayer];
    [self.imageView removeFromSuperview];
}

#pragma mark -
#pragma mark - Reset

- (void)reset {
    // Reset the frames
    self.frameUpdateTimes = 0;
    [CATransaction smw_unanimateBlock:^{
        [self updateFrames];
    }];
}

@end
