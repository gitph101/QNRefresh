//
//  QNRefreshComponent.h
//  Pods
//
//  Created by 研究院01 on 17/4/1.
//
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, QNRefreshState) {
    /** 普通闲置状态 */
    QNRefreshStateStop = 1,
    /** 松开就可以进行刷新的状态 */
    QNRefreshStatePulling,
    /** 正在刷新中的状态 */
    QNRefreshStateRefreshing,
    /** 即将刷新的状态 */
    QNRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    QNRefreshStateAll
};

typedef NS_ENUM(NSUInteger, QNRefreshPosition) {
    QNRefreshPositionTop = 0,
    QNRefreshPositionBottom,
};


/** 进入刷新状态的回调 */
typedef void (^QNRefreshComponentRefreshingBlock)();

@interface QNRefreshComponent : UIView

///父视图
@property(nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) QNRefreshState state;

@property (nonatomic, assign) QNRefreshPosition position;

@property (copy, nonatomic) QNRefreshComponentRefreshingBlock refreshingBlock;

@property (nonatomic, readwrite) CGFloat originalTopInset;

@property (nonatomic, readwrite) CGFloat originalBottomInset;

-(void)endRefresh;
- (void)beginRefresh;

@end
