//
//  ViewController.m
//  AR.Drone2.0
//
//  Created by Jeason on 14-9-28.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "ViewController.h"
#import "../DataModel/DroneCommunicator.h"
#import "../DataModel/ServerCommunicator.h"
#import "../DataModel/DroneCommunicator+Convenience.h"
#import "Constant.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) DroneCommunicator *droneCmtor;
@property (nonatomic, strong) ServerCommunicator *svrCmtor;
@property (nonatomic, strong) NSArray *argus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    aBtn.frame = CGRectMake(100, 30, 150, 100);
//    [self.view addSubview:aBtn];
//    [aBtn addTarget:self action:@selector(onCLickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [aBtn setTitle:@"按一下，飞起来" forState:UIControlStateNormal];
//    [aBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    
//    UIButton *bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    bBtn.frame = CGRectMake(100, 200, 150, 100);
//    [self.view addSubview:bBtn];
//    [bBtn addTarget:self action:@selector(onCLickBBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bBtn setTitle:@"按一下，降下来" forState:UIControlStateNormal];
//    [bBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    
//    CGRect moveBtnFrame = aBtn.frame;
//    moveBtnFrame.origin.y += 100;
//    UIButton *moveBtn = [[UIButton alloc] initWithFrame:moveBtnFrame];
//    [moveBtn addTarget:self action:@selector(onClickMoveBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [moveBtn setTitle:@"Move" forState:UIControlStateNormal];
//    [moveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.view addSubview:moveBtn];
//    
//    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cBtn.frame = CGRectMake(100, 400, 150, 100);
//    [self.view addSubview:cBtn];
//    [cBtn addTarget:self action:@selector(onCLickCBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [cBtn setTitle:@"按一下，停着" forState:UIControlStateNormal];
//    [cBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    startBtn.frame = CGRectMake(100, 50, 88, 88);
    [startBtn setTitle:@"起飞" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(onClickStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];

    UIButton *landBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [landBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    landBtn.frame = CGRectMake(100, 140, 88, 88);
    [landBtn setTitle:@"降落" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(onClickLand:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];

    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    forwardBtn.frame = CGRectMake(100, 230, 88, 88);
    [forwardBtn setTitle:@"前" forState:UIControlStateNormal];
    [forwardBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(onClickForward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(100, 400, 88, 88);
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];

    [backBtn setTitle:@"后" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onCLickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];

    leftBtn.frame = CGRectMake(12, 318, 88, 88);
    [leftBtn setTitle:@"左" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(onCLickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(190, 318, 88, 88);
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];

    [rightBtn setTitle:@"右" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onCLickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

    
    self.droneCmtor = [DroneCommunicator new];
    self.svrCmtor = [ServerCommunicator new];
    self.svrCmtor.receiveFilter = ^(NSData *receiveData, long tag) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCLickBtn:(UIButton *)sender {
    [_droneCmtor takeoff];
}

- (void)onCLickBBtn:(UIButton *)sender {
    [_droneCmtor land];
}

- (void)onCLickCBtn:(UIButton *)sender {
    [_droneCmtor hover];
    self.argus = nil;
}

- (void)processConnectionData:(NSData *)receiveData WithTag:(long)tag {
    
}
- (void)onClickStart:(id)sender {
    [_droneCmtor takeoff];
}

- (void)onClickLand:(id)sender {
    [_droneCmtor land];
}
-(void) onClickForward : (id)sender {
    self.argus = @[@"7",@"0", @"0", @"0", @"0"];
    [_droneCmtor sendPCommand:_argus];
    _droneCmtor.forceHover = NO;
    _droneCmtor.rotationSpeed = 0;
    _droneCmtor.forwardSpeed = -0.5;
    _droneCmtor.isFlying = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendRepeatPCommand:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
}

- (void)onCLickBack:(id)sender {
    self.argus = @[@"7",@"0", @"0", @"0", @"0"];
    [_droneCmtor sendPCommand:_argus];
    _droneCmtor.forceHover = NO;
    _droneCmtor.rotationSpeed = 0;
    _droneCmtor.forwardSpeed = 0.5;
    _droneCmtor.isFlying = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendRepeatPCommand:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
}

- (void)onCLickLeft:(id)sender {
    self.argus = @[@"7",@"0", @"0", @"0", @"0"];
    [_droneCmtor sendPCommand:_argus];
    _droneCmtor.forceHover = NO;
    _droneCmtor.rotationSpeed = 0.5;
    _droneCmtor.forwardSpeed = 0;
    _droneCmtor.isFlying = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendRepeatPCommand:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
}
- (void)onCLickRight:(id)sender {
    self.argus = @[@"7",@"0", @"0", @"0", @"0"];
    [_droneCmtor sendPCommand:_argus];
    _droneCmtor.forceHover = NO;
    _droneCmtor.rotationSpeed = -0.5;
    _droneCmtor.forwardSpeed = 0;
    _droneCmtor.isFlying = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendRepeatPCommand:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *inputText = textField.text;
    NSMutableArray *argus = [[inputText componentsSeparatedByString:@" "] mutableCopy];
    NSString *duration = [argus lastObject];
    [argus removeLastObject];
    [_droneCmtor sendPCommand:argus];
    [NSTimer scheduledTimerWithTimeInterval:[duration doubleValue] target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
    return YES;
}

- (void)onClickMoveBtn:(UIButton *)sender {
    self.argus = @[@"7",@"0", @"0", @"0", @"0"];
    [_droneCmtor sendPCommand:_argus];
    _droneCmtor.forceHover = NO;
    _droneCmtor.rotationSpeed = 0;
    _droneCmtor.forwardSpeed = -0.5;
    _droneCmtor.isFlying = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendRepeatPCommand:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onCLickCBtn:) userInfo:nil repeats:NO];
}

- (void)sendRepeatPCommand:(NSTimer *)aTimer {
    if ( self.argus ) {
        [_droneCmtor sendPCommand:_argus];
    } else {
        [aTimer invalidate];
    }
}

@end
