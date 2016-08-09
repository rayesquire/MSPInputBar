//
//  MSPInputBar.h
//  weChat
//
//  Created by 马了个马里奥 on 16/8/8.
//  Copyright © 2016年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSPInputBarDelegate <NSObject>

@optional
- (void)voiceTouchUpInside;
- (void)voiceHoldOnTouchDown;
- (void)voiceHoldOnTouchUpInside;
- (void)voiceHoldOnTouchUpOutside;
- (void)voiceHoldOnTouchDragInside;
- (void)voiceHoldOnTouchDragOutside;
- (void)faceButtonClick;
- (void)moreButtonClick;
- (void)textView:(UITextView *)textView finalText:(NSString *)text;


@end

@interface MSPInputBar : UIView

@property (nonatomic, readwrite, weak) id <MSPInputBarDelegate> delegate;

@end
