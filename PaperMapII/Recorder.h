//
//  Recorder.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CoreLocation/CoreLocation.h>
#import "PM2Protocols.h"
@class Track;
@class LineProperty;
@class GPSTrack;
@class Node;
@class GPSNode;

@interface Recorder : NSObject<PM2RecordingDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) NSMutableArray * trackArray;
@property (nonatomic,strong) NSMutableArray * gpsTrackArray;
@property (nonatomic,strong) Track * track;
@property (nonatomic,strong) GPSTrack * gpsTrack;
@property (nonatomic,strong) GPSNode * lastGpsNode;
@property bool recording; //if it is recording
@property bool gpsRecording; //if it is recording

- (void) start;
- (void) stop;
- (void) mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint;
- (void) startNewTrack;
- (void) undo;

- (void)gpsStart;
- (void)gpsStop;
- (void)unloadTracks;
- (void)unloadGPSTracks;
- (void)unloadDrawings;
- (void)saveAllTracks;
- (void)saveAllGpsTracks;
- (void)initializeAllTracks;
- (void)initializeAllGpsTracks;
- (double)GetScreenY:(double)lat;
//- (void)centerPositionAtX:(int) x Y:(int) y;

+ (Recorder *)sharedRecorder;
-(NSArray*) addAnyModeAdjustedNode:(NSArray*)arrNodes Node:(Node *)node Mode:(bool)mode;
@end
