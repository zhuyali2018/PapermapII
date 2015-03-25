
//  GPSTrackViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
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
#import "Recorder.h"

@interface GPSTrackViewController ()

@end

@implementation GPSTrackViewController
@synthesize gpsTrackPOI;
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
@synthesize bnSend;

@synthesize lbNameAvgSpeed,lbNameNodeNumber,lbNameTotalTile,lbNameTrackLength;
@synthesize listType;

extern bool bWANavailable;
extern bool bWiFiAvailable;
extern BOOL bDrawBigLabel;

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
    txtEdit.hidden=YES;
    txtEdit.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtEdit.delegate=self;
    
    if((listType==SENDGPSTRACK)||(listType==SENDDRAWING)||(listType==SENDPOI))
        bnSend.hidden=false;
    else
        bnSend.hidden=true;
    
    if (gpsTrackPOI.folder) {
        lbGpsTrackLength.hidden=YES;
        propBn.hidden=YES;
        visibleSwitchBn.hidden=YES;
        lbAvgSpeed.hidden=YES;
        lbTotalTime.hidden=YES;
        lbNumberOfNodes.hidden=YES;
        self.bnViewDetails.hidden=YES;
        lbNameTrackLength.hidden=YES;
        lbNameTotalTile.hidden=YES;
        lbNameAvgSpeed.hidden=YES;
        lbNameNodeNumber.hidden=YES;
        gpsTrackName.text=gpsTrackPOI.mainText;
        
        lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:gpsTrackPOI.cdate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];

        return;
    }
    gpsTrackName.text=gpsTrackPOI.mainText;
    //if (self.Mtype != MPOI)
        lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:gpsTrackPOI.cdate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    
    if (listType==DRAWLIST) {
        lbNameTrackLength.hidden=YES;
        lbNameTotalTile.hidden=YES;
        lbNameAvgSpeed.hidden=YES;
        [propBn.titleLabel setText:@"Drawing Property:"];
        propBn.lineProperty=((Track *)gpsTrackPOI).lineProperty;
    } else if(listType==SENDGPSTRACK){
        bnSend.hidden=false;
        lbGpsTrackLength.text=[[NSString alloc]initWithFormat:@"%3.1f miles (%d meters)",(float)((GPSTrack *)gpsTrackPOI).tripmeter/1609,((GPSTrack *)gpsTrackPOI).tripmeter];
        [propBn.titleLabel setText:@"GPS Track Property:"];
        propBn.lineProperty=((Track *)gpsTrackPOI).lineProperty;
    } else if(listType==SENDDRAWING){
        bnSend.hidden=false;
        //lbGpsTrackLength.text=[[NSString alloc]initWithFormat:@"%3.1f miles (%d meters)",(float)gpsTrack.tripmeter/1609,gpsTrack.tripmeter];
        [propBn.titleLabel setText:@"Drawing Property:"];
        propBn.lineProperty=((Track *)gpsTrackPOI).lineProperty;
    }
    [propBn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];  //TODO: Choose a better image here
    
    if ((listType==DRAWLIST) ||(listType==SENDDRAWING)) {
        [self displayTrackInfo];
    }else if ((listType==GPSLIST) || (listType==SENDGPSTRACK)){
        [self displayGPSTrackInfo];
    }
    
    if (gpsTrackPOI.selected) {
        [visibleSwitchBn setTitle:@"Hide" forState:UIControlStateNormal];
    }else{
        [visibleSwitchBn setTitle:@"Show" forState:UIControlStateNormal];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    bnSend.frame=CGRectMake(100,150, 100, 40);
    [bnSend setBackgroundColor:[UIColor redColor]];
    NSLog(@"viewDidAppear");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) pickLineProperty:(id)sender{
    if (self.Mtype == MGPSTRACK) {
        ((Track *)gpsTrackPOI).lineProperty=[[LineProperty sharedGPSTrackProperty] copy];
    }else if (self.Mtype == MTRACK){
        ((Track *)gpsTrackPOI).lineProperty=[[LineProperty sharedDrawingLineProperty] copy];
    }
    propBn.lineProperty=((Track *)gpsTrackPOI).lineProperty;
    [propBn setNeedsDisplay];   //update the property page with new track property
    [[DrawableMapScrollView sharedMap] refresh];
}
-(IBAction)viewDetailsBnClicked:(id)sender{
    if (self.Mtype != MPOI) {
        GPSTrackNodesViewController * gpsTrackNodesListViewCtrlr=[[GPSTrackNodesViewController alloc]init];
        gpsTrackNodesListViewCtrlr.gpsTrack=(GPSTrack *)self.gpsTrackPOI;
        [gpsTrackNodesListViewCtrlr setTitle:@"Nodes in Track"];
        [self.navigationController pushViewController:gpsTrackNodesListViewCtrlr animated:YES];
    }
}
-(IBAction)editBnClicked:(id)sender{
    if ([[bnEdit.titleLabel text] compare:@"Save"]!=NSOrderedSame) {
        NSLog(@"editBnClicked");
        txtEdit.hidden=NO;
        txtEdit.text=gpsTrackPOI.mainText;
        [bnEdit setTitle:@"Save"forState:UIControlStateNormal];
    }else{ //save changes
        txtEdit.hidden=YES;
        gpsTrackPOI.mainText=txtEdit.text;//gpsTrack.title=txtEdit.text;
        gpsTrackName.text=gpsTrackPOI.mainText;//gpsTrack.title;
        [bnEdit setTitle:@"Edit"forState:UIControlStateNormal];
        gpsTrackPOI.mainLabel.text=gpsTrackPOI.mainText;//gpsTrack.title;
        //[gpsTrack.mainLabel setNeedsDisplay];
    }
}
- (IBAction) visibleBnClicked:(id)sender{
    if (self.Mtype == MPOI) {
        return;
    }
    if ([[visibleSwitchBn.titleLabel text] compare:@"Hide"]==NSOrderedSame) {
        [visibleSwitchBn setTitle:@"Show" forState:UIControlStateNormal];
        ((Track *)gpsTrackPOI).visible=FALSE;
        [((Track *)gpsTrackPOI) saveNodes];
    }else{
        [visibleSwitchBn setTitle:@"Hide" forState:UIControlStateNormal];
        ((Track *)gpsTrackPOI).visible=TRUE;
        if (!((Track *)gpsTrackPOI).nodes) {      //read in nodes only if nodes not read in yet
            [((Track *)gpsTrackPOI) readNodes];
        }
        if (listType!=DRAWLIST) {
            [self displayGPSTrackInfo];
        }else{
            [self displayTrackInfo];
        }
    }
    [[DrawableMapScrollView sharedMap] refresh];
}
-(NSString *) getGPSTrackFileNameWithPath:(NSString *)fn{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString * documentsDirectory=[paths objectAtIndex:0];
    NSString * filePath=[documentsDirectory stringByAppendingPathComponent:fn];
    return filePath;
}
-(NSData *)getNSDataFromDrawingLineFile:(NSString *)fn{
//    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString * documentsDirectory=[paths objectAtIndex:0];
//    NSString * filePath=[documentsDirectory stringByAppendingPathComponent:gpsTrack.filename];
    NSString * filePath = [self getGPSTrackFileNameWithPath:fn];
    NSLog(@"getNSDataFromDrawingLineFile:%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        return data;
    }		
    return nil;
}
-(void)saveCurrentGPSTrack{
    if (self.Mtype != MPOI) {
        [((Track *)gpsTrackPOI) readNodes];    //make sure the nodes are read in before saving to a temp file for emailing
    }
    NSString * trackFilename=[self getGPSTrackFileNameWithPath:((Track *)gpsTrackPOI).mainText];
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSMutableArray * gpsTrackArray=[NSMutableArray arrayWithCapacity:1];
    [gpsTrackArray addObject:((Track *)gpsTrackPOI)];
    if(self.Mtype == MGPSTRACK)
        [archiver encodeObject:gpsTrackArray forKey:@"gpsTrackOnly"];   //<== the key @"gpsTrackOnly" will be used in the email receiver for unarchiving
    else if(self.Mtype == MTRACK)
        [archiver encodeObject:gpsTrackArray forKey:@"DrawTrackOnly"];  //<== the key @"DrawTrackOnly" will be used in the email receiver for unarchiving
    else
        [archiver encodeObject:gpsTrackArray forKey:@"POIOnly"];        //<== the key @"POIOnly" will be used in the email receiver for unarchiving
    [archiver finishEncoding];
    
    [data writeToFile:trackFilename atomically:YES];
}

