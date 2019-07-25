//
//  ViewController.m
//  常驻线程的封装
//
//  Created by 赵鹏 on 2019/7/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ViewController.h"
#import "ZPPermanentThread.h"

@interface ViewController ()

@property (nonatomic, strong) ZPPermanentThread *thread;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.thread = [[ZPPermanentThread alloc] init];
    [self.thread run];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

#pragma mark ————— 点击“停止”按钮 —————
- (IBAction)stop:(id)sender
{
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
