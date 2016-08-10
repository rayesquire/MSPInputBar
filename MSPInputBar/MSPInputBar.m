//
//  MSPInputBar.m
//  weChat
//
//  Created by 马了个马里奥 on 16/8/8.
//  Copyright © 2016年 尾巴超大号. All rights reserved.
//

#import "MSPInputBar.h"

#import <Masonry.h>

#define TEXTSIZE 16
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define MYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface MSPInputBar () <UITextViewDelegate>

@property (nonatomic, readwrite, strong) UIButton *voiceButton;
@property (nonatomic, readwrite, strong) UIButton *voiceHoldOn;
@property (nonatomic, readwrite, strong) UITextView *inputFrame;
@property (nonatomic, readwrite, strong) UIButton *faceButton;
@property (nonatomic, readwrite, strong) UIButton *moreButton;

@property (nonatomic, readwrite, assign) CGFloat maxLineHeight;
@property (nonatomic, readwrite, assign) CGRect originalFrame;

@property (nonatomic, readwrite, assign) CGSize cacheSize;

@end

@implementation MSPInputBar

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = MYColor(234, 234, 234);
        self.frame = CGRectMake(0, CGRectGetMinY(frame), SCREEN_WIDTH, CGRectGetHeight(frame));
        
        self.voiceButton.tag = 1;
        self.moreButton.tag = 3;
        self.faceButton.tag = 2;
        self.inputFrame.tag = 5;
        _inputFrame.delegate = self;
        
        _originalFrame = frame;
        _maxLines = 5;
        
        NSString *test = @"Aa我";
        CGSize size = [test sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXTSIZE]}];
        CGSize constraintSize = CGSizeMake(_inputFrame.frame.size.width, MAXFLOAT);
        CGSize newSize = [_inputFrame sizeThatFits:constraintSize];
        _maxLineHeight = newSize.height + (_maxLines - 1) * size.height - 6;
    }
    return self;
}

- (void)setFrameWithoutOriginalFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _originalFrame = frame;
}

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView {
    CGSize constraintSize = CGSizeMake(textView.frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];

    if ((size.height >= _maxLineHeight && _cacheSize.height >= _maxLineHeight) || size.height == _cacheSize.height) return;
    
    if (size.height <= _originalFrame.size.height - 9) {
        CGRect rect = CGRectMake(self.frame.origin.x, _originalFrame.origin.y, self.frame.size.width, _originalFrame.size.height);
        [self setFrameWithoutOriginalFrame:rect];
//        self.y = _originalFrame.origin.y;
//        self.height = _originalFrame.size.height;
        textView.textContainerInset = UIEdgeInsetsMake(10, 5, 0, 5);
        size = [textView sizeThatFits:constraintSize];
    }
    else {
        if (size.height >= _maxLineHeight) {
            textView.scrollEnabled = YES;
        }
        else {
            textView.scrollEnabled = NO;
            textView.textContainerInset = UIEdgeInsetsMake(2, 5, 2, 5);
            size = [textView sizeThatFits:constraintSize];
            CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.x, self.frame.size.width, size.height + 12);
            [self setFrameWithoutOriginalFrame:rect];
//            self.height = size.height + 12;
        }
        CGFloat minY = CGRectGetMaxY(_originalFrame);
        CGRect rect = CGRectMake(self.frame.origin.x, minY - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self setFrameWithoutOriginalFrame:rect];
//        self.y = minY - self.height;
        [textView setNeedsLayout];
    }
    _cacheSize = size;
}

#pragma mark - lazy load
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(voiceTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
        [_voiceButton mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(self.mas_left).with.offset(3);
            maker.bottom.equalTo(self.mas_bottom).with.offset(-8);
            maker.size.equalTo(@(33));
        }];
    }
    return _voiceButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_BlackHL"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(moreButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.right.equalTo(self.mas_right).with.offset(-3);
            maker.bottom.equalTo(self.mas_bottom).with.offset(-8);
            maker.size.equalTo(@(33));
        }];
    }
    return _moreButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(faceButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceButton];
        [_faceButton mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.right.equalTo(_moreButton.mas_left).with.offset(-5);
            maker.bottom.equalTo(self.mas_bottom).with.offset(-8);
            maker.size.equalTo(@(33));
        }];
    }
    return _faceButton;
}

