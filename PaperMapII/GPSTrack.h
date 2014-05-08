//
//  GPSTrack.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Track.h"

@interface GPSTrack : Track
@property int tripmeter;    //in meters
@property bool closed;      //true means the gps track is properly closed and saved without being interrupted by app crash
-(bool)saveNodesToFile:(int)segCount;
-(bool)readNodesFromSegmentedFiles;
-(NSString *)dataFilePathWith:(int)segCount;
-(bool)readNodes;
@end
