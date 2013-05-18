//
//  ZoomView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "ZoomView.h"

@implementation ZoomView
@synthesize tileContainer;
@synthesize v,v1;

extern const int bz;        //bezel width, should be set to 0 eventually
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tileContainer=[[TileContainer alloc] initWithFrame:CGRectMake(bz,bz,1000, 1000)];
        [tileContainer setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:tileContainer];
        
//        v=[[UIView alloc] initWithFrame:CGRectMake(bz, bz, 256, 256)];
//        [v setBackgroundColor:[UIColor greenColor]];
//        [tileContainer addSubview:v];
//        v1=[[UIView alloc] initWithFrame:CGRectMake(300,300, 256, 256)];
//        [v1 setBackgroundColor:[UIColor cyanColor ]];
//        [tileContainer addSubview:v1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
