//
//  DroneCommunicator.h
//  ARDrone
//
//  Created by Jeason on 01/10/2014.
//  Copyright (c) 2014 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@class DroneNavigationState;

@interface DroneCommunicator : NSObject

- (void)setupDefaults;
- (void)sendString:(NSString*)string;
- (int)setConfigurationKey:(NSString *)key toString:(NSString *)string;
- (int)sendCommand:(NSString *)command arguments:(NSArray *)arguments;
- (void)sendRefCommand:(uint32_t)command;
- (void)sendPCommand:(NSArray*)arguments;

/// @a amount is clamped from -1 (backwards) to +1 (forward)
@property (nonatomic) double forwardSpeed;
/// @a amount is clamped from -1 (CCW) to +1 (CW)
@property (nonatomic) double rotationSpeed;

/// @a amount is clamped from -1 to + 1
@property (nonatomic) double verticalSpeed;

@property (nonatomic, strong, readonly) DroneNavigationState *navigationState;
@property (nonatomic, assign) confirmBlock datagramBlock;
@property (nonatomic) BOOL forceHover;

@property (nonatomic) BOOL isFlying;
@end
