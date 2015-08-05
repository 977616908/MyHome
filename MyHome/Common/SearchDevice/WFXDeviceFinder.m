#import <SystemConfiguration/CaptiveNetwork.h>
#import "WFXDeviceFinder.h"
#import "BasicTerms.h"
#include <arpa/inet.h>
#include <ifaddrs.h>

// Set to 0 When No Logs Needed
#define Finder 1

@implementation DeviceEcho {
    NSUInteger descHash; // 使用成员缓存hash值，避免反复计算耗费CPU资源
}
@synthesize name, hostIP, macAddr, token, version;

- (id)initWithName:(NSString*)aName
            hostIP:(NSString*)host
               mac:(NSString*)mac
             token:(NSString*)aToken
           version:(NSInteger)verNum
{
    if (self = [super init]) {
        name        = aName;
        hostIP      = host;
        macAddr     = mac;
        token       = aToken;
        version     = verNum;
        descHash    = [self.description hash];
    }
    return self;
}

- (BOOL)isEqual:(DeviceEcho*)anotherEcho {
    return [self.macAddr isEqualToString:anotherEcho.macAddr] && anotherEcho.locked==self.locked;
}

- (NSUInteger)hash {
    // 为了支持NSSet进行去重，必须提供hash值，用以区分不同的Echo对象
    return descHash;
}

- (BOOL)locked {
    return self.token==nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<RouterEcho ssid:%@ host:%@ mac:%@ token:%@ ver:%d>",
            name, hostIP, macAddr, token, version];
}
@end

typedef NSArray* (^SeiveDevices)(NSArray* devicesInput);

@implementation WFXDeviceFinder {
    // 使用不同的Dispatcher可以支持不同的线程调度模型
    id<Dispatcher> dispatcher;

    int sock;
    struct sockaddr_in addr;
    NSString* broadcastAddr;
    
    void (^toCloseIt)();
}

- (instancetype)init {
    [[NSException exceptionWithName:@"NotSurpportedMethod"
                             reason:@"init is not available for WFXDeviceFinder, plz use initwithDispatcher: instead"
                           userInfo:nil] raise];
    
    return nil;
}

- (id)initWithDispatcher:(id<Dispatcher>)aDispatcher {
    if (self = [super init]) {
        dispatcher = aDispatcher;
        [self configureBroadcastAddr];
    }
    return self;
}

- (void)openSocket {
    sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sock<=0) {
        DebugOnly(Markdown(Finder, @"Failed: Could not create socket"));
    }
}

- (void)locateBroadcastAddr {
	struct ifaddrs *interfaces, *interface;
    
	BOOL success = (getifaddrs(&interfaces)==0);
	if (success)
	{
		interface = interfaces;
		while(interface != NULL)
		{
			if(strncmp(interface->ifa_name, "en", 2)==0 && interface->ifa_addr->sa_family == AF_INET )
			{
                broadcastAddr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)interface->ifa_dstaddr)->sin_addr)];
                break;
			}
			
			interface = interface->ifa_next;
		}
	}
	
	freeifaddrs(interfaces);
}

- (void)open {
    DebugOnly(Markdown(Finder, @"open"));

    [self openSocket];
    [self enalbeBroadcast];
    [self locateBroadcastAddr];
    
    int socketDescriptor = sock;
    toCloseIt = ^{ close(socketDescriptor); };
}

- (void)close {
    DebugOnly(Markdown(Finder, @"close"));
    
    toCloseIt();
    // 为了避免重复执行close方法，在第一次执行以后，将toCloseIt替换成Nope操作。这样，后续的close将什么都不会触发
    toCloseIt = ^{};
}

- (void)enalbeBroadcast {
    int enabling=1;
    int failed=setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &enabling, sizeof(enabling));
    if (failed) {
        DebugOnly(Markdown(Finder, @"Failed: Couldn't enable broadcasting mode"));
        [self close];
    }
}

- (void)configureBroadcastAddr {
    memset(&addr, 0, sizeof(addr));
    
    addr.sin_family = AF_INET;
    
    // 使用广播地址，这样UDP数据包就会在局域网内进行广播
    inet_pton(AF_INET, "255.255.255.255", &addr.sin_addr);
    
    const int BroadcastingPort = 8889;
    addr.sin_port = htons(BroadcastingPort);
}

