//
//  UIScrollView+QNRefresh.h
//  Pods
//
//  Created by 研究院01 on 17/4/7.
//
//

#import <UIKit/UIKit.h>
#import "QNRefreshComponent.h"

@class QNHeaderRefreshView;
@class QNFooterRefreshView;

@interface UIScrollView (QNRefresh)

@property (nonatomic, strong) QNHeaderRefreshView *headerRefreshView;

@property (nonatomic, strong) QNFooterRefreshView *footerRefreshView;

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block;

-(void)addFooterRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block;

@end
