//
//  CATransaction+SMWUtility.m
//  Pods
//
//  Created by Sam Meech Ward on 2016-01-05.
//
//

#import "CATransaction+SMWUtility.h"

@implementation CATransaction (SMWUtility)

+ (void)smw_unanimateBlock:(void(^)(void))block {
    [self begin];
    [self setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    block();
    [self commit];
}

@end
