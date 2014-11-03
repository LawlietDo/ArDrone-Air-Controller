//
//  DroneCommunicator+Convenience.h
//  AR.Drone2.0
//
//  Created by Jeason on 14-10-10.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "DroneCommunicator.h"
//extern int const baseRefCommand;

@interface DroneCommunicator (Convenience)

- (void)resetEmergency;
- (void)takeoff;
- (void)land;
- (void)hover;

@end