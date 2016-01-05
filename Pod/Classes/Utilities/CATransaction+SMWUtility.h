//
//  CATransaction+SMWUtility.h
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-05.
//
//

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (SMWUtility)

/**
 Wrap a block of code inside an unanimated transaction.
 @param The block to unanimate.
 */
+ (void)smw_unanimateBlock:(void(^)(void))block;

@end
