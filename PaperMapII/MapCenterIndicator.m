//
//  MapCenterIndicator.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MapCenterIndicator.h"
#import "Settings.h"

@implementation MapCenterIndicator

@synthesize bShowCenter;
static MapCenterIndicator *sharedMyManager = nil;
+ (id)sharedMapCenter:(CGRect)frame{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initWithFrame:frame];
    });
    [sharedMyManager setFrame:frame];
    sharedMyManager.hidden=(![[Settings sharedSettings] getSetting:SHOW_MAP_CENTER]);
    return sharedMyManager;
}
+ (id)sharedMapCenter{
    //static MapCenterIndicator *sharedMyManager = nil;
    sharedMyManager.hidden=(![[Settings sharedSettings] getSetting:SHOW_MAP_CENTER]);
    return sharedMyManager;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bShowCenter=true;
        [self setBackgroundColor:[UIColor clearColor]];  //or it will block map underneath
        [self setEnabled:FALSE];   //so that it wont block the touch gestures on the map underneath, use UIControl as UIView
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
	//(move "pen" around the screen)
	CGContextAddLineToPoint(context, p1.x, p1.y);
	CGContextStrokePath(context);
	//layoutIfNeeded
	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	if(bShowCenter){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self drawLineFrom:CGPointMake(04,10) to:CGPointMake(16, 10) withColor:[UIColor yellowColor] andWidth:3];
            [self drawLineFrom:CGPointMake(10,04) to:CGPointMake(10, 16) withColor:[UIColor yellowColor] andWidth:3];
            
            [self drawLineFrom:CGPointMake(5,10) to:CGPointMake(15, 10) withColor:[UIColor blueColor] andWidth:1];
            [self drawLineFrom:CGPointMake(10, 5) to:CGPointMake(10, 15) withColor:[UIColor blueColor] andWidth:1];
            return;
        }
        [self drawLineFrom:CGPointMake(0,10) to:CGPointMake(20, 10) withColor:[UIColor yellowColor] andWidth:5];
		[self drawLineFrom:CGPointMake(10, 0) to:CGPointMake(10, 20) withColor:[UIColor yellowColor] andWidth:5];
        
        [self drawLineFrom:CGPointMake(2,10) to:CGPointMake(18, 10) withColor:[UIColor blueColor] andWidth:1];
		[self drawLineFrom:CGPointMake(10, 2) to:CGPointMake(10, 18) withColor:[UIColor blueColor] andWidth:1];
	}
}
@end
