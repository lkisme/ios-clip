//
//  TabVIew.h
//
//  Created by lk on 16/7/13.
//  Copyright © 2016年 lkisme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabView : UIView

- (instancetype) initWithFrame: (CGRect)frame
                  WithTitles: (NSArray *) titles
                tabBarHeight: (CGFloat) height;

- (void) addDetailView: (UIView *)view;

- (UIView*) getDetailView;

@property (nonatomic, readonly) CGRect frameOfDetailView;

@end
