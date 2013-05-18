//
//  TileContainer.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TileContainer.h"
#import "MapTile.h"
@implementation TileContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        MapTile * mapTile1=[[MapTile alloc]initWithFrame:CGRectMake(0,0, 256, 256)];
        MapTile * mapTile2=[[MapTile alloc]initWithFrame:CGRectMake(0,256, 256, 256)];
        MapTile * mapTile3=[[MapTile alloc]initWithFrame:CGRectMake(256,0, 256,256)];
        MapTile * mapTile4=[[MapTile alloc]initWithFrame:CGRectMake(256,256, 256, 256)];
        [self annotateTile:mapTile1 res:1 row:0 col:0];
        [self annotateTile:mapTile2 res:1 row:0 col:1];
        [self annotateTile:mapTile3 res:1 row:1 col:0];
        [self annotateTile:mapTile4 res:1 row:1 col:1];
        [mapTile1 setImage:[UIImage imageNamed:@"Map1_0_0.png"]];
        [mapTile2 setImage:[UIImage imageNamed:@"Map1_0_1.png"]];
        [mapTile3 setImage:[UIImage imageNamed:@"Map1_1_0.png"]];
        [mapTile4 setImage:[UIImage imageNamed:@"Map1_1_1.png"]];
        [self addSubview:mapTile1];
        [self addSubview:mapTile2];
        [self addSubview:mapTile3];
        [self addSubview:mapTile4];
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
- (void)annotateTile:(UIImageView *)tile res:(int)res row:(int)row col:(int)col{
	UILabel *label = (UILabel *)[tile viewWithTag:3];
	if (!label) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 128, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTag:3];
        [label setTextColor:[UIColor greenColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label setFont:[UIFont boldSystemFontOfSize:20]];
		[label setText:[NSString stringWithFormat:@"level %d,(%d,%d)",res,row,col]];
		[tile addSubview:label];
		[[tile layer] setBorderWidth:2];
		[[tile layer] setCornerRadius:10];	//yali added to test
		[[tile layer] setBorderColor:[[UIColor greenColor] CGColor]];
	}
}
@end
