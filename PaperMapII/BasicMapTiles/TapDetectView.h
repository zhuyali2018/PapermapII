//
//  TapDetectView.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PM2SingleTapHandleDelegate;
@protocol PM2MapTapHandleDelegate;
@interface TapDetectView : UIView{
    CGPoint tapLocation;         // Needed to record location of single tap, which will only be registered after delayed perform.
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).
}
@property (nonatomic) id<PM2SingleTapHandleDelegate> drawDelegate;
@property (nonatomic) id<PM2MapTapHandleDelegate> mapTapHandler;
- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;

-(void)userDone;
@end
