//
//  ProtocolInterpreter.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-11-3.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "ProtocolInterpreter.h"
#import "Constant.h"
#import "DroneCommunicator+Convenience.h"
#import "FunctionClass.h"

@interface ProtocolInterpreter ()

@property (nonatomic, strong) ServerCommunicator *svrCommunicator;
@property (nonatomic, strong) NSString *packageId;
@end

@implementation ProtocolInterpreter

- (instancetype)init {
    self = [super init];
    __weak id weakSelf = self;
    if ( self ) {
        self.svrCommunicator = [[ServerCommunicator alloc] init];
        _svrCommunicator.receiveFilter = ^(NSData *receiveData, long tag) {
            NSString *messages = [[NSString alloc] initWithData:receiveData encoding:NSASCIIStringEncoding];
            NSArray *messagesArray = [messages componentsSeparatedByString:End];
            for ( NSString *msg in messagesArray ) {
                NSArray *argvs = [msg componentsSeparatedByString:Br];
                NSString *packageId = argvs[packageIdIndex];
                [weakSelf setPackageId:packageId];
                NSString *command = argvs[commandIndex];
                NSUInteger commandArgvsLen = [argvs count] - argvsBeginIndex - 1;
                NSArray *commandRecvArgvs = [argvs subarrayWithRange:NSMakeRange(argvsBeginIndex, commandArgvsLen)];
                if ( [commandRecvArgvs count] != [[argvs lastObject] unsignedIntegerValue] ) {
                    return; //校验失败
                }
                if ( [command isEqualToString:HEARTBEAT] ) {
                    [weakSelf processHeartBeat];
                } else if ( [command isEqualToString:QueryState] ) {
                    [weakSelf processStateQuery];
                } else if ( [command isEqualToString:TakeOff] ) {
                    [weakSelf processTakeoff];
                } else if ( [command isEqualToString:Land] ) {
                    [weakSelf processLand];
                } else if ( [command isEqualToString:Horver] ) {
                    [weakSelf processHorver];
                } else if ( [command isEqualToString:FlyForward] ) {
                    [weakSelf processFlyForWard: commandRecvArgvs];
                } else if ( [command isEqualToString:ArgChange] ) {
                    [weakSelf processArgChange:commandRecvArgvs];
                } else if ( [command isEqualToString:HeightChange] ) {
                    [weakSelf processHeightChange:commandRecvArgvs];
                } else {
                    NSLog(@"Error command: %@", command);
                }
            }
        };
    }
    return self;
}

- (void)processStateQuery {
    NSData *package = [FunctionClass generateSocketPacket:QueryState Identifier:self.packageId object:nil];
    [self.svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"Haha");
        }
    }];
}

- (void)processHeartBeat {
}

- (void)processTakeoff {
    
}

- (void)processLand {
    
}

- (void)processHorver {
    
}

- (void)processFlyForWard:(NSArray *)argvs {
    
}

- (void)processArgChange:(NSArray *)argvs {
    
}

- (void)processHeightChange:(NSArray *)argvs {
    
}
@end
