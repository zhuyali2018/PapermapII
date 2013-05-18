//
//  ZoomView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileContainer.h"

@interface ZoomView : UIView

@property (nonatomic)TileContainer *tileContainer;

@property (nonatomic)UIView *v, *v1;

@end
