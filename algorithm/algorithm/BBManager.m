//
//  BBManager.m
//  algorithm
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBManager.h"

@implementation BBManager

//单例
+ (BBManager *)sharedManager{
    static BBManager *manager     = nil;
    static dispatch_once_t once_t = 0;
    dispatch_once(&once_t, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

//输入金额的校验
- (NSString *)checkMoney:(NSString *)money{
    NSInteger i = money.length;
    if(!i){return money;}
    
    const char *tem = [money cStringUsingEncoding:NSUTF8StringEncoding];
    if(!tem){return @"";}//说明数据有异常
    
    //最极限的情况，所有值都存下来了，还在第一位补0，最后补一个'\0'
    char index = 0, dot = -1, has_dot = NO, character[i+2];
    for(char j = 0; j < i; j++){
        char c = tem[j];
        if(c != '.' && (c < '0' || c > '9')){break;}
        if(c == '0' && index == 1 && character[0] == '0'){continue;}//说明是000000这种形式
        if(has_dot && c == '.'){break;}     //说明是***.***.**这种形式
        
        if(c == '.'){has_dot = YES;}        //发现了点，这个是第一个点
        
        if(index == 1 && character[0] == '0' && c != '.'){index --;}//说明是012345这种形式
        
        character[index] = c;               //这个值是正确的，存储下来
        index ++;                           //下标累加
        
        if(has_dot){dot ++; if(dot >= 2){break;}}            //小数点后两位了
    }
    character[index] = '\0'; //最后 补一个'\0'结束标志
    NSString *result = [[NSString alloc]initWithBytes:character length:index encoding:NSUTF8StringEncoding];
    return [result hasPrefix:@"."] ? [NSString stringWithFormat:@"0%@",result] : result;
}

//判断身份证号
- (BOOL)checkIDCard:(NSString *)idCard{
    if(!idCard.length){return NO;}
    
    const char *characters = [idCard cStringUsingEncoding:NSUTF8StringEncoding];
    if(!characters || strlen(characters) != 18){return NO;}//数据有异常
    
    char c = characters[17];
    if((c < '0' || c > '9') && c != 'x' && c != 'X'){return NO;}
    for(char i = 0; i < 17; i ++){
        char c = characters[i];
        if(c >= '0' && c <= '9'){continue;}
        else{return NO;}
    }
    
    //取月份
    NSInteger month = 10 * (characters[10]-'0') + (characters[11] - '0');
    if(month <= 0 || month >= 13){return NO;}
    
    //取天
    NSInteger day = 10 * (characters[12] - '0') + (characters[11] - '0');
    if(day <= 0 || day >= 32){return NO;}
    
    //取前两位
    NSInteger number = 10 * (characters[0] - '0') + (characters[1] - '0');
    if((number >= 11 && number <= 15) || (number >= 21 && number <= 23) || (number >= 31 && number <= 37) || (number >= 41 && number <= 46) || (number >= 50 && number <= 54) || (number >= 61 && number <= 65) || (number >= 81 && number <= 82)){
        //校验位
        const char factors[17] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
        int result = 0;
        for(char index = 0; index < 17; index ++){
            char factor = factors[index];
            char bit = characters[index] - '0';
            result += factor * bit;
        }
        char compares[11] = {'1', '0', 'x', '9', '8', '7', '6', '5', '4', '3', '2'};
        char due = result % 11;
        char c = compares[due];
        char last = characters[17];
        last = (last == 'X') ? 'x' : last;
        return c == last;
    }
    else{
        return NO;
    }
}

//BCD 编码
- (NSData *)BcdEncode:(NSString *)text{
    const char *cStr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    if(!cStr){return NULL;}
    
    NSInteger len  = strlen(cStr);
    NSInteger size = (len + 1) / 2, from = 0;
    char result[size + 1];
    size = 0;
    if(len % 2){from = 1; result[0] = cStr[0] - '0'; size = 1;}
    
    for(NSInteger i = from; i < len; i += 2){
        char pre  = cStr[i]   - '0';
        char next = cStr[i+1] - '0';
        result[size] = (pre << 4) | next;
        size ++;
    }
    result[size] = '\0';
    
    return [NSData dataWithBytes:result length:strlen(result)];
}

@end
