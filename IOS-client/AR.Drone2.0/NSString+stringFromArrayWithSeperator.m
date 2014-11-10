//
//  NSString+stringFromArrayWithSeperator.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-11-3.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NSString+stringFromArrayWithSeperator.h"

@implementation NSString (stringFromArrayWithSeperator)

+ (NSString *)stringFromArray:(NSArray *)array WithSeperator:(NSString *)seperator {
    NSMutableString *result = [NSMutableString new];
    BOOL first = YES;
    for ( id eachObject in array ) {
        if ( [eachObject isKindOfClass:[NSString class]] ) {
            if ( first ) {
                first = NO;
                [result appendString:eachObject];
            } else {
                [result appendFormat:@" %@", eachObject];
            }
        }
    }
    return result;
}

@end
