//
//  ViewController.m
//  algorithm
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "ViewController.h"
#import "BBManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *money_tf;
@property (weak, nonatomic) IBOutlet UITextField *ID_tf;
@property (weak, nonatomic) IBOutlet UILabel *ID_des;
@property (weak, nonatomic) IBOutlet UITextField *bcd_tf;
@property (weak, nonatomic) IBOutlet UILabel *bcd_des;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)valueChange:(UITextField *)sender {
    sender.text = [BBManager.sharedManager checkMoney:sender.text];
}

- (IBAction)checkID:(UIButton *)sender {
    BOOL state = [BBManager.sharedManager checkIDCard:self.ID_tf.text];
    self.ID_des.text = state ? @"是身份证号" : @"不是身份证号";
}

- (IBAction)bcdConvert:(UIButton *)sender {
    NSData *data = [BBManager.sharedManager BcdEncode:self.bcd_tf.text];
    
    if(!data){self.bcd_des.text = @"null";}
    else{
        const char *s = data.bytes;
        NSMutableString *mut = [NSMutableString string];
        for(size_t index = 0; index < strlen(s); index ++){
            [mut appendString:@(s[index]).description];
            [mut appendString:@" "];
        }
        self.bcd_des.text = mut;
    }
}

@end
