//
//  GPSNodeViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSNodeViewController.h"
#import "MapScrollView.h"
#import "DrawableMapScrollView.h"
#import "Recorder.h"

@interface GPSNodeViewController ()

@end

@implementation GPSNodeViewController
@synthesize node;
@synthesize gpsTrack;
@synthesize fButton,bButton;
@synthesize idx;

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
    self.lblTim.text=[NSDateFormatter localizedStringFromDate:node.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    self.lblLat.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node.latitude];
    self.lblLon.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node.longitude];
    self.lblAlt.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.altitude];
    self.lblDir.text=[[NSString alloc]initWithFormat:@"%8.1f degrees",node.direction];
    self.lblSpd.text=[[NSString alloc]initWithFormat:@"%8.1f MPH",node.speed*3600/1609.34f];
    self.lblDis1.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.distanceFromLastNode];
    self.lblDis2.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.distanceFromStart];
    self.lblDisInMile.text=[[NSString alloc]initWithFormat:@"%8.1f miles",node.distanceFromStart/1069.34f];
    idx=[gpsTrack.nodes indexOfObject:node];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)fButonClicked:(id)sender{
    idx++;
    if(idx>=[gpsTrack.nodes count]) return;
    GPSNode * node1=[gpsTrack.nodes objectAtIndex:idx];
    [self updateWith:(GPSNode *)node1];
}
-(IBAction)bButonClicked:(id)sender{
    idx--;
    if(idx<0) return;
    GPSNode * node1=[gpsTrack.nodes objectAtIndex:idx];
    [self updateWith:(GPSNode *)node1];
}
-(void)updateWith:(GPSNode *)node1{
    self.lblTim.text=[NSDateFormatter localizedStringFromDate:node1.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    self.lblLat.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node1.latitude];
    self.lblLon.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node1.longitude];
    self.lblAlt.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node1.altitude];
    self.lblDir.text=[[NSString alloc]initWithFormat:@"%8.1f degrees",node.direction];
    self.lblSpd.text=[[NSString alloc]initWithFormat:@"%8.1f MPH",node1.speed*3600/1609];
    self.lblDis1.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node1.distanceFromLastNode];
    self.lblDis2.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node1.distanceFromStart];
    //[self centerMapTo:node1];
    [[DrawableMapScrollView sharedMap] centerMapTo:node1];
}
//-(void)centerMapTo:(GPSNode *)node1{
//    MapScrollView * map=((MapScrollView *)[DrawableMapScrollView sharedMap]);
//    int res=map.maplevel;
//    //x,y used to center the map below
//	int x=pow(2,res)*0.711111111*(node1.longitude+180);                      //256/360=0.7111111111
//	int y=pow(2,res)*1.422222222*(90-[[Recorder sharedRecorder] GetScreenY:node1.latitude]);		 //256/180=1.4222222222
//	
//    //center the current position
//    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
//}
@end