-(void)createTempFileForFolder:(MenuNode *)node{
    NSLog(@"Creating a file for folder %@",node.mainText);
    NSString * trackFilename=[self getGPSTrackFileNameWithPath:node.mainText];
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    NSMutableArray * gpsTracksInFolder=[NSMutableArray arrayWithCapacity:2];
    int row=node.rootArrayIndex;
    
    NSMutableArray * gpsTrackArray;
    if(self.Mtype == MGPSTRACK)
        gpsTrackArray=[Recorder sharedRecorder].gpsTrackArray;
    else if(self.Mtype == MTRACK)
        gpsTrackArray=[Recorder sharedRecorder].trackArray;
    else
        gpsTrackArray=[Recorder sharedRecorder].poiArray;
    
    for (int i=row; i<[gpsTrackArray count];i++) {
        MenuNode * nd=[gpsTrackArray objectAtIndex:i];
        if ((i==row)||nd.infolder) {    //if the first folder entry or the gpstrack entries that follow
            if ((self.Mtype != MPOI)&&(nd.infolder)) {
                ((Track *)nd).version = 0;
            }
            [gpsTracksInFolder addObject:nd];
        }else{
            break;          //if end of folder, break
        }
        //nd.rootArrayIndex=i;        //keep track of its position in original array
    }
    
    if(self.Mtype == MGPSTRACK)
        [archiver encodeObject:gpsTracksInFolder forKey:@"gpsTrackOnly"];  //<== the key @"gpsTrackOnly" will be used in the email receiver for unarchiving
    else if(self.Mtype == MTRACK)
        [archiver encodeObject:gpsTracksInFolder forKey:@"DrawTrackOnly"];  //<== the key @"DrawTrackOnly" will be used in the email receiver for unarchiving
    else
        [archiver encodeObject:gpsTracksInFolder forKey:@"POIOnly"];  //<== the key @"DrawTrackOnly" will be used in the email receiver for unarchiving
    [archiver finishEncoding];
    
    [data writeToFile:trackFilename atomically:YES];
}

