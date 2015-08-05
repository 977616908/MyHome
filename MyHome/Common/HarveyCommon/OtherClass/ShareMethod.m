//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "ShareMethod.h"

@implementation ShareMethod

+ (CGFloat)calculateWidthWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    if([[MyDevice OS_Version] hasPrefix:@"7"]){
        return [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}].width;
    }else {
       return [string sizeWithFont:[UIFont systemFontOfSize:fontSize]].width;
    }
}

+ (CGFloat)calculateWidthWithString:(NSString *)string boldFontSize:(CGFloat)fontSize
{
    if([[MyDevice OS_Version] hasPrefix:@"7"]){
        return [string sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]}].width;
    }else {
        return [string sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]].width;
    }
}

+ (CGFloat)calculateHeightWithString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize
{
    if([[MyDevice OS_Version] hasPrefix:@"7"]){
        return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    }else {
        return [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
}

+ (CGFloat)calculateHeightWithString:(NSString *)string width:(CGFloat)width boldFontSize:(CGFloat)fontSize
{
    if([[MyDevice OS_Version] hasPrefix:@"7"]){
        return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size.height;
    }else {
        return [string sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    }

}

+ (NSString *)removeHTMLTagFromString:(NSString *)str HTMLTags:(NSArray *)tags
{
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:str];
    for(int i=0; i<[tags count]; i++) {
        
        NSString *tag = [tags objectAtIndex:i];
        if (1){
            
            NSRange loc = [mStr rangeOfString:tag];
            if(loc.location < mStr.length) {
                
                [mStr deleteCharactersInRange:loc];
            }else
                break;
        }
    }
    return mStr;
}

@end
