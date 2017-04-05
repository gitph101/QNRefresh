//
//  UIScrollView+QNHeaderRefresh.h
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import <UIKit/UIKit.h>
#import "QNRefreshComponent.h"

@class QNHeaderRefreshView;

@interface UIScrollView (QNHeaderRefresh)

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block position:(QNRefreshPosition)position;
@property (nonatomic, strong, readonly) QNHeaderRefreshView *headerRefreshView;

@end
