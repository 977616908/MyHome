@protocol Dispatcher <NSObject>
- (void)dispatchToDefaultQueueWithActionBlock:(void (^)(void))aBlock;
- (void)dispatchToMainQueueWithActionBlock:(void (^)(void))aBlock;
- (void)dispatchWithBehaviorAction:(void (^)(void))behaviorAction notifyAction:(void (^)(void))notify;
@end
