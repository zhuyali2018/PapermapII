//
//  Recorder.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Recorder.h"
#import "Track.h"
#import "LineProperty.h"
#import "Node.h"
@implementation Recorder
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _recording=false;
    }
    return self;
}
- (void)start:(LineProperty *)prop{
    if (_recording) {
        return;
    }
    _track=[[Track alloc] init];
    if (!_track) {
        return;
    }
    _recording=true;
    self.track.lineProperty=prop;
}
- (void)stop{
    _recording=false;
}
#pragma mark ------------------PM2RecordingDelegate method---------

- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint{
    NSLog(@"gotSingleTapAtPoint in recoder - need to store the tapped point here");
    Node *node=[[Node alloc]initWithPoint:tapPoint mapLevel:maplevel];
    if (!self.track.nodes) {
        self.track.nodes=[[NSArray alloc]initWithObjects:node,nil];
    }else{
        self.track.nodes=[self.track.nodes arrayByAddingObject:node];
    }
}
@end
