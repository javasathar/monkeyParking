//
//  POILoopScrollView.h
//  POIScrollView
//
//  Created by zfgj on 13-12-25.
//  Copyright (c) 2013年 zfgj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol POILoopScrollViewDelegate;

@interface POILoopScrollView : UIView <UIScrollViewDelegate>
{
    UIView *_firstLoopView;
    UIView *_lastLoopView;
}
@property (nonatomic, assign) CGFloat animatedTime;                 // default 5.0f
@property (nonatomic, readonly) UIScrollView *loopScrollView;
@property (nonatomic, readonly) UIPageControl *loopPageControl;     // Can Hidden
@property (nonatomic, assign, getter = isAnimated) BOOL animated;                        // Is Need Auto Scroll
@property (nonatomic, assign) id <POILoopScrollViewDelegate> loopScrollViewDelegate;

// 载入视图
- (void)reloadData;

// 必须传入UIView,会被排除掉
- (void)addFirstLoopView:(UIView *)loopView;
- (void)addLastLoopView:(UIView *)loopView;
- (void)addLoopViewsWithArray:(NSArray *)loopViews;
- (void)addLoopViewsWithView:(UIView *)loopView;
- (void)removeAllLoopViews;

@end

@protocol POILoopScrollViewDelegate <NSObject>
@optional
- (void)loopScrollView:(POILoopScrollView *)loopScrollView didSelectWithIndex:(NSInteger)index;
@end