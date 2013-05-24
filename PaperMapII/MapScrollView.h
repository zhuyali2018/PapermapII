//
//  MapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZoomView.h"

@interface MapScrollView : UIScrollView <UIScrollViewDelegate>{
    NSMutableSet    *reusableTiles;					//<======= recycled tiles holder
    BOOL            Mode;                           //<====TRUE: Western, FALSE:Eastern
    int             maplevel,minMapLevel,maxMapLevel,lastLevel;
    CGPoint			posErr,posErr1;
}
@property (nonatomic)ZoomView *zoomView;

- (UIView *)dequeueReusableTile;

@end
