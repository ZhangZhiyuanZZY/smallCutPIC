//
//  ViewController.m
//  小块的截图
//
//  Created by 章芝源 on 16/1/6.
//  Copyright © 2016年 ZZY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//背景图片
@property(nonatomic, strong)UIImageView *imageView;
//截取的图片
@property(nonatomic, strong)UIView *clipView;
//开始点
@property(assign, nonatomic)CGPoint startP;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"DH4G9IJF}@UH5G38R@TP{9P"];
    imageView.frame = self.view.bounds;
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    [self.view addSubview:imageView];
    //给UIImaheView添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [imageView addGestureRecognizer:pan];
   
}
//判断松手的时候, 得到区域的大小.

//把拿到的区域, 保存到本地或者画到屏幕上
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //判断拖拽状态
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startP = [pan locationInView:self.imageView];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint pointChange = [pan locationInView:self.imageView];
        CGFloat w = pointChange.x - self.startP.x;
        CGFloat h = pointChange.y - self.startP.y;
        CGRect rect = {self.startP, {w,h}};
        self.clipView.frame = rect;
    }else if (pan.state == UIGestureRecognizerStateEnded){
        UIImage *image = [self clipWithImageRect:self.imageView.frame clipRect:self.clipView.frame clipImage:self.imageView.image];
        self.imageView.image = image;
        //移除剪切视图
        [self.clipView removeFromSuperview];
        self.clipView = nil;
    }
}

- (UIImage *)clipWithImageRect:(CGRect)imageRect clipRect:(CGRect)clipRect clipImage:(UIImage *)clipImage
{
    //开启图形上下文
    UIGraphicsBeginImageContext(imageRect.size);
    UIBezierPath *bzrPath = [UIBezierPath bezierPathWithRect:clipRect];
    [bzrPath addClip];
    [clipImage drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 懒加载
- (UIView *)clipView
{
    if (_clipView == nil) {
        _clipView = [[UIView alloc]init];
        _clipView.backgroundColor = [UIColor blackColor];
        _clipView.alpha = 0.5;
        [self.view addSubview:_clipView];
    }
    return _clipView;
}

@end
