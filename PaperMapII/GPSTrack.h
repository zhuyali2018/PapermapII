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

-(bool)saveNodesToFile:(int)segCount;
-(NSString *)dataFilePathWith:(int)segCount;
@end
