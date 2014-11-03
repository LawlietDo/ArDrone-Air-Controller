//
//  DroneCommunicator+Convenience.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-10-10.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "DroneCommunicator+Convenience.h"
#import "Constant.h"
@implementation DroneCommunicator (Convenience)

- (void)takeoff;
{
    self.isFlying = YES;
    self.forceHover = YES;
    [self sendRefCommand:baseRefCommand | (1<<9)];
}

- (void)land;
{
    self.isFlying = NO;
    [self sendRefCommand:baseRefCommand];
}

- (void)hover;
{
    self.forwardSpeed = 0;
    self.rotationSpeed = 0;
    self.forceHover = YES;
}

- (void)resetEmergency
{
    self.isFlying = NO;
    [self sendRefCommand:baseRefCommand|(1<<8)];
}


@end