- (UITextView *)inputFrame {
    if (!_inputFrame) {
        _inputFrame = [[UITextView alloc] init];
        [_inputFrame setFont:[UIFont systemFontOfSize:TEXTSIZE]];
        _inputFrame.layer.borderWidth = 1;
        _inputFrame.layer.masksToBounds = YES;
        _inputFrame.layer.cornerRadius = 5;
        _inputFrame.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputFrame.scrollEnabled = NO;
        _inputFrame.showsHorizontalScrollIndicator = NO;
        _inputFrame.enablesReturnKeyAutomatically = YES;
        _inputFrame.returnKeyType = UIReturnKeySend;
        _inputFrame.textContainerInset = UIEdgeInsetsMake(10, 5, 0, 5);
        [self addSubview:_inputFrame];
        [_inputFrame mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(_voiceButton.mas_right).with.offset(5);
            maker.right.equalTo(_faceButton.mas_left).with.offset(-5);
            maker.top.equalTo(self.mas_top).with.offset(5);
            maker.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
    }
    return _inputFrame;
}


- (UIButton *)voiceHoldOn {
    if (!_voiceHoldOn) {
        _voiceHoldOn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceHoldOn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceHoldOn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_voiceHoldOn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        UIImage *normal = [UIImage imageNamed:@"VoiceBtn_Black"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30) resizingMode:UIImageResizingModeStretch];
        [_voiceHoldOn setBackgroundImage:normal forState:UIControlStateNormal];
        UIImage *selected = [UIImage imageNamed:@"VoiceBtn_BlackHL"];
        selected = [selected resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30) resizingMode:UIImageResizingModeStretch];
        [_voiceHoldOn setBackgroundImage:selected forState:UIControlStateSelected];
        [_voiceHoldOn setHidden:YES];
        [_voiceHoldOn addTarget:self action:@selector(voiceHoldOnTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voiceHoldOn addTarget:self action:@selector(voiceHoldOnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_voiceHoldOn addTarget:self action:@selector(voiceHoldOnTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceHoldOn addTarget:self action:@selector(voiceHoldOnTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
        [_voiceHoldOn addTarget:self action:@selector(voiceHoldOnTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [self addSubview:_voiceHoldOn];
        [_voiceHoldOn mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(_voiceButton.mas_right).with.offset(5);
            maker.right.equalTo(_faceButton.mas_left).with.offset(-5);
            maker.top.equalTo(self.mas_top).with.offset(5);
            maker.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
    }
    return _voiceHoldOn;
}

#pragma mark - protocol
- (void)voiceTouchUpInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceTouchUpInside)]) {
        [self.delegate voiceTouchUpInside];
    }
}

- (void)voiceHoldOnTouchDown {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceHoldOnTouchDown)]) {
        [self.delegate voiceHoldOnTouchDown];
    }
}

- (void)voiceHoldOnTouchUpInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceHoldOnTouchUpInside)]) {
        [self.delegate voiceHoldOnTouchUpInside];
    }
}

- (void)voiceHoldOnTouchUpOutside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceHoldOnTouchUpOutside)]) {
        [self.delegate voiceHoldOnTouchUpOutside];
    }
}

- (void)voiceHoldOnTouchDragInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceHoldOnTouchDragInside)]) {
        [self.delegate voiceHoldOnTouchDragInside];
    }
}

- (void)voiceHoldOnTouchDragOutside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceHoldOnTouchDragOutside)]) {
        [self.delegate voiceHoldOnTouchDragOutside];
    }
}

- (void)faceButtonTouch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceButtonClick)]) {
        [self.delegate faceButtonClick];
    }
}

- (void)moreButtonTouch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreButtonClick)]) {
        [self.delegate moreButtonClick];
    }
}

@end
