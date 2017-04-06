//
//  UIScrollView+QNHeaderRefresh.m
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "UIScrollView+QNHeaderRefresh.h"
#import "QNHeaderRefreshView.h"
#import "QNRefreshComponent.h"
#import <objc/runtime.h>

static char QNHeaderRefreshViewString;
static CGFloat const QNRefreshViewHeight = 60;

typedef void (^QNRefreshComponentRefreshingBlock)();


@implementation UIScrollView (QNHeaderRefresh)

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block
{
    [self addHeaderRefreshWithRefreshBlock:block position:QNRefreshPositionTop];
}

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block position:(QNRefreshPosition)position
{
    if (!self.headerRefreshView) {
        CGFloat yOrigin;
        switch (position) {
            case QNRefreshPositionTop:
                yOrigin = -QNRefreshViewHeight;
                break;
            case QNRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            default:
                return;
        }
        QNHeaderRefreshView *view = [[QNHeaderRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, QNRefreshViewHeight)];
        view.refreshingBlock = block;
        view.scrollView = self;
        [self addSubview:view];
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        self.headerRefreshView = view;
    }
}

-(void)endRefresh {
    [self.headerRefreshView endRefresh];
}

- (void)setHeaderRefreshView:(QNHeaderRefreshView *)headerRefreshView {
    [self willChangeValueForKey:@"QNHeaderRefreshView"];
    objc_setAssociatedObject(self, &QNHeaderRefreshViewString,
                             headerRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"QNHeaderRefreshView"];
}


- (QNHeaderRefreshView *)headerRefreshView {
    return objc_getAssociatedObject(self, &QNHeaderRefreshViewString);
}

- (void)startAnimating{
    
}
@end
