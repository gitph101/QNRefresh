//
//  QNHeaderRefreshView.h
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import "QNRefreshComponent.h"

@interface QNHeaderRefreshView : QNRefreshComponent

-(void)addHeaderRefreshWithRefreshBlock:(QNRefreshComponentRefreshingBlock )block position:(QNRefreshPosition)position;

- (void)stopAnimating;

@end
