//
//  GPSTrack.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Track.h"
#import "GPSNode.h"

@interface GPSTrack : Track
@property (nonatomic,strong) NSArray * gpsNodes;
@end
