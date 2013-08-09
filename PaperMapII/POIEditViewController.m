//
//  POIEditViewController.m
//  TwoDGPS
//
//  Created by zhuyali on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "POIEditViewController.h"
#import "DrawableMapScrollView.h"

@implementation POIEditViewController

//@synthesize rootView;
@synthesize poiTitle;
@synthesize poi;
@synthesize latitude,longitude,description;
@synthesize imgChecked, imgUnchecked;

@synthesize chkBlueflag;
@synthesize chkPurpleflag;
@synthesize chkGreenflag;
@synthesize chkYellowflag;
@synthesize chkOrangeFlag;
@synthesize chkRedflag;

@synthesize chkBlueflagv;
@synthesize chkPurpleflagv;
@synthesize chkGreenflagv;
@synthesize chkYellowflagv;
@synthesize chkOrangeFlagv;
@synthesize chkRedflagv;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
#define PI 3.1415926
#define e 2.718281828
-(CGFloat)GetGPSLatCoor:(POI *)Poi{
	long pixNum=256*pow(2,Poi.res);
	CGFloat degree=(CGFloat)Poi.y/pixNum*180;	//(0 -> 180)
	CGFloat Y=90-degree;						//(-90->+90)
	CGFloat Yrad=(CGFloat)Y/180*PI;				// to Radian
	CGFloat radLat=asin((pow(e,2*2*Yrad)-1)/(pow(e,2*2*Yrad)+1));    //radian on map
	CGFloat lat=(CGFloat)180*radLat/PI;				//degree on MAP
	return lat;
}
-(CGFloat)GetGPSLonCoor:(POI *)Poi{	
	//return 360*poi.x/(256*pow(2,poi.res))-180;
	int tileNum=pow(2,Poi.res);
	long pixNum=256*tileNum;
	CGFloat degree=(CGFloat)Poi.x/pixNum*360;
	CGFloat deg=degree-180;
	return deg;
}

-(double)GetScreenY:(double)lat{
	double y1=lat*PI/180;
	double y=0.5*log((1+sin(y1))/(1-sin(y1)));
	return y*180/PI/2;
}
-(int)getXforRes:(int)res with:(double)lon{	
	return (180+lon)*256*pow(2,res)/360;
}
-(int)getYforRes:(int)res with:(double)lat{
	
	return pow(2,res)*1.422222222*(90-[self GetScreenY:lat]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.contentSizeForViewInPopover=CGSizeMake(320,450);
}

- (void)viewWillAppear:(BOOL)animated{	
    poiTitle.text=poi.title;	
	NSString * lat=[[NSString alloc] initWithFormat:@"%.6f",[self GetGPSLatCoor:poi]];  //version 4.0 %.6f not %.4f
	latitude.text=lat;
	NSString * lon=[[NSString alloc] initWithFormat:@"%.6f",[self GetGPSLonCoor:poi]];  //version 4.0 %.6f not %.4f
	
	longitude.text=lon;
	description.text=poi.description;
	
	flag=poi.nType;
	//display flag settings as specified
	if (flag==BLUEFLAG)  [chkBlueflagv   set_Checked:YES]; else [chkBlueflagv 	set_Checked:NO];
	if (flag==PURPLEFLAG)[chkPurpleflagv set_Checked:YES]; else [chkPurpleflagv set_Checked:NO];
	if (flag==GREENFLAG) [chkGreenflagv  set_Checked:YES]; else [chkGreenflagv 	set_Checked:NO];
	if (flag==YELLOWFLAG)[chkYellowflagv set_Checked:YES]; else [chkYellowflagv set_Checked:NO];
	if (flag==ORANGEFLAG)[chkOrangeFlagv set_Checked:YES]; else [chkOrangeFlagv set_Checked:NO];
	if (flag==REDFLAG)   [chkRedflagv    set_Checked:YES]; else [chkRedflagv 	set_Checked:NO];
    //self.contentSizeForViewInPopover=CGSizeMake(320,450);
}
bool saved;
bool canceled;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"   style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
	//self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	imgChecked=[UIImage imageNamed:@"checked.png"];
	imgUnchecked=[UIImage imageNamed:@"unchecked.png"];
	
	[chkBlueflagv setImgChecked:imgChecked];
	[chkBlueflagv setImgUnchecked:imgUnchecked];

	[chkPurpleflagv setImgChecked:imgChecked];
	[chkPurpleflagv setImgUnchecked:imgUnchecked];

	[chkGreenflagv setImgChecked:imgChecked];
	[chkGreenflagv setImgUnchecked:imgUnchecked];

	[chkYellowflagv setImgChecked:imgChecked];
	[chkYellowflagv setImgUnchecked:imgUnchecked];

	[chkOrangeFlagv setImgChecked:imgChecked];
	[chkOrangeFlagv setImgUnchecked:imgUnchecked];

	[chkRedflagv setImgChecked:imgChecked];
	[chkRedflagv setImgUnchecked:imgUnchecked];
		
	saved=false;
	canceled=false;
	//[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(repositionPopover) userInfo:nil repeats: NO];  //use this method to change it to normal size

}

