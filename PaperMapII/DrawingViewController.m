//
//  DrawingViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 7/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "DrawingViewController.h"
#import "MapScrollView.h"
#import "ZoomView.h"
#import "TappableMapScrollView.h"
#import "DrawableMapScrollView.h"
#import "GPSTrackPOIBoard.h"
#import "MainQ.h"
#import "Node.h"
#import "Recorder.h"

@interface DrawingViewController ()

@end

@implementation DrawingViewController

@synthesize drawTrack;
@synthesize drawTrackName;
@synthesize lbTimeCreated;
@synthesize bnEdit;
@synthesize txtEdit;
@synthesize propBn;
@synthesize visibleSwitchBn;
@synthesize lbNumberOfNodes;
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
    drawTrackName.text=drawTrack.title;
    lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:drawTrack.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    txtEdit.hidden=YES;
    [propBn.titleLabel setText:@"Drawing Line Property:"];
    propBn.lineProperty=drawTrack.lineProperty;
    [propBn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];  //TODO: Choose a better image here
    
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[drawTrack.nodes count]];
    
    if (drawTrack.visible) {
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
    drawTrack.lineProperty=[[LineProperty sharedDrawingLineProperty] copy];
    propBn.lineProperty=drawTrack.lineProperty;
    [propBn setNeedsDisplay];   //update the property page with new track property
    [[DrawableMapScrollView sharedMap] refresh];//update the map with new track property
}
-(IBAction)viewDetailsBnClicked:(id)sender{
//    GPSTrackNodesViewController * gpsTrackNodesViewCtrlr=[[GPSTrackNodesViewController alloc]init];
//    gpsTrackNodesViewCtrlr.gpsTrack=self.gpsTrack;
//    [gpsTrackNodesViewCtrlr setTitle:@"Nodes in Track"];
//    [self.navigationController pushViewController:gpsTrackNodesViewCtrlr animated:YES];
}
-(IBAction)editBnClicked:(id)sender{
    if ([[bnEdit.titleLabel text] compare:@"Save"]!=NSOrderedSame) {
        NSLog(@"editBnClicked");
        txtEdit.hidden=NO;
        txtEdit.text=drawTrack.title;
        [bnEdit setTitle:@"Save"forState:UIControlStateNormal];
    }else{ //save changes
        txtEdit.hidden=YES;
        drawTrack.title=txtEdit.text;
        drawTrackName.text=drawTrack.title;
        [bnEdit setTitle:@"Edit"forState:UIControlStateNormal];
    }
}
- (IBAction) visibleBnClicked:(id)sender{
    if ([[visibleSwitchBn.titleLabel text] compare:@"Visible"]==NSOrderedSame) {
        [visibleSwitchBn setTitle:@"Hidden" forState:UIControlStateNormal];
        drawTrack.visible=FALSE;
        [drawTrack saveNodes];
    }else{
        [visibleSwitchBn setTitle:@"Visible" forState:UIControlStateNormal];
        drawTrack.visible=TRUE;
        if (!drawTrack.nodes) {      //read in nodes only if nodes not read in yet
            [drawTrack readNodes];
            self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[drawTrack.nodes count]];
        }
    }
    [[DrawableMapScrollView sharedMap] refresh]; //update the map with new track property
}

-(IBAction)fButonClicked:(id)sender{
    idx++;
    if(idx>=[drawTrack.nodes count]){
        idx--;
        return;
    }
    Node * node1=[drawTrack.nodes objectAtIndex:idx];
    [self updateWith:(Node *)node1];
}
-(IBAction)bButonClicked:(id)sender{
    idx--;
    if(idx<0){
        idx++;
        return;
    }
    Node * node1=[drawTrack.nodes objectAtIndex:idx];
    [self updateWith:(Node *)node1];
}
-(void)updateWith:(Node *)node1{
    lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%ld / %lu",(unsigned long)idx+1,(unsigned long)[drawTrack.nodes count]];
    [[DrawableMapScrollView sharedMap] centerMapTo:node1];
    //[self centerMapToDrawNode:node1];
}
@end
