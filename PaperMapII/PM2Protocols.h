//
//  PM2Protocols.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TapDetectView;
@class MapTile;

@protocol PM2MapSourceDelegate <NSObject>
@optional
- (void)mapTile:(MapTile *)tile;
- (bool)setMapSourceType:(int)mapType1;
@end

@protocol PM2SingleTapHandleDelegate <NSObject>
@optional
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint;
@end

@protocol PM2MapTapHandleDelegate <NSObject>
@optional
//- (void)tapDetectView:(TapDetectView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectView:(UIView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectView:(UIView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;
@end

@protocol PM2RecordingDelegate <NSObject>
@optional
- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint;
- (BOOL)getPOICreating;
- (BOOL)getPOIMoving;
@end

@protocol OnOffBnDelegate <NSObject>
@optional
- (void)launchThisFn:(NSString *)fn;
@end