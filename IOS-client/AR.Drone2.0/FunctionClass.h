//
//  FunctionClass.h
//  Myproject
//
//  Created by JInbo on 14-3-22.
//  Copyright (c) 2014年 Myproject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionClass : NSObject

+ (NSMutableData *)generateSocketPacket:(char)version clientType:(char)client packetType:(char)type operateCode:(char)code objects:(id)first,...;
+ (NSString *)setLength:(int)len;
@end
