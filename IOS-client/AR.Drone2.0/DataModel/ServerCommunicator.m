//
//  ServerCommunicator.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-10-10.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "ServerCommunicator.h"
#import "GCDAsyncSocket.h"
#import "Log.h"
#import "Constant.h"
#import "FunctionClass.h"

@interface ServerCommunicator () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *svrSock;
@property (nonatomic,readwrite, getter=isConnected) BOOL connected;
@property (nonatomic, strong) confirmBlock aBlock;
@property (nonatomic) long taskTag;

@end

@implementation ServerCommunicator

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.svrSock = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                  delegateQueue:dispatch_get_main_queue()];
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults
{
    self.receiveFilter = nil;
    self.connected = NO;
    self.taskTag = 0;
    [self connectToServer:ServerAddress
                   OnPort:ServerPort
           WithCompletion:^(BOOL success, NSError *err) {
        if ( !err ) {
            NSLog(@"Connect Success!");
        } else {
            NSLog(@"Connect To : %@:%d Error: %@", ServerAddress, ServerPort, [err description]);
        }
    }];
}

- (void)connectToServer:(NSString *)ip
                 OnPort:(int)port
         WithCompletion:(confirmBlock)handler;
{
    self.aBlock = handler;
    NSError *error;
    if ( ![_svrSock connectToHost:ip onPort:port error:&error] ) {
        NSLog(@"Connection fail for error config : %@", error);
        _aBlock( NO, error );
    }
}

- (void)startHeartBeat {
    [self.delegate sendHeartBeat];
}

- (BOOL)sendData:(NSData *)data ToServerWithCompletion:(confirmBlock)completion {
    [_svrSock writeData:data withTimeout:TCPSocketNotTimeOut tag:_taskTag];
    self.taskTag++;
    return YES;
}

#pragma mark -GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
{
    NSLog(@"DisConnectWithError:%@", err);
    self.connected = NO;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"Connect Success!");
    [self startHeartBeat];
    [sock readDataToLength:maxLength withTimeout:TCPSocketNotTimeOut tag:_taskTag];
    self.connected = YES;
    _aBlock( YES, nil );
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Receive: %@", aStr);
    _receiveFilter( data, tag );
    _taskTag++;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"Write Success, tell the server");
}

@end
