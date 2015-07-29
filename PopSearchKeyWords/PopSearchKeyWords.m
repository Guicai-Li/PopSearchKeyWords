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

@interface PopSearchKeyWords()

@property (nonatomic, assign) CGRect rect;

@end

@implementation PopSearchKeyWords

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
    
}

#pragma mark UI

- (void)initUI {
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.dataSource count]; i ++) {
        UIButton *keyWordButton = [self keyWordButtonWithTitle:self.dataSource[i] tag:(kButtonTage + i)];
        
        [buttonArray addObject:keyWordButton];
        [self.view addSubview:keyWordButton];
    }
}

- (UIButton *)keyWordButtonWithTitle:(NSString *)aTitle tag:(NSInteger)tag {
    // TODO：出现的位置
    CGFloat buttonX = self.rect.size.width / 2;
    CGFloat buttonY = self.rect.size.height / 2;
    
    UIButton *keyWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // TODO：字体大小
    NSInteger fontSize = (arc4random() % 4) + 13;
    
    CGFloat buttonWidth = [self widthForLableWithText:aTitle fontSize:fontSize];
    
    // TODO:颜色
    CGFloat red = (arc4random() % 246) + 10;
    CGFloat blue = (arc4random() % 246) + 10;
    CGFloat green = (arc4random() % 246) + 10;
    
    keyWordButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, 30);
    [keyWordButton setTitle:aTitle forState:UIControlStateNormal];
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
    
    float height = stringSize.width +2;
    return height;
}

- (void)keyWordBtnAction:(UIButton *)keyWordButton {
    [self.delegate clickedSearchKeyWord:(keyWordButton.tag - kButtonTage)];
}

#pragma mark pop


- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
    }
    return _view;
}

@end
