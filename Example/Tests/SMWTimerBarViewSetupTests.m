//
//  SMWTimerBarViewTests.m
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-04.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//
#import <Specta/Specta.h> 
#import <Expecta/Expecta.h>
#import <SMWTimerBar/SMWTimerBar.h>
#import <SMWTimerBar/SMWTimerBarSection.h>

SpecBegin(TimerBarViewSetup)

describe(@"Timer bar view", ^{
    
    describe(@"when initialized", ^{
        
        __block SMWTimerBarView *barView;
        const int numberOfBarSections = 3;
        __block CGRect barFrame;
        
        beforeAll(^{
            barFrame = CGRectMake(0.0, 0.0, 300.0, 50.0);
            barView = [[SMWTimerBarView alloc] initWithFrame:barFrame numberOfSections:numberOfBarSections];
        });
        
        it(@"will have the correct number of sections", ^{
            expect(barView.numberOfSections).to.equal(numberOfBarSections);
            expect(barView.sections.count).to.equal(numberOfBarSections);
        });
        
        it(@"will have the correct section sizes", ^{
            CGFloat sectionX = 0;
            CGFloat sectionWidth = CGRectGetWidth(barFrame)/numberOfBarSections;
            
            for (SMWTimerBarSection *section in barView.sections) {
                CGRect sectionFrame = CGRectMake(sectionX, 0, sectionWidth, CGRectGetHeight(barFrame));
                expect(section.frame).to.equal(sectionFrame);
                sectionX+=sectionWidth;
            }
        });
        
    });
    
    describe(@"when setting the number of sections", ^{
        __block SMWTimerBarView *barView;
        const int numberOfBarSections = 10;
        __block CGRect barFrame;
        
        beforeAll(^{
            barFrame = CGRectZero;
            barView = [[SMWTimerBarView alloc] init];
            barView.numberOfSections = numberOfBarSections;
        });
        
        it(@"will have the correct number of sections", ^{
            expect(barView.numberOfSections).to.equal(numberOfBarSections);
            expect(barView.sections.count).to.equal(numberOfBarSections);
        });
    });
    
    describe(@"when updating appearance", ^{
        
        __block SMWTimerBarView *barView;
        const int numberOfBarSections = 5;
        
        beforeAll(^{
            barView = [[SMWTimerBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 50.0) numberOfSections:numberOfBarSections];
        });
        
        describe(@"when updating background colors with the same number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor blueColor], [UIColor redColor], [UIColor blackColor], [UIColor greenColor], [UIColor grayColor]];
                barView.backgroundColors = colors;
            });
            
            it(@"will have each section with the same correct background color", ^{
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[i];
                    expect(section.backgroundLayer.backgroundColor).to.equal(color.CGColor);
                }
            });
        });
        
        describe(@"when updating background colors with a smaller number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor blueColor], [UIColor redColor], [UIColor blackColor]];
                barView.backgroundColors = colors;
            });
            
            it(@"will carousell through the colors to add to sections", ^{
                int colorIndex = 0;
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[colorIndex];
                    expect(section.backgroundLayer.backgroundColor).to.equal(color.CGColor);
                    colorIndex = colorIndex >= colors.count-1 ? 0 : colorIndex+1;
                }
            });
        });
        
        
        
        
        describe(@"when updating foreground colors with the same number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor orangeColor], [UIColor magentaColor], [UIColor blackColor], [UIColor greenColor], [UIColor grayColor]];
                barView.timerColors = colors;
            });
            
            it(@"will have each section with the same correct background color", ^{
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[i];
                    expect(section.timerLayer.backgroundColor).to.equal(color.CGColor);
                }
            });
        });
        
        describe(@"when updating foreground colors with a smaller number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor orangeColor], [UIColor redColor], [UIColor cyanColor]];
                barView.timerColors = colors;
            });
            
            it(@"will carousell through the colors to add to sections", ^{
                int colorIndex = 0;
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[colorIndex];
                    expect(section.timerLayer.backgroundColor).to.equal(color.CGColor);
                    colorIndex = colorIndex >= colors.count-1 ? 0 : colorIndex+1;
                }
            });
        });
        
        
        
        
        describe(@"when updating divider colors with the same number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor orangeColor], [UIColor magentaColor], [UIColor whiteColor], [UIColor blueColor], [UIColor grayColor]];
                barView.dividerColors = colors;
            });
            
            it(@"will have each section with the same correct background color", ^{
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[i];
                    expect(section.dividerLayer.backgroundColor).to.equal(color.CGColor);
                }
            });
        });
        
        describe(@"when updating divider colors with a smaller number of sections", ^{
            
            __block NSArray<UIColor *> *colors;
            
            beforeAll(^{
                colors = @[[UIColor redColor], [UIColor blackColor]];
                barView.dividerColors = colors;
            });
            
            it(@"will carousell through the colors to add to sections", ^{
                int colorIndex = 0;
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIColor *color = colors[colorIndex];
                    expect(section.dividerLayer.backgroundColor).to.equal(color.CGColor);
                    colorIndex = colorIndex >= colors.count-1 ? 0 : colorIndex+1;
                }
            });
        });
        
        
        describe(@"when updating images with the same number of sections", ^{
            
            __block NSArray<UIImage *> *images;
            
            beforeAll(^{
                images = @[[UIImage imageNamed:@"star-circle"], [UIImage imageNamed:@"star-outline"], [UIImage imageNamed:@"star-half"], [UIImage imageNamed:@"star-outline"], [UIImage imageNamed:@"star-circle"]];
                barView.images = images;
            });
            
            it(@"will have each section with the same correct image", ^{
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIImage *image = images[i];
                    expect(section.imageView.image).to.equal(image);
                }
            });
        });
        
        describe(@"when updating images with a smaller number of sections", ^{
            
            __block NSArray<UIImage *> *images;
            
            beforeAll(^{
                images = @[[UIImage imageNamed:@"star-circle"], [UIImage imageNamed:@"star-outline"]];
                barView.images = images;
            });
            
            it(@"will carousell through the images to add to sections", ^{
                int imageIndex = 0;
                for (int i = 0; i < numberOfBarSections; ++i) {
                    SMWTimerBarSection *section = barView.sections[i];
                    UIImage *image = images[imageIndex];
                    expect(section.imageView.image).to.equal(image);
                    imageIndex = imageIndex >= images.count-1 ? 0 : imageIndex+1;
                }
            });
        });

    });
    
});

describe(@"these will pass", ^{
    
    
    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd
