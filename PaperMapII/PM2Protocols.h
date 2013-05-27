//
//  PM2Protocols.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TapDetectView;
@protocol PM2MapSourceDelegate <NSObject>
@optional
- (UIImage *)mapLevel:(int)mapLevel row:(int)row col:(int)col;
@end

@protocol PM2SingleTapHandleDelegate <NSObject>
@optional
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint;
@end

@protocol PM2MapTapHandleDelegate <NSObject>
@optional
//- (void)tapDetectView:(TapDetectView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectView:(TapDetectView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectView:(TapDetectView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;
@end