- (void)sendSearchings {
    DebugOnly(Markdown(Finder, @"Send Searchings"));
    
    NSString* request = [NSString stringWithFormat:@"{\"cmd\":1, \"broadcast\":\"%@\", \"client\":\"ios\"}", broadcastAddr];
    
    PSLog(@"%@",request);
    BOOL (^sendSeekingPackage)() = ^{
        int bytesSended = sendto(sock, [request UTF8String], strlen([request UTF8String]), 0, (struct sockaddr*)&addr, sizeof(addr));
        return (BOOL)(bytesSended>0);
    };
    
    // 该循环会持续执行，除非其它地方调用了close方法，从而导致sento调用失败，继而终止该循环的执行
    while (sendSeekingPackage()) {
        // 过多的广播请求‘有可能’会使得设备负担过重，所以如果发现有此问题，应调整该值
        // 1  <- 最低的设备负担，有较大可能导致数据包丢失，从而遗失内网中的设备
        // 10 <- 比较平衡的数值，既不会导致过大的设备负担，也能降低遗失设备的问题
        // 50 <- 较高的设备负担，但设备遗失率极低
        const CGFloat SeekingsPerSecond = 10;
        usleep((useconds_t)(1.0f / SeekingsPerSecond * (CGFloat)USEC_PER_SEC));
    }
}

- (NSInteger)versionNumberFromString:(NSString*)plainVersion
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"r(\\d+)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    __block NSInteger version = 0;
    
    [regex enumerateMatchesInString:plainVersion
                            options:0
                              range:NSMakeRange(0, plainVersion.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSString* verStr = [plainVersion substringWithRange:[result rangeAtIndex:1]];
                             version = [verStr integerValue];
                         }];
    
    return version;
}

- (void)seekOneEchoResponsed:(WFXDeviceFinderOneMatchHandler)found
                      missed:(WFXDeviceFinderMissedHandler)missed
{
    struct sockaddr_storage addrStg = {0};
    socklen_t               addrStgLen = sizeof(addrStg);
    char                    buffer[1024];

    ssize_t bytesRead = recvfrom(sock,
                                 buffer,
                                 sizeof(buffer),
                                 0,
                                 (struct sockaddr *)&addrStg,
                                 &addrStgLen);

    bool broken = bytesRead<=0;
    if (broken) {
        missed();
    } else {
        // 添加\0结束符，使buffer成为可被合法使用的C字符串
        buffer[bytesRead] = 0;
        
        // 转换过程如下
        // C字符串 -> OBJC字符串 -> NSData对象 -> NSDictionary代表的JSON属性字典
        NSString* response = [NSString stringWithUTF8String:buffer];
        NSData* responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:&error];
        
        NSString* version = jsonObj[@"version"];
        
        // 在某些特殊的情况下，json转换可能会失败，例如2014.3.25日，后台在返回内网发现包时，错误地使用了如下格式：
        // { "ssid": "WitFii_DEMO03", "ipaddr": "192.168.1.121", "macaddr": "00:0c:43:76:20:77", "version": "r39762", "access": "wan", "model", "wMobile"}
        // 最后的key:"model" 和 value:"wMobile"之间，使用了逗号，而不是标准的冒号，所以导致解析失败
        // 虽然是后台的问题，但为了避免iOS前端Crash，这里对其进行了宽松的‘容错’处理
        if (jsonObj && version) {
            if (jsonObj==nil) {
                DebugOnly(Markdown(Finder, @"%@", ([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding])));
            }

            DeviceEcho* echo = [[DeviceEcho alloc] initWithName:jsonObj[@"ssid"]
                                                         hostIP:jsonObj[@"ipaddr"]
                                                            mac:[jsonObj[@"macaddr"] lowercaseString]
                                                          token:jsonObj[@"token"]
                                                        version:[self versionNumberFromString:version]];
            found(echo);
        }
    }
}

- (NSArray*)recvResponses {
    __block BOOL continueSeeking = YES;

    // NSSet, NSMutableSet都支持自动去重功能。这样多次搜寻时，它就可以进行echos的自动去重了
    NSMutableSet* routers = [[NSMutableSet alloc] init];
    while (continueSeeking) {
        [self seekOneEchoResponsed:^(DeviceEcho *anEcho) { [routers addObject:anEcho]; }
                           missed:^{ continueSeeking = NO; }];
    }
    
    DebugOnly(Markdown(Finder, @"Routers in LAN:%@", routers));
    return [routers allObjects];
}


