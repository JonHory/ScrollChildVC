//
//  SecondViewController.m
//  AddChildVC
//
//  Created by Jonhory on 2016/10/13.
//  Copyright © 2016年 wujh. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (UIScrollView *)scroll{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc]init];
        _scroll.backgroundColor = [UIColor lightGrayColor];
    }
    return _scroll;
}

- (void)setScrollFrame:(CGRect)frame{
    self.scroll.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.scroll.contentSize = CGSizeMake(0, 2*frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scroll];
    
    UIView * vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    vv.backgroundColor = [UIColor redColor];
    vv.center = self.view.center;
    [self.scroll addSubview:vv];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
