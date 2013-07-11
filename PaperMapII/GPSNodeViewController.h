//
//  GPSNodeViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSNode.h"
#import "GPSTrack.h"

@interface GPSNodeViewController : UIViewController
@property (nonatomic,strong) GPSNode * node;
@property (nonatomic,strong) GPSTrack * gpsTrack;

@property (nonatomic,strong) IBOutlet UILabel * lblLat;
@property (nonatomic,strong) IBOutlet UILabel * lblLon;
@property (nonatomic,strong) IBOutlet UILabel * lblDir;
@property (nonatomic,strong) IBOutlet UILabel * lblAlt;
@property (nonatomic,strong) IBOutlet UILabel * lblSpd;
@property (nonatomic,strong) IBOutlet UILabel * lblDis1;
@property (nonatomic,strong) IBOutlet UILabel * lblDis2;
@property (nonatomic,strong) IBOutlet UILabel * lblDisInMile;
@property (nonatomic,strong) IBOutlet UILabel * lblTim;
@property (nonatomic,strong) IBOutlet UIButton * fButton;   //forward button
@property (nonatomic,strong) IBOutlet UIButton * bButton;   //backward button
@property NSInteger idx;
-(IBAction)fButonClicked:(id)sender;
-(IBAction)bButonClicked:(id)sender;
@end
