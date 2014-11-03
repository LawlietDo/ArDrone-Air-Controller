//
//  DatagramSocket.h
//  ARDrone
//
//  Created by Jeason on 28/09/2014.
//  Copyright (c) 2014 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DatagramSocketReceiveDelegate;

/// Simple wrapper around UDP socket
@interface DatagramSocket : NSObject

+ (instancetype)ipv4socketWithAddress:(NSString *)address port:(int)port error:(NSError **)error;
+ (instancetype)ipv4socketWithAddress:(NSString *)address port:(int)port receiveDelegate:(id<DatagramSocketReceiveDelegate>)receiveDelegate receiveQueue:(NSOperationQueue *)receiveQueue error:(NSError **)error;

@property (readonly, nonatomic, copy) NSString *address;
@property (readonly, nonatomic) int port;

- (void)asynchronouslySendData:(NSData *)data;

@end

@protocol DatagramSocketReceiveDelegate <NSObject>

- (void)datagramSocket:(DatagramSocket *)datagramSocket didReceiveData:(NSData *)data;

@end