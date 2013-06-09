//
//  DrawingBoard.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "DrawingBoard.h"


@implementation DrawingBoard



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
}
*/

//-(void)registTrack:(Track*)track{
//    if (!self.tracks) {
//        self.tracks=[[NSArray alloc]initWithObjects:track,nil];
//    }else{
//        self.tracks=[self.tracks arrayByAddingObject:track];
//    }
//}
@end
