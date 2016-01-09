//
//  SMWTimerBarView.m
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import "SMWTimerBarView.h"

#import "SMWTimerBarSection.h"

#import "SMWDisplayLink.h"

#import "CATransaction+SMWUtility.h"

@interface SMWTimerBarView() <SMWDisplayLinkDelegate> {
    CGRect _lastFrame;
}

@property (strong, nonatomic) NSArray<SMWTimerBarSection *> *sections;
@property (strong, nonatomic) SMWDisplayLink *timer;

@end

@implementation SMWTimerBarView

#pragma mark -
#pragma mark - SetUp

- (instancetype)initWithFrame:(CGRect)frame numberOfSections:(NSInteger)sections {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfSections = sections;
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfSections:1];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self setUpTimer];
}



- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateFrames];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_lastFrame, self.frame)) {
        [self updateFrames];
        _lastFrame = self.frame;
    }}

- (void)updateFrames {
    CGFloat sectionX = 0;
    CGFloat sectionWidth = CGRectGetWidth(self.frame)/_numberOfSections;
    for (int i = 0; i < _numberOfSections; ++i) {
        
        // Frame
        CGRect sectionFrame = CGRectMake(sectionX, 0, sectionWidth, CGRectGetHeight(self.frame));
        sectionX+=sectionWidth;
        
        // Create the section
        SMWTimerBarSection *section = _sections[i];
        section.frame = sectionFrame;
    }
}

- (void)reset {
    for (SMWTimerBarSection *section in _sections) {
        [section reset];
    }
    self.state = SMWTimerBarViewStateNormal;
}


#pragma mark -
#pragma mark - Sections

- (void)setNumberOfSections:(NSInteger)numberOfSections {
    _numberOfSections = numberOfSections;
    [self setupSections];
}

- (void)setupSections {
    NSMutableArray *sections = [[NSMutableArray alloc] initWithCapacity:_numberOfSections];
    
    // Create a section object for the number of sections
    CGFloat sectionX = 0;
    CGFloat sectionWidth = CGRectGetWidth(self.frame)/_numberOfSections;
    for (int i = 0; i < _numberOfSections; ++i) {
        
        // Frame
        CGRect frame = CGRectMake(sectionX, 0, sectionWidth, CGRectGetHeight(self.frame));
        sectionX+=sectionWidth;
        
        // Create the section
        SMWTimerBarSection *section = [[SMWTimerBarSection alloc] initWithFrame:frame barView:self];
        [sections addObject:section];
    }
    
    // Remove the current sections
    for (SMWTimerBarSection *section in _sections) {
        [section removeFromBar];
    }
    
    self.sections = sections.copy;
}

#pragma mark -
#pragma mark - Appearance

- (void)setBackgroundColors:(NSArray<UIColor *> *)backgroundColors {
    _backgroundColors = backgroundColors;
    [self updateBackgroundColors];
}

- (void)updateBackgroundColors {
    [self setColors:_backgroundColors forSectionLayers:^CALayer *(SMWTimerBarSection *section) {
        return section.backgroundLayer;
    }];
}

- (void)setTimerColors:(NSArray<UIColor *> *)timerColors {
    _timerColors = timerColors;
    [self updateTimerColors];
}

- (void)updateTimerColors {
    [self setColors:_timerColors forSectionLayers:^CALayer *(SMWTimerBarSection *section) {
        return section.timerLayer;
    }];
}

- (void)setDividerColors:(NSArray<UIColor *> *)dividerColors {
    _dividerColors = dividerColors;
    [self updateDividerColors];
}

- (void)updateDividerColors {
    [self setColors:_dividerColors forSectionLayers:^CALayer *(SMWTimerBarSection *section) {
        return section.dividerLayer;
    }];
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    [self updateImages];
}

- (void)updateImages {
    int imageIndex = 0;
    for (int i = 0; i < _numberOfSections; ++i) {
        // Get the section image view
        SMWTimerBarSection *section = _sections[i];
        UIImageView *imageView = section.imageView;
        
        // Get the image
        UIImage *image = _images[imageIndex];
        imageIndex = imageIndex >= _images.count-1 ? 0 : imageIndex+1;
        
        // Set the image
        imageView.image = image;
    }
}

- (void)setColors:(NSArray<UIColor *> *)colors forSectionLayers:(CALayer *(^)(SMWTimerBarSection *section))sectionLayer {
    int colorIndex = 0;
    for (int i = 0; i < _numberOfSections; ++i) {
        // Get the section layer
        SMWTimerBarSection *section = _sections[i];
        CALayer *layer = sectionLayer(section);
        
        // Get the color
        UIColor *color = colors[colorIndex];
        colorIndex = colorIndex >= colors.count-1 ? 0 : colorIndex+1;
        
        // Set the colors
        layer.backgroundColor = color.CGColor;
    }
}


#pragma mark -
#pragma mark - Animation

