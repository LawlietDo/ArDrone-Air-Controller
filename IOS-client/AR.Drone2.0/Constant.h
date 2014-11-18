//
//  Constant.h
//  AR.Drone2.0
//
//  Created by Jeason on 14-10-10.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#ifndef AR_Drone2_0_Constant_h
#define AR_Drone2_0_Constant_h

static int const baseRefCommand = 0x11540000;
static int packetId = 0;

enum ports_e : int {
    NavigationDataPort = 5554,
    OnBoardVideoPort = 5555,
    ATCommandPort = 5556,
    ServerPort = 8080
};

static NSString * const DroneAddress = @"192.168.1.1";
static NSString * const ServerAddress = @"172.18.187.115";
static uint32_t const magicHeaderValue = 0x55667788;
static NSUInteger const maxLength = 1024 * 8;
static NSInteger const TCPSocketNotTimeOut = -1;

typedef void (^onReceiveBlock)( NSData *data, long tag );
typedef void (^confirmBlock)( BOOL success, NSError *err );

//////////////////////////Protocol Part //////////////////////////////
#define Br @" "
#define End @";"

static const NSUInteger packageIdIndex = 0;
static const NSUInteger commandIndex = 1;
static const NSUInteger argvsBeginIndex = 2;

#define HEARTBEAT @"HB"
#define QueryState @"QRS"
#define TakeOff @"TAO"
#define Land @"LAD"
#define Horver @"HOV"
#define FlyForward @"FLY"
#define ArgChange @"DIR"
#define HeightChange @"HEI"
#define Response @"RES"

////////////////////////Protocol End///////////////////////////////
#endif
