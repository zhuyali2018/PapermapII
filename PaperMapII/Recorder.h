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
@class LineProperty;
@interface Recorder : NSObject<PM2RecordingDelegate>

@property (nonatomic,strong) NSMutableArray * trackArray;
@property (nonatomic,strong) Track * track;
@property bool recording; //if it is recording

- (void) start;
- (void) stop;
- (void) mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint;
- (void) startNewTrack;
- (void) undo;

+ (id)sharedRecorder;

@end