- (void)startAnimating {
    // Start the timer
    [_timer startTimer];
    
    self.state = SMWTimerBarViewStateAnimating;
}

- (void)checkAnimatingSectionChange:(NSInteger)sectionIndex {
    SMWTimerBarSection *currentSection = _sections[sectionIndex];
    
    // Check for when the sections change
    
    if (!_animatingSection || ![currentSection isEqual:_animatingSection]) {
        // New Section
        
        // Finish the last section
        [CATransaction smw_unanimateBlock:^{
            _animatingSection.timerLayer.frame = CGRectMake(CGRectGetMinX(_animatingSection.frame), CGRectGetMinY(_animatingSection.frame), 0, CGRectGetHeight(_animatingSection.frame));
        }];
        
        // Delegate
        if (_animatingSection && [_delegate respondsToSelector:@selector(timerBarView:didCountdownSection:)]) {
            [_delegate timerBarView:self didCountdownSection:sectionIndex+1];
        }
        self.animatingSection = currentSection;
        if ([_delegate respondsToSelector:@selector(timerBarView:willCountdownSection:)]) {
            [_delegate timerBarView:self willCountdownSection:sectionIndex];
        }
    }
}

- (void)step:(CGFloat)percentComplete time:(NSTimeInterval)timeComplete {
    
    if (percentComplete == 0 || isnan(percentComplete)) {
        return;
    }
    if (timeComplete == 0 || isnan(timeComplete)) {
        return;
    }
    
    __block double currentSectionRange = 0;
    __block NSTimeInterval currentTime = timeComplete;
    [_sections enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SMWTimerBarSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        if (currentTime >= section.time) {
            currentTime-=section.time;
            return;
        }
        
        [self checkAnimatingSectionChange:idx];
        
        currentSectionRange = currentTime/section.time;
        
        // Update the frame
        CGFloat sectionWidth = CGRectGetWidth(section.frame);
        sectionWidth = sectionWidth-(sectionWidth*currentSectionRange);
        [CATransaction smw_unanimateBlock:^{
            section.timerLayer.frame = CGRectMake(CGRectGetMinX(section.frame), CGRectGetMinY(section.frame), sectionWidth, CGRectGetHeight(section.frame));
        }];
        
        *stop = YES;
    }];
}

- (void)pauseAnimations {
    [_timer pauseTimer];
    self.state = SMWTimerBarViewStatePaused;
}

- (void)resumeAnimations {
    [_timer resumeTimer];
    self.state = SMWTimerBarViewStateAnimating;
}

- (void)stopAnimations {
    // Stop the animations
    [_timer stopTimer];
    
    // Reset the sections
    for (SMWTimerBarSection *section in self.sections) {
        [section reset];
    }
    
    // Cleanup
    self.state = SMWTimerBarViewStateNormal;
    self.animatingSection = nil;
}

- (BOOL)isPaused {
    return _timer.timer.isPaused;
}

- (void)fastForward:(NSTimeInterval)duration animated:(BOOL)animated {
    [_timer fastForward:duration animated:animated];
}

#pragma mark -
#pragma mark - Timer

- (void)setUpTimer {
    __weak SMWTimerBarView *weakSelf = self;
    self.timer = [[SMWDisplayLink alloc] initWithDuration:self.totalTime
                                            frameInterval:6
                                             runLoopModes:@[NSDefaultRunLoopMode]];
    _timer.delegate = self;
    _timer.stepBlock = ^(CGFloat percentComplete, CFTimeInterval timeComplete) {
        [weakSelf step:percentComplete time:timeComplete];
    };
}
- (void)setTimes:(NSArray<NSNumber *> *)times {
    _times = times;
    [self updateTimes];
    _timer.duration = self.totalTime;
}

- (void)updateTimes {
    int timeIndex = 0;
    for (int i = 0; i < _numberOfSections; ++i) {
        // Get the section view
        SMWTimerBarSection *section = _sections[i];
        
        // Get the time
        NSNumber *time = _times[timeIndex];
        timeIndex = timeIndex >= _times.count-1 ? 0 : timeIndex+1;
        
        // Set the image
        section.time = [time doubleValue];
    }
}


- (NSTimeInterval)totalTime {
    NSTimeInterval time = 0;
    for (SMWTimerBarSection *section in _sections) {
        time+=section.time;
    }
    return time;
}

#pragma mark -
#pragma mark - Timer Delegate

- (void)displayLink:(SMWDisplayLink *)displayLink didCompleteAnimationWithDuration:(NSTimeInterval)duration {
    self.state = SMWTimerBarViewStateCompletedAnimation;
    self.animatingSection = nil;
    
    if ([_delegate respondsToSelector:@selector(timerBarView:didCountdownSection:)]) {
        [_delegate timerBarView:self didCountdownSection:0];
    }
    if ([_delegate respondsToSelector:@selector(timerBarViewDidFinishCountdown:)]) {
        [_delegate timerBarViewDidFinishCountdown:self];
    }
}

@end
