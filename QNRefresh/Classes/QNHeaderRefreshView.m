//
//  QNHeaderRefreshView.m
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "QNHeaderRefreshView.h"
#import "QNRefreshComponent.h"

#define kDuration 2

@interface QNHeaderRefreshView ()

@property(nonatomic, strong)CALayer *waveLayer;
@property(nonatomic, strong)CAAnimationGroup *animationGroup;

@end

@implementation QNHeaderRefreshView


-(void)endRefresh{
    [super endRefresh];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     switch (self.state) {
        case QNRefreshStateAll:
        case QNRefreshStateStop:
            [self _qn_removeAnimationGroup];
            break;
        case QNRefreshStatePulling:
            [self _qn_addAnimationGroup];
            break;
        case QNRefreshStateRefreshing:
            [self _qn_addAnimationGroup];
            break;
    }
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
         [self _qn_waveAnimationLayerWithView:self diameter:60];
    }
    return self;
}


- (void)_qn_waveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter {
    self.waveLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    self.waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    [self.layer addSublayer:self.waveLayer];
}

-(void)_qn_addAnimationGroup{
    [self.waveLayer addAnimation:self.animationGroup forKey:@"key"];
}


-(void)_qn_removeAnimationGroup{
    [self.waveLayer removeAllAnimations];
}

#pragma mark - getting and setting

-(CALayer *)waveLayer{
    if (_waveLayer == nil) {
        _waveLayer = [CALayer layer];
        _waveLayer.backgroundColor = [[UIColor colorWithRed:64 / 255.0 green:185 / 255.0 blue:216 / 255.0 alpha:1] CGColor];
        _waveLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    return _waveLayer;
}

-(CAAnimationGroup *)animationGroup{
    if (_animationGroup = nil) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.duration = kDuration;
        _animationGroup.repeatCount = INFINITY; //重复无限次
        _animationGroup.removedOnCompletion = NO;
        
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        _animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        scaleAnimation.fromValue = @0.5; //开始的大小
        scaleAnimation.toValue = @1.3; //最后的大小
        scaleAnimation.duration = kDuration;
        scaleAnimation.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0.4; //开始的大小
        opacityAnimation.toValue = @0.0; //最后的大小
        opacityAnimation.duration = kDuration;
        opacityAnimation.removedOnCompletion = NO;
        _animationGroup.animations = @[scaleAnimation, opacityAnimation];
    }
    return _animationGroup;
}

@end
