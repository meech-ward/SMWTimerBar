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

@interface SMWTimerBarView() {
    CGRect _lastFrame;
}

@property (strong, nonatomic) NSArray<SMWTimerBarSection *> *sections;

/// The timer used for the animations
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
    // Divide the time between the sections
    NSTimeInterval sectionTime = _time/_numberOfSections;
    
    // Get the amount of width that will be taken off at each incrment
    CGFloat sectionWidth = CGRectGetWidth(_sections[0].frame);
    CGFloat incrementWidth = sectionWidth/(60*sectionTime);
    
    // Start the timer
    self.timer = [[SMWDisplayLink alloc] initWithDuration:_time
                                            frameInterval:1
                                                stepBlock:^(CGFloat percentComplete) {
        
    }
                                             runLoopModes:@[NSDefaultRunLoopMode]];
    
    self.state = SMWTimerBarViewStateAnimating;
    [self animateSection:_numberOfSections-1 withTime:sectionTime];
}
- (void)increment {
    
}

- (void)pauseAnimations {
    for (SMWTimerBarSection *section in self.sections) {
        [section pauseAnimations];
    }
//    [_animatingSection pauseAnimations];
    self.state = SMWTimerBarViewStatePaused;
}

- (void)resumeAnimations {
//    [_animatingSection resumeAniamtions];
    for (SMWTimerBarSection *section in self.sections) {
        [section resumeAniamtions];
    }
    self.state = SMWTimerBarViewStateAnimating;
}

- (void)stopAnimations {
    // Stop the animations
    for (SMWTimerBarSection *section in self.sections) {
        [section stopAnimations];
    }
    
    // Cleanup
    self.state = SMWTimerBarViewStateNormal;
    self.animatingSection = nil;
}

- (void)animateSection:(NSInteger)sectionNumber withTime:(NSInteger)sectionTime {
    if (sectionNumber < 0) {
        // Completed all animation
        self.state = SMWTimerBarViewStateCompletedAnimation;
        
        self.animatingSection = nil;
        
        // Call the did countdown delegate
        if ([_delegate respondsToSelector:@selector(timerBarViewDidFinishCountdown:)]) {
            [_delegate timerBarViewDidFinishCountdown:self];
        }
        
        return;
    }
    
    self.animatingSection = self.sections[sectionNumber];
    
    // Call the will countdown delegate
    if ([_delegate respondsToSelector:@selector(timerBarView:willCountdownSection:)]) {
        [_delegate timerBarView:self willCountdownSection:sectionNumber];
    }
    
    NSString *const animationKey = @"timer_size_animation";
    
    // Get the section
    SMWTimerBarSection *section = _sections[sectionNumber];
    
    // Animate
    [section animateTimerLayerWithDuration:sectionTime key:animationKey completion:^(BOOL completed) {
        
        // Call the did countdown delegate
        if ([_delegate respondsToSelector:@selector(timerBarView:didCountdownSection:)]) {
            [_delegate timerBarView:self didCountdownSection:sectionNumber];
        }
        
        if (completed) {
            // Animate the next section
            [self animateSection:sectionNumber-1 withTime:sectionTime];
        }
    }];
}


@end
