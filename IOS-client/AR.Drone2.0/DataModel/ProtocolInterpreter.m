//
//  ProtocolInterpreter.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-11-3.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "ProtocolInterpreter.h"
#import "Constant.h"

@implementation ProtocolInterpreter

- (instancetype)init {
    self = [super init];
    if ( self ) {
        self.svrCommunicator = [[ServerCommunicator alloc] init];
        _svrCommunicator.receiveFilter = ^(NSData *receiveData, long tag) {
            char header[8] = {};
            [receiveData getBytes:&header range:NSMakeRange(0, 8)];
            if ( header[versionIndex] == VERSION && header[clientTypeIndex] == SERVER ) {
                switch (header[packetTypeIndex]) {
                    case CONNECT_PACKET:
                        
                        break;
                    case OPERAND_PACKET:
                        
                        break;
                        
                    case STATE_PACKET:
                        
                        break;
                        
                    default:
                        break;
                }
            }

        };
    }
    return self;
}

@end
