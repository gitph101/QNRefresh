//
//  UIScrollView+QNHeaderRefresh.h
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import <UIKit/UIKit.h>

@class QNHeaderRefreshView;
@interface UIScrollView (QNHeaderRefresh)

@property (nonatomic, strong, readonly) QNHeaderRefreshView *headerRefreshView;

@end
