    //
//  CompassButton.m
//  TwoDGPS
//
//  Created by zhuyali on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CompassButton.h"
#import "PM2OnScreenButtons.h"
#import "AllImports.h"

@implementation CompassButton

@synthesize direction;
@synthesize arrow1;
@synthesize arrowCenter;
@synthesize centerButton;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Custom initialization
		arrow1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Compass.png"]];
		arrow1.center=CGPointMake(30, 30);
        arrowCenter=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"YellowCenter.png"]];
		arrowCenter.center=CGPointMake(30, 30);
		[self addSubview:arrow1];
        [self addSubview:arrowCenter];
        arrowCenter.hidden=YES;
		centerButton=[UIButton buttonWithType:UIButtonTypeCustom];
		[centerButton setFrame:CGRectMake(0,0, 60, 60)];
		//[centerButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
		//[self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
		[self setBackgroundColor:[UIColor clearColor]];
		[centerButton addTarget:[PM2OnScreenButtons sharedBnManager] action:@selector(centerCurrentPosition:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:centerButton];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {	
	CGAffineTransform transform = CGAffineTransformMakeRotation(-3.1415926f/2+direction);
	[UIView beginAnimations:nil context:nil];
	arrow1.transform=transform;
	[UIView commitAnimations];	
}


@end