-(void)viewDidDisappear:(BOOL)animated{
	if (saved || canceled) {
		saved=false;
		canceled=false;
		return;
	}
	//[rootView.menuViewController.navigationController popViewControllerAnimated:NO];
	//[rootView.menuViewController.navigationController popViewControllerAnimated:NO];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)repositionPopover{
#ifdef TARGET_IPAD	
	[rootView.popoverController presentPopoverFromBarButtonItem:rootView.menuBn permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
#endif
}
#pragma mark Added methods
-(void)cancel{
	canceled=true;
	//[rootView.poiEditPopoverController dismissPopoverAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
	//[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(repositionPopover) userInfo:nil repeats: NO];  //use this method to change it to normal size
}
-(void)save{
	saved=true;
	poi.title=poiTitle.text;
	if ([description.text length]>0) {
		poi.description=description.text;
	}
	poi.nType=flag;
	poi.x=[self getXforRes:poi.res with:[longitude.text doubleValue]];
	poi.y=[self getYforRes:poi.res with:[latitude.text doubleValue]];
	
	//[rootView.poiEditPopoverController dismissPopoverAnimated:YES];
	//[rootView.listViewController.tableView reloadData];
	//[rootView.parent.imageScrollView.viewFlattener.drawLineView setNeedsDisplay];
	[self.navigationController popViewControllerAnimated:YES];
	//[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(repositionPopover) userInfo:nil repeats: NO];  //use this method to change it to normal size
    [[DrawableMapScrollView sharedMap] refresh];
}
-(IBAction)flagChkBnTapped:(id)sender{
	[chkBlueflagv 	set_Checked:NO];
	[chkPurpleflagv set_Checked:NO];
	[chkGreenflagv 	set_Checked:NO];
	[chkYellowflagv set_Checked:NO];
	[chkOrangeFlagv set_Checked:NO];
	[chkRedflagv 	set_Checked:NO];
	
	UIButton * chkBn=(UIChkButton *)sender;
	if((chkBn==chkBlueflagv)||(chkBn==chkBlueflag)){[chkBlueflagv checkAction]; flag=BLUEFLAG;}
	else if((chkBn==chkGreenflagv) ||(chkBn==chkGreenflag)) {[chkGreenflagv  checkAction];  flag=GREENFLAG;}
	else if((chkBn==chkPurpleflagv)||(chkBn==chkPurpleflag)){[chkPurpleflagv checkAction];  flag=PURPLEFLAG;}
	else if((chkBn==chkYellowflagv)||(chkBn==chkYellowflag)){[chkYellowflagv checkAction];  flag=YELLOWFLAG;}
	else if((chkBn==chkOrangeFlagv)||(chkBn==chkOrangeFlag)){[chkOrangeFlagv checkAction];  flag=ORANGEFLAG;}
	else if((chkBn==chkRedflagv)   ||(chkBn==chkRedflag)){[chkRedflagv checkAction];    flag=REDFLAG;}	
	
}
-(IBAction)movePOIByDragging{
	//[rootView.menuPopoverController dismissPopoverAnimated:YES];
	//[rootView gotoPOI:poi];
	NSLog(@"move POI By Dragging");	
	//rootView.movingPOI=TRUE;
	//[rootView.parent.imageScrollView setScrollEnabled:NO];
	//[rootView showHelpMessages:DRAGPOI];
}

@end
