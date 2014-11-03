//
//  FunctionClass.m
//  Myproject
//
//  Created by JInbo on 14-3-22.
//  Copyright (c) 2014年 Myproject. All rights reserved.
//

#import "FunctionClass.h"
@implementation FunctionClass

+ (NSMutableData *)generateSocketPacket:(char)version clientType:(char)client packetType:(char)type operateCode:(char)code objects:(id)first,...;
{
    NSMutableData *packet = [[NSMutableData alloc] init];
    NSMutableData *body = [[NSMutableData alloc] init];
    
    if ([first isKindOfClass:[NSString class]]) {
        [body appendData:[first dataUsingEncoding:NSUTF8StringEncoding]];
    } else if ([first isKindOfClass:[NSData class]]) {
        [body appendData:first];
    } else {
    }
    id eachObject;
    va_list argumentList;
    if (first) // The first argument isn't part of the varargs list,
    {
        va_start(argumentList, first);
        while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
        {
            [body appendData:[@" " dataUsingEncoding:NSUTF8StringEncoding]];
            if ([eachObject isKindOfClass:[NSString class]]) {
                [body appendData:[eachObject dataUsingEncoding:NSUTF8StringEncoding]];
            } else if ([eachObject isKindOfClass:[NSData class]]){
                [body appendData:eachObject];
            }
        }
        va_end(argumentList);
    }
    [body appendData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]];
    int len = [body length];
    NSString *lenStr = [FunctionClass setLength:len];
    NSString *str = [NSMutableString stringWithFormat:@"%c%c%c%c%@",version,client,type,code,lenStr];
    [packet appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [packet appendData:body];
    return packet;
}

+(NSString *)setLength:(int)len{
    char s[5];
    sprintf(s, "%4d",len);
    if(len < 1000) s[0] = '0';
	if(len < 100) s[1] = '0';
	if(len < 10) s[2] = '0';
	if(len < 1) s[3] = '0';
    NSString *str = [[NSString alloc] initWithFormat:@"%c%c%c%c",s[0],s[1],
                     s[2],s[3] ];
    return str;
}

+(int)getIntFromChar:(char *)str length:(int)len
{
    int total = 0;
    for (int i = 0; i < len; i++)
    {
        total += (int)(str[i] - '0') * pow(10.0, len - i - 1);
    }
    return total;
}
@end
