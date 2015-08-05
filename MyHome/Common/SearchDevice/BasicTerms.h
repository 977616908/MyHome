#define DebugOnly(Stuff) Stuff

// 代码中有很多独立的小流程，如果仅用上面的DebugOnly，则会影响全局。当期望开启
// 部分代码的日志记录时，可使用该Markdown宏来实现。需要注意的是，使用该宏时
// condition必须被明确定义，否则会报编译错误
#define Markdown(condition, fmt, ...)\
    if ((condition)!=0) \
        PSLog(@"[%-10s] %@", (#condition), [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);

#define MarkdownCurrentMethod(condition)\
    if ((condition)!=0) \
        PSLog(@"[%-10s] %@", (#condition), NSStringFromSelector(_cmd));