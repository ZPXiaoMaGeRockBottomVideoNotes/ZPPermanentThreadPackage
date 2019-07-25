//
//  ZPPermanentThread.h
//  常驻线程的封装
//
//  Created by 赵鹏 on 2019/7/24.
//  Copyright © 2019 赵鹏. All rights reserved.
//

//本类是利用RunLoop创建了一个常驻线程，并且对创建过程进行了一个封装，便于以后的项目直接调用。相关的注释参考RunLoop Demo。

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZPPermanentTask)(void);

@interface ZPPermanentThread : NSObject

- (void)run;  //开启子线程
- (void)stop;  //结束子线程
- (void)executeTask:(ZPPermanentTask)task;  //在子线程中执行任务

@end

NS_ASSUME_NONNULL_END
