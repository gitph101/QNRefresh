//
//  QNHeaderRefreshView.m
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "QNHeaderRefreshView.h"

@implementation QNHeaderRefreshView

-(void)drawRect:(CGRect)rect
{
    
}

- (CALayer *)waveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter duration:(CGFloat)duration {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 60, diameter, diameter);
    waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    waveLayer.position = view.center;
    waveLayer.backgroundColor = [[UIColor colorWithRed:64 / 255.0 green:185 / 255.0 blue:216 / 255.0 alpha:1] CGColor];
//    [view.superview.layer insertSublayer:waveLayer below:view.layer];//把扩散层放到播放按钮下面
    [self.layer addSublayer:waveLayer];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = INFINITY; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.7; //开始的大小
    scaleAnimation.toValue = @1.0; //最后的大小
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.4; //开始的大小
    opacityAnimation.toValue = @0.0; //最后的大小
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:@"key"];
    
    return waveLayer;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // default styling values
        [self waveAnimationLayerWithView:self diameter:60 duration:1];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        bgView.backgroundColor = [UIColor grayColor];
        [self addSubview:bgView];
    }
    return self;
}




@end
