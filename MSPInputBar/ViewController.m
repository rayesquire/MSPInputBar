//
//  ViewController.m
//  MSPInputBar
//
//  Created by 马了个马里奥 on 16/8/9.
//  Copyright © 2016年 马了个马里奥. All rights reserved.
//

#import "ViewController.h"
#import "MSPInputBar.h"

#import "UIView+Extension.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController () <MSPInputBarDelegate>

@property (nonatomic, readwrite, strong) MSPInputBar *inputBar;
@property (nonatomic, readwrite, assign) CGFloat keyboardHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputBar = [[MSPInputBar alloc] init];
    _inputBar.delegate = self;
    [self.view addSubview:_inputBar];
    
    [self registerKeyboardNotification];

}

- (void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 搜狗输入法会多次调用键盘通知获取高度
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    [self autoMoveKeyBoard:_keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self autoMoveKeyBoard:0];
}

- (void)autoMoveKeyBoard:(CGFloat)height {
    [UIView animateWithDuration:0.3 animations:^{
        _inputBar.y = SCREEN_HEIGHT - _inputBar.height - height;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textView:(UITextView *)textView finalText:(NSString *)text {
    
}

@end
