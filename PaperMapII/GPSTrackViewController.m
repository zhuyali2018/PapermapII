
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
    if (gpsTrack.folder) {
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
        gpsTrackName.text=gpsTrack.mainText;
        lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:gpsTrack.cdate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        return;
    }
    gpsTrackName.text=gpsTrack.title;
    lbTimeCreated.text = [NSDateFormatter localizedStringFromDate:gpsTrack.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    
    bnSend.hidden=true;
    if (listType==DRAWLIST) {
        lbNameTrackLength.hidden=YES;
        lbNameTotalTile.hidden=YES;
        lbNameAvgSpeed.hidden=YES;
        [propBn.titleLabel setText:@"Drawing Property:"];
        propBn.lineProperty=gpsTrack.lineProperty;
    } else if(listType==SENDGPSTRACK){
        bnSend.hidden=false;
        lbGpsTrackLength.text=[[NSString alloc]initWithFormat:@"%3.1f miles (%d meters)",(float)gpsTrack.tripmeter/1609,gpsTrack.tripmeter];
        [propBn.titleLabel setText:@"GPS Track Property:"];
        propBn.lineProperty=gpsTrack.lineProperty;
    } else if(listType==SENDDRAWING){
        bnSend.hidden=false;
        //lbGpsTrackLength.text=[[NSString alloc]initWithFormat:@"%3.1f miles (%d meters)",(float)gpsTrack.tripmeter/1609,gpsTrack.tripmeter];
        [propBn.titleLabel setText:@"Drawing Property:"];
        propBn.lineProperty=gpsTrack.lineProperty;
    }
    [propBn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];  //TODO: Choose a better image here
    
    if ((listType==DRAWLIST) ||(listType==SENDDRAWING)) {
        [self displayTrackInfo];
    }else if ((listType==GPSLIST) || (listType==SENDGPSTRACK)){
        [self displayGPSTrackInfo];
    }
    
    if (gpsTrack.selected) {
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
    if (_isGpsTrack) {
        gpsTrack.lineProperty=[[LineProperty sharedGPSTrackProperty] copy];
    }else{
        gpsTrack.lineProperty=[[LineProperty sharedDrawingLineProperty] copy];
    }
    propBn.lineProperty=gpsTrack.lineProperty;
    [propBn setNeedsDisplay];   //update the property page with new track property
    [[DrawableMapScrollView sharedMap] refresh];
}
-(IBAction)viewDetailsBnClicked:(id)sender{
    GPSTrackNodesViewController * gpsTrackNodesListViewCtrlr=[[GPSTrackNodesViewController alloc]init];
    gpsTrackNodesListViewCtrlr.gpsTrack=self.gpsTrack;
    [gpsTrackNodesListViewCtrlr setTitle:@"Nodes in Track"];
    [self.navigationController pushViewController:gpsTrackNodesListViewCtrlr animated:YES];
}
-(IBAction)editBnClicked:(id)sender{
    if ([[bnEdit.titleLabel text] compare:@"Save"]!=NSOrderedSame) {
        NSLog(@"editBnClicked");
        txtEdit.hidden=NO;
        txtEdit.text=gpsTrack.mainText;
        [bnEdit setTitle:@"Save"forState:UIControlStateNormal];
    }else{ //save changes
        txtEdit.hidden=YES;
        gpsTrack.mainText=txtEdit.text;//gpsTrack.title=txtEdit.text;
        gpsTrackName.text=gpsTrack.mainText;//gpsTrack.title;
        [bnEdit setTitle:@"Edit"forState:UIControlStateNormal];
        gpsTrack.mainLabel.text=gpsTrack.mainText;//gpsTrack.title;
        //[gpsTrack.mainLabel setNeedsDisplay];
    }
}
- (IBAction) visibleBnClicked:(id)sender{
    if ([[visibleSwitchBn.titleLabel text] compare:@"Hide"]==NSOrderedSame) {
        [visibleSwitchBn setTitle:@"Show" forState:UIControlStateNormal];
        gpsTrack.visible=FALSE;
        [gpsTrack saveNodes];
    }else{
        [visibleSwitchBn setTitle:@"Hide" forState:UIControlStateNormal];
        gpsTrack.visible=TRUE;
        if (!gpsTrack.nodes) {      //read in nodes only if nodes not read in yet
            [gpsTrack readNodes];
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
    [gpsTrack readNodes];    //make sure the nodes are read in before saving to a temp file for emailing
    NSString * trackFilename=[self getGPSTrackFileNameWithPath:gpsTrack.mainText];
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSMutableArray * gpsTrackArray=[NSMutableArray arrayWithCapacity:1];
    [gpsTrackArray addObject:gpsTrack];
    if(_isGpsTrack)
        [archiver encodeObject:gpsTrackArray forKey:@"gpsTrackOnly"];  //<== the key @"gpsTrackOnly" will be used in the email receiver for unarchiving
    else
        [archiver encodeObject:gpsTrackArray forKey:@"DrawTrackOnly"];  //<== the key @"DrawTrackOnly" will be used in the email receiver for unarchiving
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
    if(_isGpsTrack)
        gpsTrackArray=[Recorder sharedRecorder].gpsTrackArray;
    else
        gpsTrackArray=[Recorder sharedRecorder].trackArray;
    
    for (int i=row; i<[gpsTrackArray count];i++) {
        MenuNode * nd=[gpsTrackArray objectAtIndex:i];
        if ((i==row)||nd.infolder) {    //if the first folder entry or the gpstrack entries that follow
            if (nd.infolder) {
                ((Track *)nd).version = 0;
            }
            [gpsTracksInFolder addObject:nd];
        }else{
            break;          //if end of folder, break
        }
        //nd.rootArrayIndex=i;        //keep track of its position in original array
    }
    
    if(_isGpsTrack)
        [archiver encodeObject:gpsTracksInFolder forKey:@"gpsTrackOnly"];  //<== the key @"gpsTrackOnly" will be used in the email receiver for unarchiving
    else
        [archiver encodeObject:gpsTracksInFolder forKey:@"DrawTrackOnly"];  //<== the key @"DrawTrackOnly" will be used in the email receiver for unarchiving
    
    [archiver finishEncoding];
    
    [data writeToFile:trackFilename atomically:YES];
}

-(void) sendEmail2{
    if((!bWANavailable)&&(!bWiFiAvailable)){
        UIAlertView * alert1=[[UIAlertView alloc]initWithTitle:@"Email service \nis not available now" message:@"Sending Email requires \ninternet access \nwhich is not available now\n\n Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert1 show];
        return;
    }
    if (gpsTrack.folder) {
        [self createTempFileForFolder:gpsTrack];
    }else{
        gpsTrack.version = 0;         //make version = 0 to insure the nodes are saved with track file
        [self saveCurrentGPSTrack];   //save to a file in order to be attached to an email
    }
    MFMailComposeViewController * email=[[MFMailComposeViewController alloc] init];
    email.mailComposeDelegate=self;   //<== Need to implement the delegate protocol
    // Email Subject
    [email setSubject:gpsTrack.mainText];
    // email message body
    //[email setMessageBody:message isHTML:YES];
    NSData * dataFile=[self getNSDataFromDrawingLineFile:gpsTrack.mainText];      //read GPS Track from saved file
    NSString *fn;
    if (_isGpsTrack) {
        fn=[gpsTrack.mainText stringByAppendingString:@".gps"];
    }else{
        fn=[gpsTrack.mainText stringByAppendingString:@".dra"];
    }
//    NSString *fn;
//    if (dataType==DRAWING){
//        fn=[draw.title stringByAppendingString:@".dra"];
//    }else if (dataType==GPSNODES){
//        fn=[draw.title stringByAppendingString:@".gps"];
//    }else {
//        fn=[draw.title stringByAppendingString:@".poi"];
//    }

    NSLog(@"file %@ has data lengh of %d",fn,[dataFile length]);
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
    if (!gpsTrack.nodes) {
        return;
    }
    if ([gpsTrack.nodes count]==0) {
        return;
    }
    NSDate * t1=((GPSNode *)gpsTrack.nodes[0]).timestamp;
    NSDate * t2=((GPSNode *)[gpsTrack.nodes lastObject]).timestamp;
    NSTimeInterval tm=[t2 timeIntervalSinceDate:t1];
    
    double miles=gpsTrack.tripmeter/1609;
    double f2=miles*3600;
    float avgSpd=f2/tm;
    lbAvgSpeed.text=[[NSString alloc]initWithFormat:@"%5.1f MPH",avgSpd];
    lbTotalTime.text=[[NSString alloc]initWithFormat:@"%02.0f:%02.0f:%02.0f",floor(tm/3600),fmod(floor(tm/60),60),fmod(tm,60)];
    
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[gpsTrack.nodes count]];
}
-(void)displayTrackInfo{
    if (!gpsTrack.nodes) {
        return;
    }
    if ([gpsTrack.nodes count]==0) {
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
    
    self.lbNumberOfNodes.text=[[NSString alloc]initWithFormat:@"%3lu",(unsigned long)[gpsTrack.nodes count]];
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
