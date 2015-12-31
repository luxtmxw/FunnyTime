//
//  FeedBackViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/7.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackView.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
@interface FeedBackViewController ()<UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) FeedBackView *feedbackView;

@end

@implementation FeedBackViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)loadView
{
    self.view = kBlurView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNaigationController];
    
    self.feedbackView = [[FeedBackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.feedbackView.textField.delegate = self;
    self.feedbackView.textView.delegate = self;
    [self.view addSubview:_feedbackView];
  
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    CGRect rect;
//    rect = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"feedback--viewWillAppear------------%@",NSStringFromCGRect(rect));
//    
//    
//    
////    self.navigationController.navigationBar.height = 64;
////    NSLog(@"feedback--viewWillAppear------------%f",self.navigationController.navigationBar.height);
//}

- (void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
//    CGRect rect;
//    rect = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"feedback--viewDidAppear------------%@",NSStringFromCGRect(rect));
//    NSLog(@"feedbac--viewDidAppear------------%f",self.navigationController.navigationBar.height);
    
    if ([FunnyTimeHandle shareFunnyTimeHandle].statusBarHeight == 0) {
        self.navigationController.navigationBar.height = 64;
    }else{
        self.navigationController.navigationBar.height = 44;
    }

}


#pragma mark - navigation

- (void)setUpNaigationController {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"意见反馈";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(actionLeftBarButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_bar_send"] style:(UIBarButtonItemStylePlain) target:self action:@selector(actionRigthBarButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
//    self.navigationController.navigationBar.translucent = NO;
    
    
}
- (void)actionLeftBarButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - sent

- (void)actionRigthBarButton {
    
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithTitle:@"当前系统版本不支持应用内发送邮件功能" Message:nil];
        return;
    }
    else if (![mailClass canSendMail]) {
        [self alertWithTitle:@"您没有设置邮件账户" Message:nil];
        return;
    }else{
        
        
        if (self.feedbackView.textView.text.length == 0) {
            [self alertWithTitle:@"请写下您的意见" Message:nil];
        }else{
            
            if ([NetMoniter sharedClient].isCennected) {
                [self displayComposerSheet];
            }else{
                [self alertWithTitle:@"网络不可用" Message:@"请检查网络"];
            }
        }
    }
}

//- (void)sendMailInApp
//{
//    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//    if (!mailClass) {
//        [self alertWithTitle:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替" Message:nil];
//             return;
//        }
//    else if (![mailClass canSendMail]) {
//        [self alertWithTitle:@"用户没有设置邮件账户" Message:nil];
//             return;
//    }else{
//        
//    }
//    
//}


#pragma mark - displayComposerSheet

- (void)displayComposerSheet
{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    
    //设置主题
    [mailVC setSubject:@"用户反馈"];
    
    //添加收件人
    [mailVC setToRecipients:@[@"luxtmxw@126.com"]];
    
    //添加密送
    [mailVC setCcRecipients:nil];
    
    //邮件内容
    NSString *messageBody = [NSString stringWithFormat:@"发件人:%@\n用户意见:\n%@", self.feedbackView.textField.text, self.feedbackView.textView.text];
    [mailVC setMessageBody:messageBody isHTML:NO];
    
    //跳转
    [self presentViewController:mailVC animated:YES completion:^{
    
    }];

}

//发送提示
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *title;
    NSString *message = nil;
    switch (result) {
            case MFMailComposeResultSaved:
            title = @"成功保存邮件";
            [self alertWithTitle:title Message:message];
            
            break;
        case MFMailComposeResultSent:
            title = @"发送成功";
            message = @"感谢您提出的宝贵意见，我们会更加努力";
            [self alertWithTitle:title Message:message];
            break;
        case MFMailComposeResultFailed:
            title = @"发送邮件失败";
            [self alertWithTitle:title Message:message];
            break;
        default:
            title = nil;
            break;
    }

    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送提醒
- (void)alertWithTitle:(NSString *)title Message:(NSString *)message
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.5];
    
}
- (void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
}

//开始输入，隐藏Label
- (void)textViewDidChange:(UITextView *)textView
{
    if (0 == textView.text.length) {
        self.feedbackView.placeholderLabel.alpha = 1;
    }else{
        self.feedbackView.placeholderLabel.alpha = 0;
    }
    
}

//键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.feedbackView.textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
