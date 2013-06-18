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
        [self setMultipleTouchEnabled:YES];
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
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 246, 50)];
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
	}else{  //if already has a tag, just change the text ! Without this else, you can see which tile is the recycled one !
        [label setText:[NSString stringWithFormat:@"level %d,(%d,%d)",res,row,col]];
    }
}
@end
