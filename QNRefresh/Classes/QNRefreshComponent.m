//
//  QNRefreshComponent.m
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "QNRefreshComponent.h"

static CGFloat const QNRefreshViewHeight = 60;

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

@interface QNRefreshComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation QNRefreshComponent

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
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    [self addObservers];
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
}

- (void)removeObservers
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];;
}

-(void)endRefresh
{
    self.state = QNRefreshStateStop;
}

- (void)beginRefresh
{
    self.state = QNRefreshStatePulling;
}

-(void)setState:(QNRefreshState)state{
    _state = state;
    switch (state) {
        case QNRefreshStateStop:
        case QNRefreshStateAll:
            [self stopAnimating];
            break;
        case QNRefreshStatePulling:
            break;
        case QNRefreshStateRefreshing:
            [self startAnimating];
            break;
        default:
            break;
    }
    [self layoutSubviews];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {        
        [self layoutSubviews];
        CGFloat yOrigin;
        switch (self.position) {
            case QNRefreshPositionTop:
                yOrigin = -QNRefreshViewHeight;
                break;
            case QNRefreshPositionBottom:
                yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                break;
        }
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, QNRefreshViewHeight);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    
    if(self.state != QNRefreshStateRefreshing) {
        CGFloat scrollOffsetThreshold = 0;
        switch (self.position) {
            case QNRefreshPositionTop:
                scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
                break;
            case QNRefreshPositionBottom:
                scrollOffsetThreshold = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.bounds.size.height + self.originalBottomInset;
                break;
        }
        
        if(!self.scrollView.isDragging && self.state == QNRefreshStatePulling)
            self.state = QNRefreshStateRefreshing;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == QNRefreshStateStop && self.position == QNRefreshPositionTop)
            self.state = QNRefreshStatePulling;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != QNRefreshStateStop && self.position == QNRefreshPositionTop)
            self.state = QNRefreshStateStop;
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == QNRefreshStateStop && self.position == QNRefreshPositionBottom)
            self.state = QNRefreshStatePulling;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != QNRefreshStateStop && self.position == QNRefreshPositionBottom)
            self.state = QNRefreshStateStop;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        switch (self.position) {
            case QNRefreshPositionTop:
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                break;
            case QNRefreshPositionBottom:
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
                    offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                } else if (1/*self.wasTriggeredByUser*/) {
                    offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
                break;
        }
    }
}

- (void)startAnimating{
    switch (self.position) {
        case QNRefreshPositionTop:
            if(fequalzero(self.scrollView.contentOffset.y)) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
            }
            else
                break;
        case QNRefreshPositionBottom:
            if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
               || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
                [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
            }
            else
                break;
    }
    
}

- (void)stopAnimating {
    switch (self.position) {
        case QNRefreshPositionTop:
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
            break;
        case QNRefreshPositionBottom:
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
            break;
    }
}



@end
