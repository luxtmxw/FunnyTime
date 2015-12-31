//
//  FeedBackView.m
//  FunnyTime
//
//  Created by luxt on 15/10/7.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "FeedBackView.h"

@implementation FeedBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 20, 30)];
    
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.placeholder = @"您的联系方式(可不填，建议QQ号码、邮箱等)";
    self.textField.borderStyle = 3;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.clearButtonMode = 1;
    self.textField.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.920];
    [self addSubview:self.textField];
    

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.textField.frame.origin.y + self.textField.frame.size.height + 10, self.textField.frame.size.width, 150)];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.920];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [[UIColor colorWithWhite:0.75f alpha:0.5f] CGColor];
    [self addSubview:self.textView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.textView.frame.size.width, 30)];
    self.placeholderLabel.tag = 1999;
//    self.placeholderLabel.backgroundColor = [UIColor redColor];
    self.placeholderLabel.text = @"请提出您的宝贵意见";
    self.placeholderLabel.textColor = [UIColor colorWithWhite:0.71f alpha:0.8f];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    
    [self.textView addSubview:self.placeholderLabel];
}




@end
