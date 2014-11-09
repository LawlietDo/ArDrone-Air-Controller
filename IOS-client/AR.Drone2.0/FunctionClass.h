//
//  FunctionClass.h
//  Myproject
//
//  Created by JInbo on 14-3-22.
//  Copyright (c) 2014年 Myproject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionClass : NSObject

+ (NSData *)generateSocketPacket:(NSString *)command Identifier:(NSString *)packageId object:(id)first,...;
@end
