//
//  Recorder.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
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
    //initialize track
    _track=[[Track alloc] init];
    if (!_track) {
        return;
    }
    _recording=true;
    self.track.lineProperty=prop;
    if(!self.trackArray){   //when first time starting recorder, ini track array
        self.trackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.trackArray addObject:self.track];
    }else{
        [self.trackArray addObject:self.track];
    }
    NSMutableArray *tar=(NSMutableArray *)self.track.nodes;
    [tar removeAllObjects];
    self.track.nodes = tar;
}
- (void)stop{
    _recording=false;
}
#pragma mark ------------------PM2RecordingDelegate method---------

- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint{
    //NSLOG3(@"gotSingleTapAtPoint in recoder - need to store the tapped point here");
    if(!_recording){   //if not recording, do not create the node for the tappoint
        //[self start:[self.track.lineProperty copy]];  //TODO: Remove this test statement
        return;
    }
    Node *node=[[Node alloc]initWithPoint:tapPoint mapLevel:maplevel];
    if (!self.track.nodes) {
        self.track.nodes=[[NSArray alloc]initWithObjects:node,nil];
    }else{
        self.track.nodes=[self.track.nodes arrayByAddingObject:node];
    }
    //TODO: remove following test statements
    NSLOG4(@"Nodes cout=%d",[self.track.nodes count]);
    
    //if([self.track.nodes count]>3)
    //    [self stop];
}
@end
