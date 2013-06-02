//
//  Recorder.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PM2Protocols.h"
@class Track;
@interface Recorder : NSObject<PM2SingleTapHandleDelegate>

@property (nonatomic,strong) Track * track;
@property bool recording; //if it is recording

- (void)start;
- (void)stop;
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint;

@end
