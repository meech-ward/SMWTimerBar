//
//  SMWTimerBarSectionTests.m
//  SMWTimerBar
//
//  Created by Sam Meech Ward on 2016-01-04.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <SMWTimerBar/SMWTimerBarView.h>
#import <SMWTimerBar/SMWTimerBarSection.h>

SpecBegin(TimerBarSectionSetup)

describe(@"Timer bar section", ^{
    
    
    
    describe(@"when initialized", ^{
        
        __block SMWTimerBarSection *barSection;
        __block CGRect sectionFrame;
        __block SMWTimerBarView *barView;
        
        beforeAll(^{
            sectionFrame = CGRectMake(0, 0, 30.0, 10.0);
            barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection = [[SMWTimerBarSection alloc] initWithFrame:sectionFrame barView:barView];
        });
        
        it(@"will have the correct frame and bar view", ^{
            expect(barSection.barView).to.equal(barView);
            expect(barSection.frame).to.equal(sectionFrame);
        });
        
        it(@"will have initialized all layers", ^{
            expect(barSection.backgroundLayer).toNot.equal(nil);
            expect(barSection.timerLayer).toNot.equal(nil);
            expect(barSection.dividerLayer).toNot.equal(nil);
            expect(barSection.imageView).toNot.equal(nil);
        });
        
        it(@"will be a sublayer of bar", ^{
            expect(barSection.backgroundLayer.superlayer).to.equal(barView.layer);
            expect(barSection.timerLayer.superlayer).to.equal(barView.layer);
            expect(barSection.dividerLayer.superlayer).to.equal(barView.layer);
            expect(barSection.imageView.superview).to.equal(barView);
        });
        
    });
    
    describe(@"when removed", ^{
        
        __block SMWTimerBarSection *barSection;
        
        beforeAll(^{
            SMWTimerBarView *barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection = [[SMWTimerBarSection alloc] initWithFrame:CGRectMake(0, 0, 30.0, 10.0) barView:barView];
            [barSection removeFromBar];
        });
        
        it(@"will be a sublayer of no layer", ^{
            expect(barSection.backgroundLayer.superlayer).to.equal(nil);
            expect(barSection.timerLayer.superlayer).to.equal(nil);
            expect(barSection.dividerLayer.superlayer).to.equal(nil);
            expect(barSection.imageView.superview).to.equal(nil);
        });
    });
    
    describe(@"when reset", ^{
        
        __block SMWTimerBarSection *barSection1;
        __block SMWTimerBarSection *barSection2;
        
        
        beforeAll(^{
            // Create two identical bar sections
            SMWTimerBarView *barView = [[SMWTimerBarView alloc] initWithFrame:CGRectZero numberOfSections:3];
            barSection1 = [[SMWTimerBarSection alloc] initWithFrame:CGRectMake(10.0, 0, 30.0, 10.0) barView:barView];
            barSection2 = [[SMWTimerBarSection alloc] initWithFrame:CGRectMake(10.0, 0, 30.0, 10.0) barView:barView];
            
            // Modify all of the section 1 layers
            barSection1.timerLayer.frame = CGRectMake(1, 2, 3, 4);
            barSection1.backgroundLayer.frame = CGRectMake(5, 6, 7, 8);
            barSection1.dividerLayer.frame = CGRectMake(9, 1, 2, 3);
            barSection1.imageView.frame = CGRectMake(9, 1, 2, 3);
            
            // Reset section 1
            [barSection1 reset];
        });
        
        it(@"will have it's default frames", ^{
            expect(barSection1.timerLayer.frame).to.equal(barSection2.timerLayer.frame);
            expect(barSection1.backgroundLayer.frame).to.equal(barSection2.backgroundLayer.frame);
            expect(barSection1.dividerLayer.frame).to.equal(barSection2.dividerLayer.frame);
            expect(barSection1.imageView.frame).to.equal(barSection2.imageView.frame);
        });
        
    });
    
});

SpecEnd
