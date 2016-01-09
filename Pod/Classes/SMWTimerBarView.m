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
    CGFloat _incrementWidth;
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

- (void)setUpTimer {
    __weak SMWTimerBarView *weakSelf = self;
    self.timer = [[SMWDisplayLink alloc] initWithDuration:_time
                                            frameInterval:1
                                                stepBlock:^(CGFloat percentComplete) {
                                                    [weakSelf step:percentComplete];
                                                }
                                             runLoopModes:@[NSDefaultRunLoopMode]];
    _timer.delegate = self;
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

- (void)setTime:(NSTimeInterval)time {
    _time = time;
    _timer.duration = time;
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
    // Divide the time between the sections
    NSTimeInterval sectionTime = _time/_numberOfSections;
//
//    // Get the amount of width that will be taken off at each incrment
    CGFloat sectionWidth = CGRectGetWidth(_sections[0].frame);
    _incrementWidth = sectionWidth/(60*sectionTime);
    
    // Start the timer
    [_timer startTimer];
    
    self.state = SMWTimerBarViewStateAnimating;
}

- (void)step:(CGFloat)percentComplete {
    // Determine the currently animating section
    if (percentComplete == 0 || isnan(percentComplete)) {
        return;
    }
    double eachSectionPercent = 100.0/_sections.count;
    NSInteger index = floor(percentComplete/eachSectionPercent);
    NSInteger currentSectionIndex = _sections.count - (index + 1);
    if (currentSectionIndex < 0) {
        return;
    }
    SMWTimerBarSection *currentSection = _sections[currentSectionIndex];
    if (!_animatingSection || ![currentSection isEqual:_animatingSection]) {
        // New Section
        
        // Finish the last section
        [CATransaction smw_unanimateBlock:^{
            _animatingSection.timerLayer.frame = CGRectMake(CGRectGetMinX(_animatingSection.frame), CGRectGetMinY(_animatingSection.frame), 0, CGRectGetHeight(_animatingSection.frame));
        }];
        
        // Delegate
        if (_animatingSection && [_delegate respondsToSelector:@selector(timerBarView:didCountdownSection:)]) {
            [_delegate timerBarView:self didCountdownSection:currentSectionIndex+1];
        }
        self.animatingSection = currentSection;
        if ([_delegate respondsToSelector:@selector(timerBarView:willCountdownSection:)]) {
            [_delegate timerBarView:self willCountdownSection:currentSectionIndex];
        }
    }
    
    
    // Get the percent of that section
    double currentSectionPercent = (percentComplete-(eachSectionPercent*(index)))*_sections.count;
    
//    NSLog(@"section: %li, sectionPercent: %f, totalPercent: %f", (long)currentSectionIndex, currentSectionPercent, percentComplete);
    
    // Update the frame
    CGFloat sectionWidth = CGRectGetWidth(currentSection.frame);
    sectionWidth = sectionWidth-(sectionWidth*currentSectionPercent/100.0);
    [CATransaction smw_unanimateBlock:^{
        currentSection.timerLayer.frame = CGRectMake(CGRectGetMinX(currentSection.frame), CGRectGetMinY(currentSection.frame), sectionWidth, CGRectGetHeight(currentSection.frame));
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

- (void)fastForward:(CFTimeInterval)duration animated:(BOOL)animated {
    [_timer fastForward:duration animated:animated];
}

#pragma mark -
#pragma mark - Timer Delegate

- (void)displayLink:(SMWDisplayLink *)displayLink didCompleteAnimationWithDuration:(CFTimeInterval)duration {
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
