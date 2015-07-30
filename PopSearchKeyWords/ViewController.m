//
//  ViewController.m
//  PopSearchKeyWords
//
//  Created by 力贵才 on 15/7/29.
//  Copyright (c) 2015年 Guicai-Li. All rights reserved.
//

#import "ViewController.h"
#import "PopSearchKeyWords.h"

@interface ViewController () <PopSearchKeyWordsDelegate>

@property (nonatomic, strong) PopSearchKeyWords *keyWordsview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.keyWordsview show];
}

- (PopSearchKeyWords *)keyWordsview {
    if (_keyWordsview == nil) {
        _keyWordsview = [[PopSearchKeyWords alloc] initWithFrame:CGRectMake(6, 70, self.view.bounds.size.width - 12, 300) onView:self.view];
        _keyWordsview.dataSource = @[@"Ubbie故事", @"宝贝", @"睡衣宝宝", @"天使", @"宝贝儿歌", @"儿童音乐", @"企鹅历险记", @"古诗词", @"童话故事", @"小优比"];
        _keyWordsview.view.backgroundColor = [UIColor whiteColor];
        _keyWordsview.view.layer.cornerRadius = 8.0f;
        _keyWordsview.view.layer.masksToBounds = YES;
        _keyWordsview.delegate = self;
    }
    return _keyWordsview;
}

- (void)clickedSearchKeyWord:(NSInteger)index {
    NSLog(@"点击第:%ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
