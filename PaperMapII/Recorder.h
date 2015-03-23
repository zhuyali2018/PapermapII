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
@property (nonatomic,strong) NSMutableArray * poiArray;
@property (nonatomic,strong) Track * track;
@property (nonatomic,strong) GPSTrack * gpsTrack;
@property (nonatomic,strong) GPSNode * lastGpsNode;
@property bool recording; //if it is recording
@property bool gpsRecording; //if it is recording
@property bool POICreating;
@property bool POIMoving;
@property bool userBusy;
@property NSDate * gpsStartTime;       //creating gps starting date and time
//----------added for saving safety---------------
@property (nonatomic,strong) GPSTrack * currentTrackSegment;
@property int currentTrackSegmentNodeCount;
@property int trackSegmentCount;
//=========================
- (void) start;
- (void) stop;
- (void) mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint;
- (void) startNewTrack;
- (void) undo;

- (void)addAMonthNamedFolder;
- (void)gpsStart;
- (void)gpsStop;
- (void)deleteTempFiles;
- (void)unloadTracks;
- (void)unloadGPSTracks;
- (void)unloadDrawings;

- (void)saveAllTracks;
- (void)saveAllTracksTo:(NSString *)filePath;

- (void)saveAllGpsTracks;
- (void)saveAllGpsTracksTo:(NSString *)filePath;

- (void)saveAllPOIs;
- (void)saveAllPOIsTo:(NSString *)filePath;

- (void)loadAllTracksFrom:(NSString *)filePath;
- (void)loadAllGPSTracksFrom:(NSString *)filePath;
- (void)loadAllPOIsFrom:(NSString *)filePath;

- (void)initializeAllTracks;
- (void)initializeAllGpsTracks;
- (void)initializeAllPOIs;

- (double)GetScreenY:(double)lat;
//- (void)centerPositionAtX:(int) x Y:(int) y;

+(Recorder *)sharedRecorder;
+(NSMutableArray *)loadMutableArrayFrom:(NSString *)filePath withKey:(NSString *)key;
-(NSArray*) addAnyModeAdjustedNode:(NSArray*)arrNodes Node:(Node *)node Mode:(bool)mode;

-(void) addDrawingFile:(NSString *)fn;
-(void) loadGPSTrackFromFile:(NSString *)fn;
-(void) loadPOIFile:(NSString *)fn;

@end
