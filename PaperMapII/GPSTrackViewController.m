//
//  GPSTrackViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrackViewController.h"
#import "GPSTrackNodesViewController.h"
#import "LinePropStorageViewController.h"
#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "TappableMapScrollView.h"
#import "DrawableMapScrollView.h"
#import "ZoomView.h"
#import "GPSTrackPOIBoard.h"
#import "MapScrollView.h"
#import "GPSNode.h"

@interface GPSTrackViewController ()

@end

@implementation GPSTrackViewController
@synthesize gpsTrack;
@synthesize gpsTrackName;
@synthesize lbGpsTrackLength;
@synthesize lbTimeCreated;
@synthesize bnEdit;
@synthesize txtEdit;
@synthesize propBn;
@synthesize lbAvgSpeed;
@synthesize lbTotalTime;
@synthesize visibleSwitchBn;
@synthesize lbNumberOfNodes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    gpsTrackName.text=gpsTrack.title;
    lbGpsTrackLength.text=[[NSString alloc]initWithFormat:@"%3.1f miles (%d meters)",(float)gpsTrack.tripmeter/1609,gpsTrack.tripmeter];
    //lbTimeCreated.text=[gpsTrack.timestamp description];
    lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:gpsTrack.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    txtEdit.hidden=YES;
    [propBn.titleLabel setText:@"GPS Track Property:"];
    propBn.lineProperty=gpsTrack.lineProperty;
    [propBn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];  //TODO: Choose a better image here
    NSDate * t1=((GPSNode *)gpsTrack.nodes[0]).timestamp;
    NSDate * t2=((GPSNode *)[gpsTrack.nodes lastObject]).timestamp;
    NSTimeInterval tm=[t2 timeIntervalSinceDate:t1];
    double miles=gpsTrack.tripmeter/1609;
    double f2=miles*3600;
    float avgSpd=f2/tm;
    lbAvgSpeed.text=[[NSString alloc]initWithFormat:@"%5.1f MPH",avgSpd];
    lbTotalTime.text=[[NSString alloc]initWithFormat:@"%02.0f:%02.0f:%02.0f",floor(tm/3600),fmod(floor(tm/60),60),fmod(tm,60)];
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3d",[gpsTrack.nodes count]];
    if (gpsTrack.visible) {
        [visibleSwitchBn setTitle:@"Visible" forState:UIControlStateNormal];
    }else{
        [visibleSwitchBn setTitle:@"Hidden" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) pickLineProperty:(id)sender{
    gpsTrack.lineProperty=[[LineProperty sharedGPSTrackProperty] copy];
    propBn.lineProperty=gpsTrack.lineProperty;
    [propBn setNeedsDisplay];   //update the property page with new track property
    PM2AppDelegate * appD=[[UIApplication sharedApplication] delegate];
	[appD.viewController.mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];  //update the map with new track property
}
-(IBAction)viewDetailsBnClicked:(id)sender{
    GPSTrackNodesViewController * gpsTrackNodesViewCtrlr=[[GPSTrackNodesViewController alloc]init];
    gpsTrackNodesViewCtrlr.gpsTrack=self.gpsTrack;
    [gpsTrackNodesViewCtrlr setTitle:@"Nodes in Track"];
    [self.navigationController pushViewController:gpsTrackNodesViewCtrlr animated:YES];
}
-(IBAction)editBnClicked:(id)sender{
    if ([[bnEdit.titleLabel text] compare:@"Save"]!=NSOrderedSame) {
        NSLog(@"editBnClicked");
        txtEdit.hidden=NO;
        txtEdit.text=gpsTrack.title;
        [bnEdit setTitle:@"Save"forState:UIControlStateNormal];
    }else{ //save changes
        txtEdit.hidden=YES;
        gpsTrack.title=txtEdit.text;
        gpsTrackName.text=gpsTrack.title;
        [bnEdit setTitle:@"Edit"forState:UIControlStateNormal];
    }
}
- (IBAction) visibleBnClicked:(id)sender{
    if ([[visibleSwitchBn.titleLabel text] compare:@"Visible"]==NSOrderedSame) {
        [visibleSwitchBn setTitle:@"Hidden" forState:UIControlStateNormal];
        gpsTrack.visible=FALSE;
        [gpsTrack saveNodes];
    }else{
        [visibleSwitchBn setTitle:@"Visible" forState:UIControlStateNormal];
        gpsTrack.visible=TRUE;
        if (!gpsTrack.nodes) {      //read in nodes only if nodes not read in yet
            [gpsTrack readNodes];
        }
    }
    PM2AppDelegate * appD=[[UIApplication sharedApplication] delegate];
	[appD.viewController.mapScrollView.zoomView.gpsTrackPOIBoard setNeedsDisplay];  //update the map with new track property
}
@end
