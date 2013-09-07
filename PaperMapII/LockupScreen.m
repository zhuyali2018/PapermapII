//
//  LockupScreen.m
//  TwoDGPS
//
//  Created by zhuyali on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LockupScreen.h"
#import "AllImports.h"

@implementation LockupScreen

@synthesize alpha;
@synthesize alfLabel;
@synthesize rootView;

-(void) buttonPressed{
	[self slideScreenUpandDown];
	//rootView.locked=FALSE;
	//TODO: [rootView hideStatusBar:FALSE];
	//rootView.screenOn=FALSE;
}
-(void)alfSliderValueChanged:(id)sender{
	UISlider* slider = sender;
	alpha =     [slider value];	
	[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:alpha]];
	//[[rootView view] bringSubviewToFront:self];
	NSString * txt=[[NSString alloc]initWithFormat:@"%2.0f%%",alpha*100];
	alfLabel.text=txt;
	if(alpha>0.95){
//		rootView.locked=TRUE;
	}else {
//		rootView.locked=FALSE;
	}

}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setFrame:frame];
		
		UIButton * applyBn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
		[applyBn setBackgroundImage:[UIImage imageNamed:@"xButton.png"] forState:UIControlStateNormal];
		//[applyBn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		//[applyBn  setFrame:CGRectMake(10,10,25,25)];
		[applyBn  setFrame:CGRectMake(10,30,25,25)];
		[applyBn  addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:applyBn];
		
		//alfSlider  =[[UISlider alloc] initWithFrame:CGRectMake(145,10,240,20)];
		//alfSlider  =[[UISlider alloc] initWithFrame:CGRectMake(145,30,240,20)];
        alfSlider  =[[UISlider alloc] initWithFrame:CGRectMake(80,30,240,20)];
		//[alfSlider setBackgroundColor:[UIColor clearColor]];  
		//[alfSlider setMaximumTrackImage:[UIImage imageNamed:@"Map0_0_0.jpg"] forState:UIControlStateNormal];
		//[alfSlider setMinimumTrackImage:[UIImage imageNamed:@"Map1_0_0.jpg"] forState:UIControlStateNormal];
		
		alpha=0.5;
		alfSlider.maximumValue=1.0;
		alfSlider.minimumValue=0.1;
		alfSlider.continuous=YES;
		alfSlider.value=alpha;
		[alfSlider addTarget:self action:@selector(alfSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:alfSlider];		
		
		[self alfSliderValueChanged:alfSlider];
		
		//alfLabel = [[UILabel alloc] initWithFrame:CGRectMake(400,5,100,30)];
		alfLabel = [[UILabel alloc] initWithFrame:CGRectMake(400,30,100,30)];
		[alfLabel setBackgroundColor:[UIColor clearColor]];
		[alfLabel setTextColor:[UIColor blueColor]];
		[self addSubview:alfLabel];		
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)slideScreenUpandDown{
	bool hide=false;
	CGRect frame = [self frame];
    if (frame.origin.y>=[rootView bounds].size.height) {
        //frame.origin.y -= [[self view] bounds].size.height+50;				//slid up to show
		if(frame.origin.y!=0)
			frame.origin.y=0;
		if([rootView bounds].size.height<[rootView bounds].size.width)
			frame.size.height=768;
		//TODO: Check: hideToolbar=YES;
		//TODO: [menuObj.toolbar setHidden:YES];
    } else {
        frame.origin.y += [rootView bounds].size.height+50;				//slide down to hide
		hide=TRUE;
		
		//TODO: hideToolbar=NO;
		//TODO:[menuObj.toolbar setHidden:NO];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
	[self setFrame:frame];							//Set frame position here, animated
    
	[UIView commitAnimations];
	
	self.hidden=hide;
	//GSEventSetBacklightLevel(0.1);
	[rootView bringSubviewToFront:self];
	//make the lock take effect immediately instead of having to touch slider for new alpha before taking effect
    //	if(_lockupScreen.alpha>0.95)
    //		_lockupScreen.locked=TRUE;
    //	else {
    //		_lockupScreen.locked=FALSE;
    //	}
}


@end
