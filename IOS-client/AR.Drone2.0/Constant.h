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
    ServerPort = 9000
};

static NSString * const DroneAddress = @"192.168.1.1";
static NSString * const ServerAddress = @"115.29.202.247";
static uint32_t const magicHeaderValue = 0x55667788;
static NSUInteger const maxLength = 1024 * 8;


typedef void (^onReceiveBlock)( NSData *data, long tag );
typedef void (^confirmBlock)( BOOL success, NSError *err );

//////////////////////////Protocol Part //////////////////////////////
//#define VERSION 0x01
//static NSUInteger const versionIndex = 0;
//#define SERVER 0x01
//#define IPHONE 0x02
//static NSUInteger const clientTypeIndex = 1;
//#define CONNECT_PACKET 0x01
//#define OPERAND_PACKET 0x02
//#define STATE_PACKET 0x03
//static NSUInteger const packetTypeIndex = 2;
//#define SEND_HEART_BEAT 0x01
//#define RESPONSE_HEART_BEAT 0x60
//static NSUInteger const operandIndex = 3;
//#define SEND_DRONE_TAKEOFF 0x01
//#define SEND_DRONE_LAND 0x02
//#define RESPONSE_DRONE_TAKEOFF_SUCC 0x60
//#define RESPONSE_DRONE_TAKEOFF_FAIL 0x61
//#define RESPONSE_DRONE_LAND_SUCC 0x62
//#define RESPONSE_DRONE_LAND_FAIL 0x63
#define Br @" "
#define End @" "

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
