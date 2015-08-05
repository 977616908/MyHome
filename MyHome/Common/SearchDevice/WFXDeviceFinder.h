#import "Dispatcher.h"

// DeviceEcho表示进行内网发现时，设备反馈的信息
@interface DeviceEcho : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* hostIP;
@property (nonatomic, copy) NSString* macAddr;
@property (nonatomic, copy) NSString* token;
@property (nonatomic,assign) BOOL isConnect;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) BOOL locked;
@end

typedef void (^WFXDeviceFinderOneMatchHandler)(DeviceEcho* echo);
typedef void (^WFXDeviceFinderMultiMatchesHandler)(NSArray* echos);
typedef void (^WFXDeviceFinderMissedHandler)();
typedef void (^WFXDeviceFinderCompletionHandler)();

@interface WFXDeviceFinder : NSObject

// 构造一个WFXDeviceFinder实例，dispatcher用于确定搜索时使用的调度模型
- (instancetype)initWithDispatcher:(id<Dispatcher>)dispatcher;

// 该方法用于在当前网段搜寻具备某个MAC地址的设备
// 该功能一般用于自动登录。因为自动登录时为了避免错误登录到其它设备上，必须使用MAC地址进行设备区分
- (void)findDevicesWithMacAddr:(NSString*)macAddr
                       matched:(WFXDeviceFinderOneMatchHandler)match
                        missed:(WFXDeviceFinderMissedHandler)missed
                    completion:(WFXDeviceFinderCompletionHandler)completion;

// 该方法用于搜索当前网段中的所有WitFii设备
- (void)findAllDevicesMatched:(WFXDeviceFinderMultiMatchesHandler)matches
                       missed:(WFXDeviceFinderMissedHandler)missed
                   completion:(WFXDeviceFinderCompletionHandler)completion;
@end
