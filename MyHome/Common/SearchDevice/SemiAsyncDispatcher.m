#import "SemiAsyncDispatcher.h"

@implementation SemiAsyncDispatcher
- (void)dispatchToDefaultQueueWithActionBlock:(void (^)(void))aBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), aBlock);
}

- (void)dispatchToMainQueueWithActionBlock:(void (^)(void))aBlock {
    dispatch_async(dispatch_get_main_queue(), aBlock);
}

- (void)dispatchWithBehaviorAction:(void (^)(void))behaviorAction notifyAction:(void (^)(void))notify {
    [self dispatchToDefaultQueueWithActionBlock:^{
        behaviorAction();
        [self dispatchToMainQueueWithActionBlock:notify];
    }];
}
@end