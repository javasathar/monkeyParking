//
//  POILoopScrollView.m
//  POIScrollView
//
//  Created by zfgj on 13-12-25.
//  Copyright (c) 2013年 zfgj. All rights reserved.
//

#import "POILoopScrollView.h"

#define AnimatedTime 5.0f

@interface POILoopScrollView ()
{
    NSMutableArray *_loopViews;
    CGFloat _times;
    BOOL _isScrolling;
}
@end

@implementation POILoopScrollView

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _loopViews = [[NSMutableArray alloc] init];
        
        _animated = NO;
        
        _animatedTime = AnimatedTime;
        
        _times = 0.0f;
        
        _isScrolling = NO;
        
        [self loadView];
        
        [self reloadData];
    }
    return self;
}

- (void)dealloc
{
    [_loopScrollView removeFromSuperview];
    [_loopViews removeAllObjects];
    [_loopPageControl removeFromSuperview];
}

#pragma mark - Load View
- (void)loadView {
    _loopScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_loopScrollView setBackgroundColor:[UIColor clearColor]];
    [_loopScrollView setDelegate:self];
    [_loopScrollView setPagingEnabled:YES];
    [_loopScrollView setShowsHorizontalScrollIndicator:NO];
    [_loopScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_loopScrollView];
    
    UITapGestureRecognizer *loopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopViewDidSelectd)];
    [_loopScrollView addGestureRecognizer:loopTap];
    
    _loopPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.frame.size.height-15, self.frame.size.width-20, 10)];
    [_loopPageControl setUserInteractionEnabled:NO];
    [_loopPageControl setBackgroundColor:[UIColor clearColor]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [_loopPageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_loopPageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    [_loopPageControl setNumberOfPages:0];
    [_loopPageControl setCurrentPage:0];
    [self addSubview:_loopPageControl];
}

#pragma mark - Show View
- (void)reloadData {
    for (UIView *loopView in [_loopScrollView subviews]) {
        if ([loopView isKindOfClass:[UIView class]]) {
            [loopView removeFromSuperview];
        }
    }
    
    [_loopScrollView setContentOffset:CGPointZero animated:NO];
    
    if (_loopViews.count > 0) {
        // 已经有保证是 UIview了。
        
        for (NSInteger i = 0; i < _loopViews.count; i ++) {
            UIView *loopView = [_loopViews objectAtIndex:i];
            [loopView setFrame:CGRectMake((i+1)*_loopScrollView.frame.size.width, 0, _loopScrollView.frame.size.width, _loopScrollView.frame.size.height)];
            [loopView setUserInteractionEnabled:NO];
            [_loopScrollView addSubview:loopView];
        }
        
        // 添加头跟尾
        [_lastLoopView setFrame:CGRectMake(0, 0, _loopScrollView.frame.size.width, _loopScrollView.frame.size.height)];
        [_lastLoopView setUserInteractionEnabled:NO];
        [_loopScrollView addSubview:_lastLoopView];
        
        [_firstLoopView setFrame:CGRectMake((_loopViews.count+1)*_loopScrollView.frame.size.width, 0, _loopScrollView.frame.size.width, _loopScrollView.frame.size.height)];
        [_firstLoopView setUserInteractionEnabled:NO];
        [_loopScrollView addSubview:_firstLoopView];
        
        [_loopScrollView setContentSize:CGSizeMake((_loopViews.count+2)*_loopScrollView.frame.size.width, _loopScrollView.frame.size.height)];
        
        [_loopPageControl setNumberOfPages:_loopViews.count];
        
        [_loopScrollView setContentOffset:CGPointMake(_loopScrollView.frame.size.width, 0) animated:NO];
        _isScrolling = NO;
        
        if (_animated == YES) {
            [self performSelector:@selector(loopScrollAnimated) withObject:Nil afterDelay:_animatedTime];
        }
    }
}

#pragma mark - Loop View Event
- (void)addFirstLoopView:(UIView *)loopView {
    _firstLoopView = loopView;
}
- (void)addLastLoopView:(UIView *)loopView {
    _lastLoopView = loopView;
}

- (void)addLoopViewsWithArray:(NSArray *)loopViews {
    if ([loopViews isKindOfClass:[NSArray class]]) {
        for (UIView *loopView in loopViews) {
            if ([loopView isKindOfClass:[UIView class]]) {
                [_loopViews addObject:loopView];
            } else {
                NSLog(@"loopView isn't UIView Class, %@",loopView);
            }
        }
    }
}

- (void)addLoopViewsWithView:(UIView *)loopView {
    if ([loopView isKindOfClass:[UIView class]]) {
        [_loopViews addObject:loopView];
    }
}

- (void)removeAllLoopViews {
    [_loopViews removeAllObjects];
}

#pragma mark - Animated
- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    // 如果需要 设置完属性就做动画，就打开吧. 暂时reloadData之后才有动画
//    if (_isAnimated == YES) {
//        [self performSelector:@selector(loopScrollAnimated) withObject:Nil afterDelay:_animatedTime];
//    }
}

- (void)loopScrollAnimated {
    _times ++;
    if (_animated == YES && _times >= _animatedTime) {
        CGFloat offsetX = _loopScrollView.contentOffset.x;
        NSInteger page = offsetX / _loopScrollView.frame.size.width;
        [_loopScrollView setContentOffset:CGPointMake(_loopScrollView.frame.size.width*(page+1), 0) animated:YES];
    }
    [self performSelector:@selector(loopScrollAnimated) withObject:Nil afterDelay:1];
}

#pragma mark - View To UIImage
- (UIImage *)imageConvertWithView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger page = (offsetX + scrollView.frame.size.width / 2) / scrollView.frame.size.width;
    
    if (offsetX < (scrollView.frame.size.width * 0.5)) {
        page = _loopViews.count;
    }
    if (scrollView.contentOffset.x > (scrollView.frame.size.width * _loopViews.count + scrollView.frame.size.width / 2)) {
        page = 1;
    }
    
    [_loopPageControl setCurrentPage:page-1];
    
    if (offsetX <= 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * _loopViews.count, 0) animated:NO];
    } else if (offsetX >= scrollView.contentSize.width - scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    }
    
    
    if ((int)scrollView.contentOffset.x % (int)scrollView.frame.size.width) {
        // 如果刚好到边界每页的边界, 这样每次如果自己手动滑动，就会重新计算动画时间
        _times = 0;
    }
    
    if ((scrollView.contentOffset.x / scrollView.frame.size.width) == ((int)scrollView.contentOffset.x / (int)scrollView.frame.size.width)) {
        _isScrolling = NO;
    } else {
        _isScrolling = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrolling = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isScrolling = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isScrolling = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _isScrolling = NO;
}

- (void)loopViewDidSelectd {
    if (_isScrolling == NO) {
        CGFloat offsetX = _loopScrollView.contentOffset.x;
        NSInteger page = (offsetX + _loopScrollView.frame.size.width / 2) / _loopScrollView.frame.size.width;
        if (_loopScrollViewDelegate && [_loopScrollViewDelegate respondsToSelector:@selector(loopScrollView:didSelectWithIndex:)]) {
            [_loopScrollViewDelegate loopScrollView:self didSelectWithIndex:page-1];
        }
    }
}

@end
