//
//  OnScreenMeter.m
//  PaperMapII
//
//  Created by Yali Zhu on 8/21/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "OnScreenMeter.h"

@implementation OnScreenMeter
@synthesize unitLabel,titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]];
        [self setTextColor:[UIColor yellowColor]];
        [self setShadowColor:[UIColor blackColor]];
        [self setShadowOffset:CGSizeMake(2.0, 2.0)];
        [self setFont:[UIFont boldSystemFontOfSize:20]];
        [self setText:[NSString stringWithFormat:@" %4.1f  ",128.267]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        unitLabel=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 20)];
        [unitLabel setBackgroundColor:[UIColor clearColor]];
        [unitLabel setTextColor:[UIColor whiteColor]];
        [unitLabel setFont:[UIFont italicSystemFontOfSize:12]];
        [unitLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:unitLabel];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont italicSystemFontOfSize:12]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];

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
