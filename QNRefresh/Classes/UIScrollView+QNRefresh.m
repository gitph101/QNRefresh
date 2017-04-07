//
//  UIScrollView+QNRefresh.m
//  Pods
//
//  Created by 研究院01 on 17/4/7.
//
//

#import "UIScrollView+QNRefresh.h"
#import "QNHeaderRefreshView.h"
#import "QNFooterRefreshView.h"
#import "QNRefreshComponent.h"
#import <objc/runtime.h>

static char QNHeaderRefreshViewString;
static char QNFooterRefreshViewString;

static CGFloat const QNRefreshViewHeight = 60;

typedef void (^QNRefreshComponentRefreshingBlock)();


@implementation UIScrollView (QNRefresh)

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block
{
    if (!self.headerRefreshView) {
        [self _qn_addRefreshWithRefreshBlock:block position:QNRefreshPositionTop];
    }
}

-(void)addFooterRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block
{
    if (!self.footerRefreshView) {
        [self _qn_addRefreshWithRefreshBlock:block position:QNRefreshPositionBottom];
    }
}

-(void)_qn_addRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block position:(QNRefreshPosition)position
{
    CGFloat yOrigin;
    switch (position) {
        case QNRefreshPositionTop:
        {
            yOrigin = -QNRefreshViewHeight;
            QNHeaderRefreshView *view = [[QNHeaderRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, QNRefreshViewHeight)];
            view.refreshingBlock = block;
            view.scrollView = self;
            view.position = QNRefreshPositionTop;
            view.originalTopInset = self.contentInset.top;
            view.originalBottomInset = self.contentInset.bottom;
            self.headerRefreshView = view;
            [self addSubview:view];
        }
            break;
        case QNRefreshPositionBottom:
        {
            yOrigin = self.contentSize.height;
            QNFooterRefreshView *view = [[QNFooterRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, QNRefreshViewHeight)];
            view.refreshingBlock = block;
            view.scrollView = self;
            view.position = QNRefreshPositionBottom;
            view.originalTopInset = self.contentInset.top;
            view.originalBottomInset = self.contentInset.bottom;
            self.footerRefreshView = view;
            [self addSubview:view];

        }
            break;
        default:
            return;
    }
}

-(void)endRefresh {
    [self.headerRefreshView endRefresh];
    [self.footerRefreshView endRefresh];
}

#pragma mark - property

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


- (void)setFooterRefreshView:(QNFooterRefreshView *)footerRefreshView{
    [self willChangeValueForKey:@"QNFooterRefreshView"];
    objc_setAssociatedObject(self, &QNFooterRefreshViewString,
                             footerRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"QNFooterRefreshView"];
}


- (QNFooterRefreshView *)footerRefreshView {
    return objc_getAssociatedObject(self, &QNFooterRefreshViewString);
}


@end
