//
//  Recorder.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Recorder.h"
#import "Track.h"

@implementation Recorder
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _recording=false;
    }
    return self;
}
- (void)start{
    if (_recording) {
        return;
    }
    _track=[[Track alloc] init];
    if (!_track) {
        return;
    }
    _recording=true;
}
- (void)stop{
    _recording=false;
}
#pragma mark -----------------HandleSingleTap Delegate method------
- (void)tappedView:(UIView *)view singleTapAtPoint:(CGPoint)tapPoint{
    if(!_recording)return;
}
@end
