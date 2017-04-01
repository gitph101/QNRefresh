//
//  QNRefreshComponent.m
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "QNRefreshComponent.h"


@interface QNRefreshComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation QNRefreshComponent

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // default styling values
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = QNRefreshStateStop;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [self removeObservers];
        [self addObservers];
    }
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];;
}




@end
