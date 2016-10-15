//
//  ViewController.m
//  AddChildVC
//
//  Created by Jonhory on 2016/10/13.
//  Copyright © 2016年 wujh. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

#define SCREEN [UIScreen mainScreen].bounds.size
static CGFloat const MIXTOPVIEWS = 5;

@implementation UIColor (RandomColor)

+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView * topScroll;/**< 顶部滑动视图 */
@property (nonatomic ,strong) UIScrollView * vcsScroll;/**< vc.view的滑动视图 */

@property (nonatomic ,strong) NSMutableArray * vcsData;/**< 用于装所有vc的数组 */
@property (nonatomic ,strong) UIView * redView;/**< 小滑动块 */

@property (nonatomic ,strong) UIView * secondView;/**< 为了懒加载 */
@property (nonatomic ,strong) UIView * thirdView;/**< 为了懒加载 */

@property (nonatomic ,assign) CGFloat currentOffsetX;/**< 滑动结束时的偏移量，用来控制vc的ScrollView是否滑动到顶部 */
@end

@implementation ViewController

- (UIView *)secondView{
    if (!_secondView) {
        SecondViewController * vc = (SecondViewController *)self.vcsData[1];
        _secondView = vc.view;
        _secondView.frame = CGRectMake(SCREEN.width, 0, SCREEN.width, _vcsScroll.bounds.size.height);
        [vc setScrollFrame:_secondView.frame];
    }
    return _secondView;
}

- (UIView *)thirdView{
    if (!_thirdView) {
        UIViewController * vc = self.vcsData[2];
        _thirdView = vc.view;
        _thirdView.frame = CGRectMake(SCREEN.width * 2, 0, SCREEN.width, _vcsScroll.bounds.size.height);
    }
    return _thirdView;
}

- (UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.frame = CGRectMake(0, CGRectGetHeight(_topScroll.frame) - 2, SCREEN.width/_vcsData.count, 2);
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (NSMutableArray *)vcsData{
    if (!_vcsData) {
        _vcsData = [[NSMutableArray alloc]init];
    }
    return _vcsData;
}

- (UIScrollView *)topScroll{
    if (!_topScroll) {
        _topScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 64)];
        _topScroll.backgroundColor = [UIColor randomColor];
        _topScroll.directionalLockEnabled = YES;
        _topScroll.contentSize = CGSizeMake(SCREEN.width+1, 0);
    }
    return _topScroll;
}

- (UIScrollView *)vcsScroll{
    if (!_vcsScroll) {
        _vcsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topScroll.frame), SCREEN.width, SCREEN.height - CGRectGetHeight(_topScroll.frame))];
        _vcsScroll.backgroundColor = [UIColor randomColor];
        _vcsScroll.delegate = self;
        _vcsScroll.contentSize = CGSizeMake(SCREEN.width * 2, 0);
        _vcsScroll.pagingEnabled = YES;
    }
    return _vcsScroll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topScroll];
    [self.view addSubview:self.vcsScroll];
    
    FirstViewController * first = [[FirstViewController alloc]init];
    SecondViewController * second = [[SecondViewController alloc]init];
    ThirdViewController * third = [[ThirdViewController alloc]init];
    [self.vcsData addObject:first];
    [self.vcsData addObject:second];
    [self.vcsData addObject:third];
    
//    for (int i = 0; i<self.vcsData.count; i++) {
//        UIViewController * vc = self.vcsData[i];
//        vc.view.frame = CGRectMake(i*SCREEN.width, 0, SCREEN.width, CGRectGetHeight(_vcsScroll.frame));
//        vc.view.backgroundColor = [UIColor randomColor];
//        [self addChildViewController:vc];
//        [self.vcsScroll addSubview:vc.view];
//    }
    
//    [second setScrollFrame:second.view.frame];
    first.view.frame = CGRectMake(0, 0, SCREEN.width, CGRectGetHeight(_vcsScroll.frame));
    [self addChildViewController:first];
    [self addChildViewController:second];
    [self addChildViewController:third];
    [self.vcsScroll addSubview:first.view];
    
    self.vcsScroll.contentSize = CGSizeMake(self.vcsData.count * SCREEN.width, 0);
    
    for (int i = 0; i<self.vcsData.count; i++){
        UIButton * topBtn = [[UIButton alloc]init];
        topBtn.frame = CGRectMake(SCREEN.width / self.vcsData.count * i, 0, SCREEN.width/self.vcsData.count, CGRectGetHeight(_topScroll.frame));
        topBtn.backgroundColor = [UIColor randomColor];
        topBtn.tag = 200 + i;
        [topBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScroll addSubview:topBtn];
    }
    
    [self.topScroll addSubview:self.redView];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _vcsScroll) {
        self.currentOffsetX = scrollView.contentOffset.x;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (scrollView == _vcsScroll) {
        //懒加载视图
        int page = offsetX/SCREEN.width;
        switch (page) {
            case 1:{
                [self.vcsScroll addSubview:self.secondView];
                break;
            }
            case 2:{
                [self.vcsScroll addSubview:self.thirdView];
                break;
            }
            default:
                break;
        }
        
        //移动小滑块
        CGRect f = _redView.frame;
        f.origin.x = offsetX/SCREEN.width * f.size.width;
        _redView.frame = f;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _vcsScroll) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (self.currentOffsetX == offsetX) {
            return;
        }
        int page = offsetX/SCREEN.width;
        switch (page) {
            case 1:{
                NSLog(@"滑动结束时Second视图的ScrollView滑动到顶部");
                SecondViewController * vc = self.vcsData[1];
                [vc.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            }
            case 2:{
                [self.vcsScroll addSubview:self.thirdView];
                break;
            }
            default:
                break;
        }

    }
}

#warning 点击事件中使用setContentOffset:animated方法，不会触发scrollViewDidEndDecelerating:,所以需要在这个方法里面处理SecondVC的UIScrollView滑动到顶部
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"动画结束");
    if (scrollView == _vcsScroll) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (self.currentOffsetX == offsetX) {
            return;
        }
        self.currentOffsetX = offsetX;
        int page = offsetX/SCREEN.width;
        switch (page) {
            case 1:{
                NSLog(@"滑动结束时Second视图的ScrollView滑动到顶部");
                SecondViewController * vc = self.vcsData[1];
                [vc.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            }
            case 2:{
                [self.vcsScroll addSubview:self.thirdView];
                break;
            }
            default:
                break;
        }
        
    }
}

#pragma mark - Touch Events
- (void)btnClick:(UIButton *)btn{
    NSLog(@"%zi",btn.tag);
    switch (btn.tag) {
        case 200:
            [_vcsScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 201:
            [_vcsScroll setContentOffset:CGPointMake(SCREEN.width, 0) animated:YES];
            break;
        case 202:
            [_vcsScroll setContentOffset:CGPointMake(SCREEN.width * 2, 0) animated:YES];
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
