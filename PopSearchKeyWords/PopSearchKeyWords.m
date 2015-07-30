//
//  PopSearchKeyWords.m
//  PopSearchKeyWords
//
//  Created by 力贵才 on 15/7/29.
//  Copyright (c) 2015年 Guicai-Li. All rights reserved.
//

#import "PopSearchKeyWords.h"
#import "pop/POP.h"

#define kButtonTage 62292
#define DEVICE_IS_IPHONE6_PLUS (([[UIScreen mainScreen] bounds].size.height - 736) ? NO : YES)

@interface PopSearchKeyWords() {
    int currentIndex;
    float maxWidth;
    float maxHeight;
}
@property (nonatomic, assign) CGRect rect;

@end

@implementation PopSearchKeyWords

- (void)dealloc {
    _view = nil;
    _dataSource = nil;
    _delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)rect onViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.view.frame = rect;
        self.rect = rect;
        
        [controller.view addSubview:self.view];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)rect onView:(UIView *)view {
    self = [super init];
    if (self) {
        self.view.frame = rect;
        self.rect = rect;
        [view addSubview:self.view];
    }
    return self;
}

- (void)show {
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    currentIndex = 0;
    NSMutableArray *buttonArray = [self setUI];
    [self pop:buttonArray];
}

#pragma mark UI

- (NSMutableArray *)setUI {
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.dataSource count]; i ++) {
        UIButton *keyWordButton = [self keyWordButtonWithTitle:self.dataSource[i] tag:(kButtonTage + i)];
        [buttonArray addObject:keyWordButton];
        [self.view addSubview:keyWordButton];
    }
    [self calculateMaxWidthAndHeight:buttonArray];
    return buttonArray;
}

