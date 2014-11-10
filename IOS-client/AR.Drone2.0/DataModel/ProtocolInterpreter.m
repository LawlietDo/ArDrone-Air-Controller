//
//  ProtocolInterpreter.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-11-3.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "ProtocolInterpreter.h"
#import "Constant.h"
#import "DroneNavigationState.h"
#import "DroneCommunicator+Convenience.h"
#import "FunctionClass.h"
#import "Log.h"

@interface ProtocolInterpreter ()
@property (nonatomic, strong) DroneCommunicator *droneCommunicator;
@property (nonatomic, strong) ServerCommunicator *svrCommunicator;
@property (nonatomic, strong) NSString *packageId;
@end

@implementation ProtocolInterpreter

- (instancetype)init {
    self = [super init];
    __weak id weakSelf = self;
    if ( self ) {
        self.droneCommunicator = [[DroneCommunicator alloc] init];
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
    NSString *stateString = [NSString stringWithFormat:@"%d %d %lf %lf %lf %lf %lf %lf %lf %lf",
                             _droneCommunicator.navigationState.controlState,
                             _droneCommunicator.navigationState.batteryLevel,
                             _droneCommunicator.navigationState.pitch,
                             _droneCommunicator.navigationState.pitch,
                             _droneCommunicator.navigationState.roll,
                             _droneCommunicator.navigationState.yaw,
                             _droneCommunicator.navigationState.altitude,
                             _droneCommunicator.navigationState.speedX,
                             _droneCommunicator.navigationState.speedY,
                             _droneCommunicator.navigationState.speedZ
                             ];
    
    NSData *package = [FunctionClass generateSocketPacket:QueryState Identifier:self.packageId object:stateString, nil];
    [self.svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"Haha");
        }
    }];
}

- (void)processHeartBeat {
    NSData *package = [FunctionClass generateSocketPacket:HEARTBEAT Identifier:self.packageId object:nil];
    [self.svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"Response HeartBeat");
        }
    }];
}

- (void)processTakeoff {
    [_droneCommunicator takeoff];
    NSData *package = [FunctionClass generateSocketPacket:TakeOff Identifier:self.packageId object:@"success", nil];
    [_svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"TakeOff Success");
        }
    }];
}

- (void)processLand {
    [_droneCommunicator land];
    NSData *package = [FunctionClass generateSocketPacket:Land Identifier:self.packageId object:@"success", nil];
    [_svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"Land success");
        }
    }];
}

- (void)processHorver {
    [_droneCommunicator hover];
    NSData *package = [FunctionClass generateSocketPacket:Horver Identifier:self.packageId object:@"success", nil];
    [_svrCommunicator sendData:package ToServerWithCompletion:^(BOOL success, NSError *err) {
        if ( success ) {
            NSLog(@"Hover success");
        }
    }];

}

- (void)processFlyForWard:(NSArray *)argvs {
    NSString *speed = argvs[0];
    NSString *time = argvs[1];
    // TODO:
}

- (void)processArgChange:(NSArray *)argvs {
    NSString *argSpeed = argvs[0];
    NSString *time = argvs[1];
    //TODO:
    
}

- (void)processHeightChange:(NSArray *)argvs {
    NSString *heightChange = argvs[0];
    //TODO:
}
@end
