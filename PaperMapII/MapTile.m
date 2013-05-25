//
//  MapTile.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MapTile.h"

@implementation MapTile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        row=-1;    //means image in recycle pool
		col=0;
		res=0;
        [self setBackgroundColor:[UIColor clearColor]];     //<===important, if not set clear, the map tiles beneath it won't show up
    }
    return self;
}

@synthesize row,col,res;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
