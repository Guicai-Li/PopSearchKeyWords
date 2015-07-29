//
//  PopSearchKeyWords.h
//  PopSearchKeyWords
//
//  Created by 力贵才 on 15/7/29.
//  Copyright (c) 2015年 Guicai-Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol PopSearchKeyWordsDelegate <NSObject>

- (void)clickedSearchKeyWord:(NSInteger)index;

@end

@interface PopSearchKeyWords : NSObject

@property (nonatomic, strong) UIView *view;

@property (nonatomic, retain) id<PopSearchKeyWordsDelegate>delegate;

@property (nonatomic, strong) NSArray *dataSource;



- (instancetype)initWithFrame:(CGRect)rect onViewController:(UIViewController *)controller;

- (instancetype)initWithFrame:(CGRect)rect onView:(UIView *)view;

- (void)show;

@end