- (void)findDevicesWithSeive:(SeiveDevices)seive
                     remains:(void (^)(NSArray *))remains
                      missed:(WFXDeviceFinderMissedHandler)missed
                  completion:(WFXDeviceFinderCompletionHandler)completion
{
    // 只有在准备好sockets资源后，才能正常进行网络通信
    [self open];
    
    // 搜索过程最起码需要使用3个线程才能正常工作
    // 1号线程线程负责循环发送搜寻广播包，2号线程则循环接收设备反馈的广播包，3号线程则应该在1秒钟后手动关闭用于
    // 发送、接收数据的套接字，从而结束1、2号线程的工作循环。这三个工作必须是在独立的线程中完成的。
    
    // 创建一个异步GCD队列，使得上面所描述的三个工作可以在不同的线程中完成
    dispatch_queue_t queue1st = dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2nd = dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3rd = dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT);

    __block NSArray* devices = @[];
    dispatch_semaphore_t searchDone = dispatch_semaphore_create(0);
    
    dispatch_async(queue1st, ^{ [self sendSearchings]; });
    
    dispatch_async(queue2nd, ^{
        DebugOnly(Markdown(Finder, @"Receive Echos"));
        devices = [self recvResponses];
        devices = seive(devices);
        
        dispatch_semaphore_signal(searchDone);
    });
    
    // 如果内网确实找不到WitFii路由器，则应避免无限期等待数据接收。关闭socket会结束recv过程
    dispatch_time_t oneSecond = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(oneSecond, queue3rd, ^{
        [self close];
    });
    
    void (^waitUntilCompleted)() = ^{
        DebugOnly(Markdown(Finder, @"Waiting for Responses"));
        dispatch_semaphore_wait(searchDone, DISPATCH_TIME_FOREVER);
    };
    
    // 虽然上面的三项工作都是在内部GCD队列完成的，但是跟用户相关的操作还是交给了dispatcher
    // 来完成，包括等待搜索完成、以及数据通告，后者通常会在主线程完成。
    [dispatcher dispatchWithBehaviorAction:waitUntilCompleted
                              notifyAction:^{
                                  DebugOnly(Markdown(Finder, @"Searching Done"));

                                  if (devices.count==0)
                                      missed();
                                  else
                                      remains(devices);
                                  
                                  [self close];
                                  
                                  completion();
                              }];
}

- (void)findAllDevicesMatched:(WFXDeviceFinderMultiMatchesHandler)matched
                       missed:(WFXDeviceFinderMissedHandler)missed
                   completion:(WFXDeviceFinderCompletionHandler)completion
{
    DebugOnly(MarkdownCurrentMethod(Finder));
    
    SeiveDevices keepsAll = ^(NSArray* allDevices) {
        // 对于全搜索来说，基础搜索过程返回什么，我们就向外界抛出什么，所以单纯返回allDevices即可
        return allDevices;
    };
    
    [self findDevicesWithSeive:keepsAll
                       remains:matched
                        missed:missed
                    completion:completion];
}

- (void)findDevicesWithMacAddr:(NSString *)macAddr
                       matched:(WFXDeviceFinderOneMatchHandler)matched
                        missed:(WFXDeviceFinderMissedHandler)missed
                    completion:(WFXDeviceFinderCompletionHandler)completion
{
    DebugOnly(MarkdownCurrentMethod(Finder));
    
    // 为了准确进行MAC地址对比，将外界传入的地址统一转换成小写的
    macAddr = [macAddr lowercaseString];
    
    SeiveDevices seiveByMacAddr = ^(NSArray* allRouters) {
        __block DeviceEcho* matched = nil;
//        if (allRouters.count==1){
//            matched=allRouters[0];
//        }else{
            [allRouters enumerateObjectsUsingBlock:^(DeviceEcho* echo, NSUInteger idx, BOOL *stop) {
                NSString *macBind=[[echo.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""] lowercaseString];
                macBind=[macBind substringToIndex:macBind.length-1];
                NSString *address=[macAddr stringByReplacingOccurrencesOfString:@":" withString:@""];
                address=[address substringToIndex:address.length-1];
                if ([macBind isEqualToString:address]&&echo.token) {
                    matched = echo;
                    
                    // 找到匹配的echo时，提前结束循环，以提高搜索效率
                    *stop = YES;
                }
            }];
//        }
        // nil 对调用者来说不是一个合法的NSArray对象，所以应将其转换成更适合用来描述“空数组”的@[]对象，该对象中不包含任何
        // echo，但本身仍是一个NSArray对象
        return matched==nil ? @[] : @[matched];
    };
    
    // 由于matched回调只接受单个Echo对象作为参数，所以必须从originals中获取第1个对象，也应该是其唯一的Echo对象
    [self findDevicesWithSeive:seiveByMacAddr
                       remains:^(NSArray* originals) { matched(originals[0]); }
                        missed:missed
                    completion:completion];
}

@end