-(void) sendEmail2{
    if((!bWANavailable)&&(!bWiFiAvailable)){
        UIAlertView * alert1=[[UIAlertView alloc]initWithTitle:@"Email service \nis not available now" message:@"Sending Email requires \ninternet access \nwhich is not available now\n\n Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert1 show];
        return;
    }
    if (gpsTrackPOI.folder) {
        [self createTempFileForFolder:gpsTrackPOI];
    }else{
        if(self.Mtype != MPOI)
            ((Track *)gpsTrackPOI).version = 0;         //make version = 0 to insure the nodes are saved with track file
        [self saveCurrentGPSTrack];   //save to a file in order to be attached to an email
    }
    MFMailComposeViewController * email=[[MFMailComposeViewController alloc] init];
    email.mailComposeDelegate=self;   //<== Need to implement the delegate protocol
    // Email Subject
    [email setSubject:gpsTrackPOI.mainText];
    // email message body
    //[email setMessageBody:message isHTML:YES];
    NSData * dataFile=[self getNSDataFromDrawingLineFile:gpsTrackPOI.mainText];      //read GPS Track from saved file
    NSString *fn;
    if(self.Mtype == MGPSTRACK)
        fn=[gpsTrackPOI.mainText stringByAppendingString:@".gps"];
    else if(self.Mtype == MTRACK)
        fn=[gpsTrackPOI.mainText stringByAppendingString:@".dra"];
    else
        fn=[gpsTrackPOI.mainText stringByAppendingString:@".poi"];

    NSLog(@"file %@ has data lengh of %lu",fn,(unsigned long)[dataFile length]);
    // attachment
    [email addAttachmentData:dataFile mimeType:@"application/octet-stream" fileName:fn];
    
    //[self presentModalViewController:email animated:YES];  //deprecated in iOS6
    [self presentViewController:email animated:YES completion:nil];
}
- (IBAction)SendGPSTrack:(id)sender {
    NSLog(@"Sending GPS Track File through Email");
    [self sendEmail2];
}
-(void)displayGPSTrackInfo{
    if (self.Mtype == MPOI) {
        return;
    }
    if (!((Track *)gpsTrackPOI).nodes) {
        return;
    }
    if ([((Track *)gpsTrackPOI).nodes count]==0) {
        return;
    }
    NSDate * t1=((GPSNode *)((GPSTrack *)gpsTrackPOI).nodes[0]).timestamp;
    NSDate * t2=((GPSNode *)[((Track *)gpsTrackPOI).nodes lastObject]).timestamp;
    NSTimeInterval tm=[t2 timeIntervalSinceDate:t1];
    
    double miles=((GPSTrack *)gpsTrackPOI).tripmeter/1609;
    double f2=miles*3600;
    float avgSpd=f2/tm;
    lbAvgSpeed.text=[[NSString alloc]initWithFormat:@"%5.1f MPH",avgSpd];
    lbTotalTime.text=[[NSString alloc]initWithFormat:@"%02.0f:%02.0f:%02.0f",floor(tm/3600),fmod(floor(tm/60),60),fmod(tm,60)];
    
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[((Track *)gpsTrackPOI).nodes count]];
}
-(void)displayTrackInfo{
    if (self.Mtype == MPOI) {
        return;
    }
    if (!((Track *)gpsTrackPOI).nodes) {
        return;
    }
    if ([((Track *)gpsTrackPOI).nodes count]==0) {
        return;
    }
//    NSDate * t1=((GPSNode *)gpsTrack.nodes[0]).timestamp;
//    NSDate * t2=((GPSNode *)[gpsTrack.nodes lastObject]).timestamp;
//    NSTimeInterval tm=[t2 timeIntervalSinceDate:t1];
    
    //double miles=gpsTrack.tripmeter/1609;
    //double f2=miles*3600;
    //float avgSpd=f2/tm;
    //lbAvgSpeed.text=[[NSString alloc]initWithFormat:@"%5.1f MPH",avgSpd];
    //lbTotalTime.text=[[NSString alloc]initWithFormat:@"%02.0f:%02.0f:%02.0f",floor(tm/3600),fmod(floor(tm/60),60),fmod(tm,60)];
    
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[((Track *)gpsTrackPOI).nodes count]];
}
#pragma mark------UITextFieldDelegate Methods------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}
#pragma mark------MFMailComposeViewControllerDelegate Methods------------------------
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
