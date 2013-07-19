//
//  GPSTrackViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSTrack.h"
#import "PropertyButton.h"
@interface GPSTrackViewController : UIViewController
@property (nonatomic,strong) GPSTrack * gpsTrack;
@property (nonatomic,strong) IBOutlet UILabel * gpsTrackName;
@property (nonatomic,strong) IBOutlet UILabel * lbGpsTrackLength;
@property (nonatomic,strong) IBOutlet UILabel * lbTimeCreated;
@property (nonatomic,strong) IBOutlet UIButton * bnViewDetails;
@property (nonatomic,strong) IBOutlet UIButton * bnEdit;
@property (nonatomic,strong) IBOutlet UIButton * visibleSwitchBn;
@property (nonatomic,strong) IBOutlet UITextField * txtEdit;
@property (nonatomic,strong) IBOutlet UILabel * lbTotalTime;
@property (nonatomic,strong) IBOutlet UILabel * lbAvgSpeed;
@property (nonatomic,strong) IBOutlet UILabel * lbNumberOfNodes;
@property (nonatomic,strong) IBOutlet PropertyButton * propBn;

-(IBAction)viewDetailsBnClicked:(id)sender;
-(IBAction)editBnClicked:(id)sender;
- (IBAction) pickLineProperty:(id)sender;
- (IBAction) visibleBnClicked:(id)sender;
@end