- (UIButton *)keyWordButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    // TODO：默认出现的初位置
    CGFloat buttonX = self.rect.size.width / 2;
    CGFloat buttonY = self.rect.size.height / 2;
    
    UIButton *keyWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // TODO：字体大小
    NSInteger fontSize = (arc4random() % 10) + 15;
    
    CGFloat buttonWidth = [self widthForLableWithText:title fontSize:fontSize];
    
    // TODO:颜色
    CGFloat red = (arc4random() % 206) + 50;
    CGFloat blue = (arc4random() % 206) + 50;
    CGFloat green = (arc4random() % 206) + 50;
    
    keyWordButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, 30);
    [keyWordButton setTitle:title forState:UIControlStateNormal];
    [keyWordButton setTitleColor:[UIColor colorWithRed:red/255.0 green:blue/255.0 blue:green/255.0 alpha:1.0] forState:UIControlStateNormal];
    [keyWordButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    keyWordButton.tag = tag;
    [keyWordButton addTarget:self action:@selector(keyWordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return  keyWordButton;
}

- (CGFloat) widthForLableWithText:(NSString *)strText fontSize:(NSInteger)fontSize {
    CGSize rectSize = CGSizeMake(CGFLOAT_MAX,20);
    
    CGSize stringSize = {0,0};
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        stringSize= [strText sizeWithFont: [UIFont systemFontOfSize:fontSize] constrainedToSize:rectSize lineBreakMode:NSLineBreakByClipping];
    } else {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        stringSize = [strText boundingRectWithSize:rectSize
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:attribute context:nil].size;
    }
    
    float width = stringSize.width + 2;
    return width;
}

#pragma mark keyWordsButtonClicked

- (void)keyWordBtnAction:(UIButton *)keyWordButton {
    if ([self.delegate respondsToSelector:@selector(clickedSearchKeyWord:)]) {
        [self.delegate clickedSearchKeyWord:(keyWordButton.tag - kButtonTage)];
    }

}

#pragma mark pop

- (void)pop:(NSMutableArray *)buttonArray {

    NSMutableArray *showButtonFrameArray = [self calculateFrame:buttonArray];
    for (int i = 0; i < [showButtonFrameArray count]; i ++) {
        NSValue *value = showButtonFrameArray[i];
        CGRect rect = [value CGRectValue];
        [self showPopWithPopButton:buttonArray[i] showPosition:rect];
    }
}

- (void)showPopWithPopButton:(UIButton *)Button showPosition:(CGRect)Rect {
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.fromValue = [NSValue valueWithCGRect:Button.frame];
    positionAnimation.toValue = [NSValue valueWithCGRect:Rect];
    positionAnimation.springBounciness = 15.0f;
    positionAnimation.springSpeed = 10.0f;
    [Button pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
}

#pragma mark calculateFrame

- (NSMutableArray *)calculateFrame:(NSMutableArray *)buttonArray {
    
    NSMutableArray *frameArray = [NSMutableArray array];
    for (UIButton *button in buttonArray) {
        CGRect rect = button.frame;
        // DO:随机
        rect = [self randomRect:rect];
        while ([self checkIsInRect:frameArray rect:rect]) {
            rect = [self randomRect:rect];
        }
        NSValue *value = [NSValue valueWithCGRect:rect];
        [frameArray addObject:value];
    }
    return frameArray;
}

- (CGRect)randomRect:(CGRect)rect {
    
    // 随机策略：以中心点为锚点  随机上下左右分配
    //  _______________
    //  |             |
    //  |             |
    //  |             |
    //  |             |
    //  |             |
    //  |-------------|
    /*
    float viewCenterX = self.rect.size.width / 2;
    float viewCenterY = self.rect.size.height / 2;
    float distanceX = (arc4random() % (int)viewCenterX) - 10;
    float distanceY = (arc4random() % (int)viewCenterY) - 10;
    float rectX = distanceX + pow((-1), (arc4random() % 2 + 1));
    float rectY = distanceY + pow((-1), (arc4random() % 2 + 1));

    */
    
    // 随机策略：以内矩形为原点为准 随机
    //   _____________
    //  | ___________ |
    //  | |         | |
    //  | |         | |
    //  | |         | |
    //  | |         | |
    //  | ----------- |
    //  |-------------|
    // DO:计算出最大的文字宽度 高度
    float viewCenterX = 40;
    float viewCenterY = 40;
    if (DEVICE_IS_IPHONE6_PLUS) {
        viewCenterX = 55;
        viewCenterY = 55;
    }

    float distanceX = (arc4random() % (int)(self.rect.size.width - viewCenterX * 2));
    float distanceY = (arc4random() % (int)(self.rect.size.width - viewCenterY * 2));
    float rectX = (viewCenterX + distanceX - maxWidth > viewCenterX) && (viewCenterX + distanceX - maxWidth < self.rect.size.width - viewCenterX) ? viewCenterX + distanceX - maxWidth: viewCenterX;
    float rectY = (viewCenterY + distanceY - maxHeight > viewCenterY)  && (viewCenterY + distanceY - maxHeight < self.rect.size.height - viewCenterY)? viewCenterY + distanceY - maxHeight : viewCenterY;

    rect.origin.x = rectX;
    rect.origin.y = rectY;
    return rect;
}

- (BOOL)checkIsInRect:(NSMutableArray *)frameArray rect:(CGRect)rect {
    BOOL isInRect = NO;
    for (NSValue *otherValue in frameArray) {
        CGRect otherRect = [otherValue CGRectValue];
        // DO:最小间隙10像素
        otherRect.size.width += 10;
        otherRect.size.height += 10;

        if (CGRectIntersectsRect(otherRect, rect)) {
            isInRect = YES;
            break;
        }
    }
    return isInRect;
}

#pragma mark 计算最大的宽高

- (void)calculateMaxWidthAndHeight:(NSMutableArray *)buttonArray {
    for (UIButton *button in buttonArray) {
        CGSize buttonSize = button.frame.size;
        if (buttonSize.width > maxWidth) {
            maxWidth = buttonSize.width;
        }
        if (buttonSize.height > maxHeight) {
            maxHeight = buttonSize.height;
        }
    }
}

#pragma mark getter

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
    }
    return _view;
}

@end
