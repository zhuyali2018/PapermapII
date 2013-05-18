//
//  MapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZoomView.h"

@interface MapScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic)ZoomView *zoomView;

@end
