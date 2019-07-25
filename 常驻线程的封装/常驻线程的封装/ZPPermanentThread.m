//
//  ZPPermanentThread.m
//  常驻线程的封装
//
//  Created by 赵鹏 on 2019/7/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPermanentThread.h"

@interface ZPThread : NSThread

@end

@implementation ZPThread

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end

@interface ZPPermanentThread ()

@property (nonatomic, strong) ZPThread *innerThread;
@property (nonatomic, assign) BOOL isStop;

@end

@implementation ZPPermanentThread

- (instancetype)init
{
    if (self = [super init])
    {
        self.isStop = NO;
        
        __weak typeof(self) weakSelf = self;
        
        self.innerThread = [[ZPThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.isStop)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    
    return self;
}

#pragma mark ————— 开启子线程 —————
- (void)run
{
    [self.innerThread start];
}

#pragma mark ————— 结束子线程 —————
- (void)stop
{
    if (self.innerThread)
    {
        [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
    }else
    {
        return;
    }
}

#pragma mark ————— 在子线程中执行任务 —————
- (void)executeTask:(ZPPermanentTask)task
{
    if (!self.innerThread || !task)
    {
        return;
    }else
    {
        [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
    }
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark ————— 私有方法 —————
- (void)__stop
{
    self.isStop = YES;
    
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.innerThread = nil;
}

- (void)__executeTask:(ZPPermanentTask)task
{
    task();
}

@end
