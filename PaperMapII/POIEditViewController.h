//
//  POIEditViewController.h
//  TwoDGPS
//
//  Created by zhuyali on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "POI.h"
#import "UIChkButton.h"

@interface POIEditViewController : UIViewController  {
	//MenuController *rootView;
	IBOutlet UITextField * poiTitle;
	IBOutlet UITextField * latitude;
	IBOutlet UITextField * longitude;
	IBOutlet UITextView * description;
	
	POI * poi;
	UIImage * imgChecked;
	UIImage * imgUnchecked;
	
	IBOutlet UIButton * chkBlueflag;
	IBOutlet UIButton * chkPurpleflag;
	IBOutlet UIButton * chkGreenflag;
	IBOutlet UIButton * chkYellowflag;
	IBOutlet UIButton * chkOrangeFlag;
	IBOutlet UIButton * chkRedflag;
	
	IBOutlet UIChkButton * chkBlueflagv;
	IBOutlet UIChkButton * chkPurpleflagv;
	IBOutlet UIChkButton * chkGreenflagv;
	IBOutlet UIChkButton * chkYellowflagv;
	IBOutlet UIChkButton * chkOrangeFlagv;
	IBOutlet UIChkButton * chkRedflagv;
	
	FLAGTYPE flag;	
}
//@property (nonatomic) MenuController * rootView;
@property (nonatomic) IBOutlet UITextField * poiTitle;
@property (nonatomic) IBOutlet UITextField * latitude;
@property (nonatomic) IBOutlet UITextField * longitude;
@property (nonatomic) IBOutlet UITextView * description;
@property (nonatomic) UIImage * imgChecked;
@property (nonatomic) UIImage * imgUnchecked;

@property (nonatomic) IBOutlet UIButton * chkBlueflag;
@property (nonatomic) IBOutlet UIButton * chkPurpleflag;
@property (nonatomic) IBOutlet UIButton * chkGreenflag;
@property (nonatomic) IBOutlet UIButton * chkYellowflag;
@property (nonatomic) IBOutlet UIButton * chkOrangeFlag;
@property (nonatomic) IBOutlet UIButton * chkRedflag;

@property (nonatomic) IBOutlet UIChkButton * chkBlueflagv;
@property (nonatomic) IBOutlet UIChkButton * chkPurpleflagv;
@property (nonatomic) IBOutlet UIChkButton * chkGreenflagv;
@property (nonatomic) IBOutlet UIChkButton * chkYellowflagv;
@property (nonatomic) IBOutlet UIChkButton * chkOrangeFlagv;
@property (nonatomic) IBOutlet UIChkButton * chkRedflagv;

@property (nonatomic) POI * poi;
-(void)cancel;
-(void)save;
//- (void)set_Checked:(bool)bChecked;
-(IBAction)flagChkBnTapped:(id)sender;
-(IBAction)movePOIByDragging;
-(void)repositionPopover;
@end
