//
//  FanProgress3D.m
//  FirstAF
//
//  Created by qianfeng on 14-10-24.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "FanProgress3D.h"

@implementation FanProgress3D
{
    UIImageView *_rotateView;
    UIImageView *_rotateView2;
    UIImageView *_centerView;
    UILabel *_titleLabel;
    NSTimer *fadeOutTimer;
    UIView *_maskView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rotateView = [[UIImageView alloc] init];
        _rotateView2 = [[UIImageView alloc] init];
        _centerView = [[UIImageView alloc] init];
        _titleLabel=[[UILabel alloc]init];
        _maskView=[[UIView alloc]init];
        [self configUI];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        _rotateView = [[UIImageView alloc] init];
        _rotateView2 = [[UIImageView alloc] init];
        _centerView = [[UIImageView alloc] init];
        _titleLabel=[[UILabel alloc]init];
          _maskView=[[UIView alloc]init];
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _maskView.layer.masksToBounds=YES;
    _maskView.layer.cornerRadius=10;
    _maskView.frame=CGRectMake(0, 0, 110, 100) ;
    _maskView.backgroundColor=[UIColor blackColor];
    CGRect smallFrame=CGRectMake((110-70)/2, 0, 70, 70);
    _centerView.frame =smallFrame;
    [_centerView setImage:[UIImage imageNamed:@"loading_bkgnd.png"]];
    
    
    _rotateView.frame =smallFrame;
    [_rotateView setImage:[UIImage imageNamed:@"loading_circle.png"]];
    
    
    _rotateView2.frame = smallFrame;
    [_rotateView2 setImage:[UIImage imageNamed:@"loading_circle.png"]];
    
    
    _titleLabel.frame=CGRectMake(10, 70, 90, 30);
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth=YES;
    _titleLabel.numberOfLines=0;
    _titleLabel.textColor=[UIColor whiteColor];
    //_titleLabel.font=[UIFont systemFontOfSize:12];
    
    [_maskView addSubview:_centerView];
    [_maskView addSubview:_rotateView];
    [_maskView addSubview:_rotateView2];
    [_maskView addSubview:_titleLabel];
}
static  FanProgress3D *manager;
+(FanProgress3D *)shareManager{
    if (manager==nil) {
        manager=[[FanProgress3D alloc]initWithFrame:CGRectZero];
    }
    return manager;
}
+ (void)showInView:(UIView*)view status:(NSString*)string{
    [[FanProgress3D shareManager] showInView:view status:string];
}
+ (void)dismiss{
    [[FanProgress3D shareManager] dismiss];
}
+ (void)dismissWithStatus:(NSString *)string afterDelay:(NSTimeInterval)seconds{
    [[FanProgress3D shareManager]dismissWithStatus:string afterDelay:seconds];
}


- (void)showInView:(UIView*)view status:(NSString*)string{
    _maskView.center=view.center;
    [view addSubview:_maskView];

    _titleLabel.text=string;

    
    //中间画面
    [self addAnimationInView:_centerView duration:0.5 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];
    //圆圈
    [self addAnimationInView:_rotateView duration:0.5 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];
    //圆圈
    [self addAnimationInView:_rotateView2 duration:0.4 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0.1)];

}
-(void)dismiss{
    [_maskView removeFromSuperview];
}

- (void)dismissWithStatus:(NSString *)string afterDelay:(NSTimeInterval)seconds {
    
    if(fadeOutTimer != nil){
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
    }
    _titleLabel.text=string;
    [self stopAnation];
    fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
}
#pragma mark - 核心动画，哪个View产生动画，动画速度（秒）
-(void)addAnimationInView:(UIView *)view duration:(NSTimeInterval)timeInterval valueWithCATransform3D:(CATransform3D)transform3D{
    //核心内容
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    //角度，x,y,z,参数
    animation.toValue = [NSValue valueWithCATransform3D:transform3D];
    animation.duration = timeInterval;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    [view.layer addAnimation:animation forKey:@"animation"];
}
//停止动画
-(void)stopAnation{
    [_centerView.layer removeAnimationForKey:@"animation"];
    [_rotateView.layer removeAnimationForKey:@"animation"];
    [_rotateView2.layer removeAnimationForKey:@"animation"];


//    //中间画面
//    [self addAnimationInView:_centerView duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
//    //圆圈
//    [self addAnimationInView:_rotateView duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
//    //圆圈
//    [self addAnimationInView:_rotateView2 duration:0 valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 0)];
}

#pragma mark - dealloc 释放定时器
- (void)dealloc{
    if(fadeOutTimer != nil){
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
    }
    NSLog(@"dealloc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//#pragma mark - 根据label的内容，计算字符串的大小
////根据换行方式和字体的大小，已经计算的范围来确定字符串的size
//-(CGSize)currentSizeWith:(NSString*)text{
//    CGFloat version=[[UIDevice currentDevice].systemVersion floatValue];
//    CGSize size;
//    //计算size， 7之后有新的方法
//    if (version>=7.0) {
//        //得到一个设置字体属性的字典
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
//        //optinos 前两个参数是匹配换行方式去计算，最后一个参数是匹配字体去计算
//        //attributes 传入的字体
//        //boundingRectWithSize 计算的范围
//        size=[text boundingRectWithSize:CGSizeMake(250, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//    }else{
//        //ios7以前
//        //根据字号和限定范围还有换行方式计算字符串的size，label中的font 和linbreak要与此一致
//        //CGSizeMake(215, 999) 横向最大计算到215，纵向Max999
//        size=[text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:NSLineBreakByCharWrapping];
//    }
//    return size;
//}
@end
