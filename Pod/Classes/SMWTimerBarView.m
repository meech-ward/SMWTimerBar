//
//  SMWTimerBarView.m
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-04.
//
//

#import "SMWTimerBarView.h"

#import "SMWTimerBarSection.h"

@interface SMWTimerBarView() {
    CGRect _lastFrame;
}

@property (strong, nonatomic) NSArray<SMWTimerBarSection *> *sections;

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
    
    [self animateSection:_numberOfSections-1 withTime:sectionTime];
}

- (void)animateSection:(NSInteger)sectionNumber withTime:(NSInteger)sectionTime {
    if (sectionNumber < 0) {
        // Completed all animation
        [self reset];
        return;
    }
    
    // Get the section
    SMWTimerBarSection *section = _sections[sectionNumber];
    
    // Animate
    [CATransaction begin];
    [CATransaction setAnimationDuration:sectionTime];
    [CATransaction setCompletionBlock:^{
        CABasicAnimation *layerSizeAnimation = (CABasicAnimation *)[section.timerLayer animationForKey:@"timer_size_animation"];
        section.timerLayer.bounds = [layerSizeAnimation.toValue CGRectValue];
        [section.timerLayer removeAnimationForKey:@"timer_size_animation"];
        [self animateSection:sectionNumber-1 withTime:sectionTime];
    }];
    
    [self addTimerAnimationToSection:section];
    
    [CATransaction commit];
}

- (void)addTimerAnimationToSection:(SMWTimerBarSection *)section {
    
    CABasicAnimation *layerSizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    layerSizeAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(section.frame), CGRectGetHeight(section.frame))];
    layerSizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, CGRectGetHeight(section.frame))];
    
    layerSizeAnimation.removedOnCompletion = NO;
    layerSizeAnimation.fillMode = kCAFillModeBoth;
    
    [section.timerLayer addAnimation:layerSizeAnimation forKey:@"timer_size_animation"];
}

@end
