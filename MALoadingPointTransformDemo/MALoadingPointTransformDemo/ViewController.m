//
//  ViewController.m
//  MALoadingPointTransformDemo
//
//  Created by hugengya on 2019/8/2.
//  Copyright © 2019 com.angryminiant. All rights reserved.
//

#import "ViewController.h"
#import <MALoading/MALoading.h>

@interface ViewController ()

@property (weak, nonatomic) MALoadPointMoveView *ptView;
@property (weak, nonatomic) UIImageView *imgView;
@property (weak, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger imgIndex;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat ksWidth = self.view.frame.size.width;
    
    // 图片切换
    self.imgIndex = 0;
    UIImageView *imgView = [UIImageView new];
    self.imgView = imgView;
    imgView.frame = CGRectMake(0, 0, 70, 12);
    imgView.center = CGPointMake(ksWidth * 0.5, 120);
    [self.view addSubview:imgView];
    
    
    // 开始动画
    UIButton *btnStart = [UIButton new];
    btnStart.backgroundColor = [UIColor redColor];
    btnStart.frame = CGRectMake(30, 280, 60, 40);
    [btnStart setTitle:@"start" forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(btnStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    
    // 结束动画
    UIButton *btnStop = [UIButton new];
    btnStop.backgroundColor = [UIColor blueColor];
    btnStop.frame = CGRectMake(ksWidth - 30 - 50, 280, 60, 40);
    [btnStop setTitle:@"stop" forState:UIControlStateNormal];
    [btnStop addTarget:self action:@selector(btnStopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStop];
    
}

- (void) btnStartAction:(UIButton *)sender  {
    
    // 自定义动画
    CGFloat ksWidth = self.view.frame.size.width;
    MALoadPointMoveView *ptView = [MALoadPointMoveView new];
    self.ptView = ptView;
    [self.view addSubview:ptView];
    [self.ptView loadColors:nil h:10];
    self.ptView.center = CGPointMake(ksWidth * 0.5, 100);
    
    [self.ptView startAnimating];
    
    
    self.imgIndex = 0;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.08 target:self selector:@selector(exchangImg) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}


- (void) btnStopAction:(UIButton *)sender  {
        
    [self.ptView stopAnimating];
    [self.ptView removeFromSuperview];
    self.ptView = nil;

    
    self.imgIndex = 0;
    [self.timer invalidate];
    self.timer = nil;
    self.imgView.image = nil;
}

- (void) exchangImg {
    
    self.imgIndex++;
    NSString *imgName = [NSString stringWithFormat:@"loading_frame%@", @(self.imgIndex % 21 + 1) ];
    self.imgView.image = [UIImage imageNamed:imgName];
}


@end
