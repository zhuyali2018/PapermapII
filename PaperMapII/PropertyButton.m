//
//  PropertyButton.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "PropertyButton.h"

@implementation PropertyButton
@synthesize titleLabel;
@synthesize lineProperty;
@synthesize ID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[self setFrame:frame];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 2, 300, 25)];
        
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor lightGrayColor]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)drawLineFrom:(CGPoint) p0 to:(CGPoint)p1 withColor:(UIColor *)color andWidth:(CGFloat)width{
	//Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	//Set the width of the pen mark
	CGContextSetLineWidth(context, width);
	// Draw a line
	//Start at this point
	CGContextMoveToPoint(context, p0.x, p0.y);
	//(move "pen" around the hikkkklscreen)Ï
	CGContextAddLineToPoint(context, p1.x, p1.y);
	CGContextStrokePath(context);
	//layoutIfNeeded
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(!lineProperty) return;
    // Drawing code
	CGRect fr=[self frame];
	CGFloat w=fr.size.width;
	CGFloat h=fr.size.height;
	CGPoint p1=CGPointMake(15, h*2/3);
	CGPoint p2=CGPointMake(w-15,h*2/3);
	UIColor * color=[UIColor colorWithRed:lineProperty.red
									green:lineProperty.green
									 blue:lineProperty.blue
									alpha:lineProperty.alpha];
	[self drawLineFrom:p1 to:p2 withColor:color andWidth:lineProperty.lineWidth];
}


@end
