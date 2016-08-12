//
//  RLUncaughtExceptionHandler.h
//  Framework
//
//  Created by 郭炜 on 16/8/10.
//  Copyright © 2016年 郭炜. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RLUncaughtExceptionHandler : NSObject {
    BOOL dismissed;
}
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
@end
