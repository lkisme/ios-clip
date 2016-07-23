//
//  TabVIew.m
//
//  Created by lk on 16/7/13.
//  Copyright © 2016年 lkisme. All rights reserved.
//

#import "TabVIew.h"

@interface TabView()<UIScrollViewDelegate>

@property (assign) NSInteger tabCount;

@property (assign) CGFloat topBarHeight;

//Frame of the whole view
@property (assign) CGRect mViewFrame;

//Scroll view below the tabs on the top
@property (strong, nonatomic) UIScrollView *scrollView;

//Array to store the view inside of tabs on the top
@property (strong, nonatomic) NSMutableArray *topViews;

//Current page
@property (assign) NSInteger currentPage;

//Tab indicator
@property (strong, nonatomic) UIView *slideView;

//For the tabs on the top
@property (strong, nonatomic) UIScrollView *topScrollView;

//Super view of tabs on the top
@property (strong, nonatomic) UIView *topMainView;

//titles for tabs on the top
@property (strong, nonatomic) NSArray *titles;


@end

@implementation TabView



-(instancetype)initWithFrame: (CGRect)frame
                  WithTitles: (NSArray *) titles
                tabBarHeight: (CGFloat) height{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _mViewFrame = frame;
        _titles = titles;
        _tabCount = titles.count;
        _topViews = [[NSMutableArray alloc] init];
        _topBarHeight = height;
        _frameOfDetailView = CGRectMake(0, 0, _mViewFrame.size.width, _mViewFrame.size.height - _topBarHeight);
        
        [self initScrollView];
        
        [self initTopTabs];
        [self setupDetailViews];
        [self initSlideView];
    }
    
    return self;
}

//Subclass should override this method
-(void) setupDetailViews{
   
    
}

-(void)addDetailView:(UIView *)view{
    [_scrollView addSubview:view];
}


#pragma mark -- initialization of ScrollView
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mViewFrame.origin.y, _mViewFrame.size.width, _mViewFrame.size.height - self.topBarHeight)];
    
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - self.topBarHeight);
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark -- as the name
-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <=6){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, self.topBarHeight)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, self.topBarHeight)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 6) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, self.topBarHeight);
        
    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, self.topBarHeight);
    }
    
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    UIColor * grayBackGround = [UIColor colorWithHexString:@"#f6f6f6"];
    UIColor * buttonNormalTextColor =[UIColor colorWithHexString:@"#7b7b7b"];
    
    for (int i = 0; i < _tabCount; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, self.topBarHeight)];
        
        view.backgroundColor = grayBackGround;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, self.topBarHeight)];
        button.tag = i;
        [button setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:buttonNormalTextColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateFocused];
        //        [button setFont:[UIFont systemFontOfSize:18]];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
}

#pragma mark -- initialize indicator
-(void) initSlideView{
    
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <=6){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarHeight - 2, width, 2)];
    [_slideView setBackgroundColor: self.tintColor];
    [_topScrollView addSubview:_slideView];
}

#pragma mark -- handler of scrolling
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
}

#pragma mark -- delegate of scroll view
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        
        if (self.tabCount <= 6) {
            frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
            frame.origin.x = scrollView.contentOffset.x/6;
            
        }
        _slideView.frame = frame;
    }
    
}
-(UIView*)getDetailView{
    return self.scrollView;
}

@end
