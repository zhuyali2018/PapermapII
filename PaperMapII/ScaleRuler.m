//
//  ScaleRuler.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "ScaleRuler.h"

@implementation ScaleRuler

@synthesize len,mid,end,bMetric;
@synthesize startPoint,middlePoint,endPoint,unitLabel;

+(id)shareScaleRuler:(CGRect)frame{
    static ScaleRuler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initWithFrame:frame];
    });
    return sharedMyManager;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setFrame:frame];
		len=500;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            startPoint=[[UILabel alloc]initWithFrame:CGRectMake(5,-3,20,20)];
            middlePoint=[[UILabel alloc]initWithFrame:CGRectMake(0,-3,20,20)];
            endPoint=[[UILabel alloc]initWithFrame:CGRectMake(0,-3,20,20)];
            unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,3,20,20)];
        }else{
            startPoint=[[UILabel alloc]initWithFrame:CGRectMake(5,0,20,20)];
            middlePoint=[[UILabel alloc]initWithFrame:CGRectMake(0,0,20,20)];
            endPoint=[[UILabel alloc]initWithFrame:CGRectMake(0,0,20,20)];
            unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,20,20)];
        }
		[self addSubview:startPoint];
		[self addSubview:middlePoint];
		[self addSubview:endPoint];
		[self addSubview:unitLabel];
		startPoint.text=@"0";
		middlePoint.text=@"1";
		endPoint.text=@"2";
		unitLabel.text=@"miles";
		if(bMetric)
			unitLabel.text=@"kms";
        lineWidth=3;
        height=30;
        unitPos=35;
        vPos=0;
        mkvPos=0;
        unitvPos=10;
        vOffset=5;
        h=25;
        lbExt=90;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [startPoint setFont:[UIFont systemFontOfSize:12]];
            [middlePoint setFont:[UIFont systemFontOfSize:12]];
            [endPoint setFont:[UIFont systemFontOfSize:12]];
            [unitLabel setFont:[UIFont systemFontOfSize:12]];
            lineWidth=2;
            height=21;
            unitPos=20;
            vPos=4;
            mkvPos=-3;
            unitvPos=3;
            vOffset=3;
            h=17;
            lbExt=50;
        }
		startPoint.backgroundColor=[UIColor clearColor];
		middlePoint.backgroundColor=[UIColor clearColor];
		endPoint.backgroundColor=[UIColor clearColor];
		unitLabel.backgroundColor=[UIColor clearColor];
		startPoint.textColor=[UIColor yellowColor];
		middlePoint.textColor=[UIColor yellowColor];
		endPoint.textColor=[UIColor yellowColor];
		unitLabel.textColor=[UIColor yellowColor];
		
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	if (bMetric) {
		unitLabel.text=@"kms";
	}else
		unitLabel.text=@"miles";   //TODO: check if this way will cause memory leak?
	if (mid<0.125) {
		if (bMetric){
			len=len/0.125*0.1;  //(/1.25)
			mid=mid/1.25;
			end=end/1.25;
			
			[middlePoint setFrame:CGRectMake(len/2, 0, 50, 20)];
			[endPoint setFrame:CGRectMake(len, 0, 50, 20)];
			[unitLabel setFrame:CGRectMake(len+35, 10, 52, 20)];
			
			NSString * a=[[NSString alloc]initWithFormat:@"%.0f",mid*1000];
			[middlePoint setText:a];
			a=[[NSString alloc]initWithFormat:@"%.0f",end*1000];
			[endPoint setText:a];
			//unitLabel.text;
			
			unitLabel.text=@"meters";
		}else{
			len=len/1.1;  //(/1.25)
			mid=mid/1.1;
			end=end/1.1;
			
			[middlePoint setFrame:CGRectMake(len/2, 0, 50, 20)];
			[endPoint setFrame:CGRectMake(len, 0, 50, 20)];
			[unitLabel setFrame:CGRectMake(len+35, 10, 52, 20)];
			
			NSString * a=[[NSString alloc]initWithFormat:@"%.0f",mid*1760];
			[middlePoint setText:a];
			a=[[NSString alloc]initWithFormat:@"%.0f",end*1760];
			[endPoint setText:a];
			//unitLabel.text;
			
			unitLabel.text=@"yards";
		}
        
	}else if (mid<0.25) {
		NSString * a=[[NSString alloc]initWithFormat:@"%.3f",mid];
		[middlePoint setText:a];
		a=[[NSString alloc]initWithFormat:@"%.2f",end];
		[endPoint setText:a];
	}else if (mid<1) {
		NSString * a=[[NSString alloc]initWithFormat:@"%.2f",mid];
		[middlePoint setText:a];
		a=[[NSString alloc]initWithFormat:@"%.1f",end];
		[endPoint setText:a];
	}else {
		NSString * a=[[NSString alloc]initWithFormat:@"%.0f",mid];
		[middlePoint setText:a];
		a=[[NSString alloc]initWithFormat:@"%.0f",end];
		[endPoint setText:a];
	}
	
	//[unitLabel setText:[[NSString alloc]initWithFormat:@"%d",len]];
	if(mid==0){
		self.hidden=YES;
		return;
	}else {
		self.hidden=NO;
	}
	
	[self setFrame:CGRectMake(30, vPos,len+lbExt,height)];
	
	//int h=25;		//ruler y position
    // Drawing code
	[self drawLineFrom:CGPointMake(10,h) to:CGPointMake(len+10, h) withColor:[UIColor yellowColor] andWidth:lineWidth];   //ruler
	[self drawLineFrom:CGPointMake(10+1,h) to:CGPointMake(10+1, h-5) withColor:[UIColor yellowColor] andWidth:lineWidth];    //ruler starting end
	[self drawLineFrom:CGPointMake(len+10-1,h-vOffset) to:CGPointMake(len+10-1, h) withColor:[UIColor yellowColor] andWidth:lineWidth];    //ruler right end
	[self drawLineFrom:CGPointMake(10+len/2,h-vOffset) to:CGPointMake(10+len/2, h) withColor:[UIColor yellowColor] andWidth:lineWidth]; //ruler middle point
	[self drawLineFrom:CGPointMake(10+len/4,h-vOffset) to:CGPointMake(10+len/4, h) withColor:[UIColor yellowColor] andWidth:1]; //ruler 1/4 point
	[self drawLineFrom:CGPointMake(10+len*.75,h-vOffset) to:CGPointMake(10+len*.75, h) withColor:[UIColor yellowColor] andWidth:1]; //ruler 3/4 point
	
	[middlePoint setFrame:CGRectMake(len/2,        mkvPos, 50, 20)];
    [endPoint    setFrame:CGRectMake(len,          mkvPos, 50, 20)];
	[unitLabel   setFrame:CGRectMake(len+unitPos,  unitvPos, 50, 20)];
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
#define earthDiameterKM 12756.32    //km
#define earthDiameterMI 7926.41    // miles
#define PI 3.1415926
#define e 2.718281828
-(void)updateRuler:(UIScrollView *)scrollView{
	int earthDiameter=earthDiameterMI;
	if(bMetric)
		earthDiameter=earthDiameterKM;
	CGPoint offset=[scrollView contentOffset];
	CGRect  visibleBounds = [self bounds];
	CGFloat CenterY=offset.y+visibleBounds.size.height/2;
	//long pixNum=256*pow(2,resolution);
	long pixNum=[scrollView contentSize].width;
	CGFloat degree=(CGFloat)CenterY/pixNum*180;	//(0 -> 180)
	CGFloat Y=90-degree;						//(-90->+90)
	CGFloat Yrad=(CGFloat)Y/180*PI;				// to Radian
	CGFloat radLat=asin((pow(e,2*2*Yrad)-1)/(pow(e,2*2*Yrad)+1));    //radian on map
	//CGFloat lat=(CGFloat)180*radLat/PI;				//degree on MAP
	CGFloat widthInRadians=(CGFloat)2/earthDiameter/cos(radLat);
	CGFloat widthInDegreePix=(CGFloat)180*widthInRadians*pixNum/PI/360;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        float a[21]={4000,2000,1000,800,400,200,100,80,40,20,10,8,4,2,1,0.5,0.25,0.125,0.0625,0.03125,.015625};
        for (int i=0; i<20; i++) {
            if((widthInDegreePix<200.0/a[i])&&(widthInDegreePix>100.0/a[i])){
                len=widthInDegreePix*a[i];
                mid=0.5*a[i];
                end=1*a[i];
                break;
            }
            mid=0;
        }

        [self setNeedsLayout];
        [self setNeedsDisplay];
        return;        
    }
	if((widthInDegreePix<600.0/4000)&&(widthInDegreePix>300.0/4000)){
		len=widthInDegreePix*4000;
		 mid=0.5*4000;
		 end=1*4000;
	}else if((widthInDegreePix<600.0/2000)&&(widthInDegreePix>300.0/2000)){
		 len=widthInDegreePix*2000;
		 mid=0.5*2000;
		 end=1*2000;
	}else if((widthInDegreePix<600.0/1000)&&(widthInDegreePix>300.0/1000)){
		 len=widthInDegreePix*1000;
		 mid=0.5*1000;
		 end=1*1000;
	}else if((widthInDegreePix<600.0/800)&&(widthInDegreePix>300.0/800)){
		 len=widthInDegreePix*800;
		 mid=0.5*800;
		 end=1*800;
	}else if((widthInDegreePix<600.0/400)&&(widthInDegreePix>300.0/400)){
		 len=widthInDegreePix*400;
		 mid=0.5*400;
		 end=1*400;
	}else if((widthInDegreePix<600.0/200)&&(widthInDegreePix>300.0/200)){
		 len=widthInDegreePix*200;
		 mid=0.5*200;
		 end=1*200;
	}else if((widthInDegreePix<600/100)&&(widthInDegreePix>300/100)){
		 len=widthInDegreePix*100;
		 mid=0.5*100;
		 end=1*100;
	}else if((widthInDegreePix<600/80)&&(widthInDegreePix>300/80)){
		 len=widthInDegreePix*80;
		 mid=0.5*80;
		 end=1*80;
	}else if((widthInDegreePix<600/40)&&(widthInDegreePix>300/40)){
		 len=widthInDegreePix*40;
		 mid=0.5*40;
		 end=1*40;
	}else if((widthInDegreePix<600/20)&&(widthInDegreePix>300/20)){
		 len=widthInDegreePix*20;
		 mid=0.5*20;
		 end=1*20;
	}else if((widthInDegreePix<600/10)&&(widthInDegreePix>300/10)){
		 len=widthInDegreePix*10;
		 mid=0.5*10;
		 end=1*10;
	}else if((widthInDegreePix<600/8)&&(widthInDegreePix>300/8)){
		 len=widthInDegreePix*8;
		 mid=0.5*8;
		 end=1*8;
	}else if((widthInDegreePix<600/4)&&(widthInDegreePix>300/4)){
		 len=widthInDegreePix*4;
		 mid=0.5*4;
		 end=1*4;
	}else if((widthInDegreePix<600/2)&&(widthInDegreePix>300/2)){
		 len=widthInDegreePix*2;
		 mid=0.5*2;
		 end=1*2;
	}else if((widthInDegreePix<600)&&(widthInDegreePix>300)){    //one mile marker
		 len=widthInDegreePix;
		 mid=0.5;
		 end=1;
	}else if ((widthInDegreePix<1200)&&(widthInDegreePix>600)) {
		 len=widthInDegreePix/2;
		 mid=0.5/2;
		 end=1.0/2;
	}else if ((widthInDegreePix<600*4)&&(widthInDegreePix>600*2)) {
		 len=widthInDegreePix/4;
		 mid=0.5/4;
		 end=1.0/4;
	}else if ((widthInDegreePix<600*8)&&(widthInDegreePix>600*4)) {
		 len=widthInDegreePix/8;
		 mid=0.5/8;
		 end=1.0/8;
	}else if ((widthInDegreePix<600*16)&&(widthInDegreePix>600*8)) {
		 len=widthInDegreePix/16;
		 mid=0.5/16;
		 end=1.0/16;
	}else if ((widthInDegreePix<600*32)&&(widthInDegreePix>600*16)) {
		 len=widthInDegreePix/32;
		 mid=0.5/32;
		 end=1.0/32;
	}else {
		 mid=0;		//means do not show scale ruler
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}
@end
