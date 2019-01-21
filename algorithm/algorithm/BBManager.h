//
//  BBManager.h
//  algorithm
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBManager : NSObject

//单例
+ (BBManager *)sharedManager;

/*
    输入金额的校验;
    只保留两位小数，如果想保留其他位数，如三位有效数字，请修改源码dot >= 2的2这个值
*/
- (NSString *)checkMoney:(NSString *)money;

/*
    判断身份证号，相比普通的正则表达式，速度快得多
*/
- (BOOL)checkIDCard:(NSString *)idCard;

/*
    BCD编码;
    之所以返回NSData，是因为其在堆区，若返回const char *则在栈区，不好处理。
*/
- (NSData *)BcdEncode:(NSString *)text;

@end

