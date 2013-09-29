//
//  LinePropertyViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "LinePropertyViewController.h"
#import "PropertyButton.h"
#import "AllImports.h"
#import "PM2OnScreenButtons.h"

@interface LinePropertyViewController ()

@end

@implementation LinePropertyViewController
@synthesize bnDrawingLine;
@synthesize bnGPSTrack;
@synthesize gpsTrackLabel;
@synthesize drawingLineLabel;
@synthesize linePSVCtrl;
@synthesize trackProperty;

- (id) init{
    self=[super init];
    if(self){
        [self.view setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}
-(void)goBack{
	[self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIBarButtonItem * backBn = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = backBn;
    }
    bnGPSTrack   =[[PropertyButton alloc] initWithFrame:CGRectMake(10, 20,  300, 150)];
    bnDrawingLine=[[PropertyButton alloc] initWithFrame:CGRectMake(10, 190, 300, 150)];
    [bnGPSTrack.titleLabel    setText:@"GPS Track:"];
    [bnDrawingLine.titleLabel setText:@"Drawing Line:"];
    [bnGPSTrack    setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];
    [bnDrawingLine setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];
    
    bnGPSTrack.lineProperty=[LineProperty sharedGPSTrackProperty];
    bnDrawingLine.lineProperty=[LineProperty sharedDrawingLineProperty];
    [bnDrawingLine addTarget:self action:@selector(pickLineProperty:) forControlEvents:UIControlEventTouchUpInside];
    [bnGPSTrack    addTarget:self action:@selector(pickLineProperty:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bnGPSTrack];
    [self.view addSubview:bnDrawingLine];
}
-(void) viewWillAppear:(BOOL)animated{
    NSLOG8(@"view Will Appear");
    [linePSVCtrl.view removeFromSuperview];
    
    [bnGPSTrack setNeedsDisplay];
    [bnDrawingLine setNeedsDisplay];
    
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    [OSB.linePropertyViewCtrlr setTitle:@"Pick one for Property Setting"];
}
- (void) pickLineProperty:(id)sender{
    if(linePSVCtrl==nil){
		linePSVCtrl=[[LinePropStorageViewController alloc] init];
        [linePSVCtrl.view setFrame:CGRectMake(0, 0, 320, 550)];
	}
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
    
    UIViewAnimationTransition transition=UIViewAnimationTransitionFlipFromLeft;
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    
    [linePSVCtrl viewWillAppear:YES];
    [self.view insertSubview:linePSVCtrl.view aboveSubview:bnDrawingLine];
	linePSVCtrl.parentView=self.view;  //important, need this to dismiss the view after picking
    linePSVCtrl.parentViewCtrlr=self;
	[UIView commitAnimations];
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if(bnGPSTrack==sender){
        NSLOG8(@"setting GPS Track property!");
        [OSB.linePropertyViewCtrlr setTitle:@"Pick a Property for GPS Track"];
        trackProperty=GPSTrackProperty;
    }else{
        NSLOG8(@"setting line property!");
        [OSB.linePropertyViewCtrlr setTitle:@"Pick a Property for Drawing"];
        trackProperty=DrawingLineProperty;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
