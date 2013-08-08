//
//  PM2OnScreenButtons.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "PM2OnScreenButtons.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "ScaleRuler.h"
#import "MapCenterIndicator.h"
#import "GPSReceiver.h"
#import "MapTile.h"
#import "MainQ.h"
#import "PM2Protocols.h"
#import "MenuItem.h"
@implementation PM2OnScreenButtons

@synthesize bnStart;

@synthesize drawButton;
@synthesize fdrawButton;
@synthesize undoButton;

@synthesize gpsButton;
@synthesize centerBn;

@synthesize colorButton;
@synthesize mapScrollView;
@synthesize resLabel;
@synthesize messageLabel;
@synthesize gpsReceiver;
@synthesize colorPickPopover;
@synthesize menuPopover;
@synthesize linePropertyViewCtrlr;
@synthesize menuController;

@synthesize cleanupButton;

@synthesize mapTypeButton;
@synthesize unloadDrawingButton;
@synthesize unloadGPSTrackButton;
@synthesize speedLabel;
@synthesize heightLabel;
@synthesize tripLabel;
@synthesize menuButton;
@synthesize arrow;


+ (id)sharedBnManager {
    static PM2OnScreenButtons *onScreenbuttons = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onScreenbuttons = [[self alloc] init];
    });
    return onScreenbuttons;
}
- (id)init {
    if (self = [super init]) {
        _routRecorder=[Recorder sharedRecorder];
        mapScrollView=[DrawableMapScrollView sharedMap];
        gpsReceiver=[GPSReceiver sharedGPSReceiver];
    }
    return self;
}
#pragma mark ------------methods----------------
-(void)addButtons:(UIView *)vc{
    _baseView=vc;
    [self add_bnStart];
    [self addDrawButton];
    [self addFreeDrawButton];
    [self addUndoButton];
    [self addMapLevelLabel];
    [self addScaleRuler];
    [self addMapCenterIndicator:vc];
    [self addMessageLabel];
    [self addGPSButton];
    //[self addStopGPSButton];
    //[self addTrackCleanupButton];
    [self addColorButton];
    [self addMapTypeButton];
    //[self addUnloadDrawingButton];
    //[self addUnloadGPSTrackButton];
    //[self repositionButtonsFromX:800 Y:0];
    [self add_SpeedPanel];
    [self add_HeightPanel];
    [self add_TripMeter];
    [self add_GPSArrow];
    [self add_CenterBn];
    [self add_MainMenu];
}
#pragma mark ------------start button methods----------------
-(void)add_bnStart{
    bnStart=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [bnStart setTitle:@"Buttons" forState:UIControlStateNormal];
    [bnStart addTarget:self action:@selector(showButtons) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:bnStart];
    [self positionStartBn];    
    [self setButtonsVisible:NO];
}
-(void)positionStartBn{
    int screenW=[[UIScreen mainScreen] bounds].size.width;
	int screenH=[[UIScreen mainScreen] bounds].size.height;
    [self positionStartBnWidth:screenW Height:screenH];
}
-(void)positionStartBnWidth:(int)w Height:(int)h{
    int x=w-80;
    int y=h-70+20;
    CGRect frame=CGRectMake(x, y, 80, 50);
    [bnStart setFrame:frame];
}
-(void)showButtons{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn //UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setButtonsVisible:YES];
                         [self setButtonsToPosition:YES];
                     }
                     completion:^(BOOL finished){
                         NSLOG8(@"Done!");
                     }];
}
-(void) setButtonsVisible:(bool)bVisible{
    drawButton.hidden   =!bVisible;
    colorButton.hidden  =!bVisible;
    gpsButton.hidden    =!bVisible;
    mapTypeButton.hidden=!bVisible;
    centerBn.hidden     =!bVisible;
    menuButton.hidden   =!bVisible;
}
-(void) setButtonsToPosition:(bool)bVisible{
    int screenW=[_baseView bounds].size.width;
    int x=screenW-110;
    int y=150;
    if(bVisible){
        [self repositionButtonsFromX:x Y:y];
    }else{
        [self repositionButtonsFromX:x+800 Y:y];
    }
}

-(void)repositionButtonsFromX:(int)x Y:(int)y{
    int w=100;
    int h=60;
    int s=60;   //row apart
    if (undoButton.withGroup) [undoButton  setFrame:CGRectMake(x+200, y=y+s, w, h)];
    if (fdrawButton.withGroup)[fdrawButton setFrame:CGRectMake(x+200, y,     w, h)];
    if (drawButton.withGroup) [drawButton  setFrame:CGRectMake(x,     y,     w, h)];
    
    if (centerBn.withGroup)   [centerBn    setFrame:CGRectMake(x+200, y=y+s+1, w, h)];
    if (gpsButton.withGroup)  [gpsButton   setFrame:CGRectMake(x,     y,     w, h)];
    [colorButton            setFrame:CGRectMake(x, y=y+s+1, w, h)];
    [mapTypeButton          setFrame:CGRectMake(x, y=y+s+1, w, h)];
    [menuButton             setFrame:CGRectMake(x, y=y+s+1, w, h)];
}
#pragma mark ------------drawing button methods----------------
-(void)startDrawingRecorder:(OnOffButton *)bn{
    if (bn.btnOn) {   //start drawing mode
        [self.routRecorder start];   //user tap to enter into drawing state here
        NSLOG4(@"Recorder started!");
        self.mapScrollView.mapPined=TRUE;
        [self.mapScrollView setScrollEnabled:NO];
        self.mapScrollView.freeDraw=false;
        self.mapScrollView.bDrawing=true;
        [self.mapScrollView setPreDraw:true];  //dv.preDraw=true;
        bn.withGroup=false;
        undoButton.withGroup=false;
        fdrawButton.withGroup=false;
        [self showDrawingButtons];
        bnStart.hidden=YES;
    }else{
        [self.routRecorder stop];
        NSLOG4(@"Recorder Stopped!");
        self.mapScrollView.mapPined=FALSE;
        [self.mapScrollView setScrollEnabled:YES];
        [self.mapScrollView clearAll];
        [mapScrollView refresh];
        //reset the free draw button too
        self.mapScrollView.freeDraw=false;
        [self.mapScrollView setFreeDraw:TRUE]; //dv.preDraw=TRUE;
        fdrawButton.withGroup=YES;
        undoButton.withGroup=YES;
        drawButton.withGroup=YES;
        [self hideDrawingButtons];
        bnStart.hidden=NO;
    }
}
//show drawing related buttons
//such as free drawing, undo buttons
-(void)showDrawingButtons{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn //UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setButtonsToPosition:NO];        //hide all buttons
                         drawButton.hidden=NO;
                         [drawButton  setFrame:CGRectMake(0,   40, 80,  60)];
                         [fdrawButton setFrame:CGRectMake(80,  40, 120, 60)];
                         [undoButton  setFrame:CGRectMake(200, 40, 80,  60)];
                     }
                     completion:^(BOOL finished){
                         NSLOG8(@"Done!");
                     }];
}
-(void)hideDrawingButtons{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn //UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setButtonsToPosition:NO];
                     }
                     completion:^(BOOL finished){
                         NSLOG8(@"Done!");
                     }];
}
-(void)addFreeDrawButton{
    fdrawButton=[[OnOffButton alloc] init];
    [fdrawButton setTitle:@"Free Draw" forState:UIControlStateNormal];
    [fdrawButton setOffText:@"Free Draw"];
    [fdrawButton setOnText: @"Line Draw"];
    fdrawButton.OffBackgroundColor=[UIColor blueColor];
    fdrawButton.OnBackgroundColor=[UIColor orangeColor];
    [fdrawButton setBackgroundColor:fdrawButton.OffBackgroundColor];
    fdrawButton.onOffBnDelegate=self;
    fdrawButton.tapEventHandler=@selector(switchToFreeDraw:);
    [_baseView addSubview:fdrawButton];
    
}
-(void)addDrawButton{
    //drawButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    drawButton=[[OnOffButton alloc] init];
    [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [drawButton setOffText:@"Draw"];
    [drawButton setOnText: @"Exit Draw"];
    drawButton.onOffBnDelegate=self;
    //[drawButton addTarget:self action:@selector(startDrawingRecorder:) forControlEvents:UIControlEventTouchUpInside];
    drawButton.tapEventHandler=@selector(startDrawingRecorder:);
    [_baseView addSubview:drawButton];
}
-(void)addUndoButton{
    //undoButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    undoButton=[[OnOffButton alloc] init];
    [undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    undoButton.pushButton=true;
    undoButton.onOffBnDelegate=self;
    //[undoButton addTarget:self action:@selector(undoDrawing:) forControlEvents:UIControlEventTouchUpInside];
    undoButton.tapEventHandler=@selector(undoDrawing:);
    [_baseView addSubview:undoButton];
}
-(void)undoDrawing:(UIButton *)bn{
    [self.routRecorder undo];
    NSLOG5(@"Undo drawing called");
    [mapScrollView refresh];
    [mapScrollView refreshDrawingBoard];
}
-(void)switchToFreeDraw:(OnOffButton *)bn{
    if (bn.btnOn) {
        self.mapScrollView.freeDraw=true;
        [self.mapScrollView setPreDraw:FALSE];
        [self.routRecorder startNewTrack];
    }else{
        self.mapScrollView.freeDraw=false;
        [self.mapScrollView setPreDraw:TRUE];
   }
}

#pragma mark ------------gps button methods----------------
-(void) addGPSButton{
    gpsButton=[[OnOffButton alloc] init];
    [gpsButton setTitle:@"Start GPS" forState:UIControlStateNormal];
    [gpsButton setOffText:@"Start GPS"];
    [gpsButton setOnText: @"Stop GPS"];
    gpsButton.onOffBnDelegate=self;
    gpsButton.tapEventHandler=@selector(startGPS:);
    [_baseView addSubview:gpsButton];
}
-(void)add_CenterBn{
    centerBn=[[OnOffButton alloc] init];
    [centerBn setTitle:@"Center Cur" forState:UIControlStateNormal];
    [centerBn setOffText:@"Center Cur"];
    [centerBn setOnText: @"No Center"];
    centerBn.onOffBnDelegate=self;
    centerBn.tapEventHandler=@selector(centerCurrentPosition:);
    [_baseView addSubview:centerBn];
}
extern bool centerPos;
-(void)centerCurrentPosition:(id)sender{
    //if ([[centerBn.titleLabel text] compare:@"Center Cur"]==NSOrderedSame) {
    if(centerBn.btnOn){
        //center position;
        centerPos=true;
        //[centerBn setTitle:@"No center" forState:UIControlStateNormal];
    }else{
        centerPos=false;
        //[centerBn setTitle:@"Center Cur" forState:UIControlStateNormal];
    }
}
-(void) startGPS:(OnOffButton *)bn{
    
     if(bn.btnOn){
        [gpsReceiver start];
        //if (!v)return;
        arrow.hidden=NO;
        bn.withGroup=false;
        centerBn.withGroup=false;
        [self showGPSButtons];
        //bnStart.hidden=YES;
    }else{
        [gpsReceiver stop];
        [speedLabel setHidden:YES];
        //if (!v)return;
        //v.hidden=NO;  //TODO:need to be Yes
        
        arrow.hidden=YES;
        
        bn.withGroup=YES;
        centerBn.withGroup=YES;
        //[self hideGPSButtons];
        //bnStart.hidden=NO;
        [self hideDrawingButtons];
    }
}
-(void)showGPSButtons{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn //UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setButtonsToPosition:NO];        //hide all buttons
                         drawButton.hidden=NO;
                         [gpsButton  setFrame:CGRectMake(0,   40, 120,  60)];
                         [centerBn   setFrame:CGRectMake(122, 40, 120, 60)];
                     }
                     completion:^(BOOL finished){
                         NSLOG8(@"Done!");
                     }];
}
-(void)hideGPSButtons{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn //UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setButtonsToPosition:NO];
                     }
                     completion:^(BOOL finished){
                         NSLOG8(@"Done!");
                     }];
}
#pragma mark ------------other methods----------------
-(void)addUnloadDrawingButton{
    unloadDrawingButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [unloadDrawingButton setTitle:@"Del Drawings" forState:UIControlStateNormal];
    [unloadDrawingButton addTarget:self action:@selector(unloadDrawings:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:unloadDrawingButton];
}
-(void)addUnloadGPSTrackButton{
    unloadGPSTrackButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [unloadGPSTrackButton setTitle:@"Unload GPS Track" forState:UIControlStateNormal];
    [unloadGPSTrackButton addTarget:self action:@selector(unloadGPSTrack:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:unloadGPSTrackButton];
}
-(void) addMapTypeButton{
    mapTypeButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [mapTypeButton setTitle:@"Sat" forState:UIControlStateNormal];
    [mapTypeButton addTarget:self action:@selector(toggleMapType:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:mapTypeButton];
}
-(void) addColorButton{
    colorButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [colorButton setTitle:@"Pick Color" forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(colorPicker) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:colorButton];
}
-(void) addTrackCleanupButton{
    cleanupButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [cleanupButton setTitle:@"Clean up" forState:UIControlStateNormal];
    [cleanupButton addTarget:self action:@selector(cleanUpTrack) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:cleanupButton];
}

//-(void) addStopGPSButton{
//    stopGpsButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
//    [stopGpsButton setTitle:@"Stop GPS" forState:UIControlStateNormal];
//    [stopGpsButton addTarget:self action:@selector(stopGPS:) forControlEvents:UIControlEventTouchUpInside];
//    [_baseView addSubview:stopGpsButton];
//}
-(void) add_MainMenu{
    menuButton=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:menuButton];
}
-(void)showMenu{
    NSLOG10(@"showMenu button tapped!");
    if (menuPopover == nil) {
        Class cls = NSClassFromString(@"UIPopoverController");
        if (cls != nil) {
			menuController=[[MainMenuViewController alloc] init];
            [menuController setTitle:@"Main Menu"];
            
			UINavigationController * ctrl=[[UINavigationController alloc]initWithRootViewController:menuController];
			UIPopoverController *aPopoverController =[[cls alloc] initWithContentViewController:ctrl];
		    self.menuPopover = aPopoverController;
        }
    }
    if([menuPopover isPopoverVisible]){
		[menuPopover dismissPopoverAnimated:YES];
	}else{
		[menuPopover setPopoverContentSize:CGSizeMake(350,1024) animated:YES];
        //[menuPopover presentPopoverFromRect:menuButton.frame inView:_baseView permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
        //[menuPopover presentPopoverFromRect:CGRectMake(0, 0, 1, 1) inView:_baseView permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
        [menuPopover presentPopoverFromRect:CGRectMake(-30, -30, 0, 0) inView:_baseView permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
	}
}
-(void)cleanUpTrack{
    [_routRecorder unloadTracks];
    [mapScrollView refresh];
}
-(void) colorPicker{
    NSLOG8(@"ColorPicker button tapped!");
    if (colorPickPopover == nil) {
        Class cls = NSClassFromString(@"UIPopoverController");
        if (cls != nil) {
			linePropertyViewCtrlr=[[LinePropertyViewController alloc] init];
            
            [linePropertyViewCtrlr setTitle:@"Line Property setting"];
            
			UINavigationController * ctrl=[[UINavigationController alloc]initWithRootViewController:linePropertyViewCtrlr];
			UIPopoverController *aPopoverController =[[cls alloc] initWithContentViewController:ctrl];
		    self.colorPickPopover = aPopoverController;
        }
    }
    if([colorPickPopover isPopoverVisible]){
		[colorPickPopover dismissPopoverAnimated:YES];
	}else{
		[colorPickPopover setPopoverContentSize:CGSizeMake(350,400) animated:YES];
        [colorPickPopover presentPopoverFromRect:colorButton.frame inView:_baseView permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
	}
}

-(void) stopGPS:(id)bn{
    [gpsReceiver stop];
    //UIButton* b=bn;
    [gpsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gpsButton setBackgroundColor:[UIColor lightGrayColor]];
}
-(void) addMessageLabel{

    //int screenW=[_baseView bounds].size.width;
	int screenH=[_baseView bounds].size.height;

    messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, screenH-40, 720, 40)];
    [messageLabel setBackgroundColor:[UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:0.7]];
	[messageLabel setTextColor:[UIColor greenColor]];
	[messageLabel setShadowColor:[UIColor blackColor]];
	[messageLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
	[messageLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_baseView addSubview:messageLabel];
    [[MainQ sharedManager] register:messageLabel withID:MESSAGELABEL];  //register to receive text for displaying and other settings
}
-(void)addMapCenterIndicator:(UIView*)vc{
    int screenH=[vc bounds].size.width;
	int screenW=[vc bounds].size.height;
    MapCenterIndicator * mc=[MapCenterIndicator sharedMapCenter:CGRectMake(screenW/2-10-1, (screenH-20)/2-10+0, 20, 20)];
    [vc addSubview:mc];
}
    
-(void)addScaleRuler{
    ScaleRuler * scaleRuler=[ScaleRuler shareScaleRuler:CGRectMake(30, 0,700,30)];
    [scaleRuler setBackgroundColor:[UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:0.7]];
    [_baseView addSubview:scaleRuler];
}
-(void)addMapLevelLabel{
    resLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[resLabel setBackgroundColor:[UIColor clearColor]];
	[resLabel setTextColor:[UIColor greenColor]];
	[resLabel setShadowColor:[UIColor blackColor]];
	[resLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
	[resLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_baseView addSubview:resLabel];
    [[MainQ sharedManager] register:resLabel withID:MAPRES];
}
-(void)toggleMapType:(UIButton *)bn{
    NSLOG9(@"toggleMapType here !");
    MainQ * mQ=[MainQ sharedManager];
    id<PM2MapSourceDelegate> mapSrc=(id<PM2MapSourceDelegate>)[mQ getTargetRef:MAPSOURCE];
    if ([[bn.titleLabel text] compare:@"Map"]==NSOrderedSame) {
        [bn setTitle:@"Sat" forState:UIControlStateNormal];
        [mapSrc setMapSourceType:googleMap];
    }else{
        [bn setTitle:@"Map" forState:UIControlStateNormal];
        [mapSrc setMapSourceType:googleSat];
    }
    [mapScrollView reloadData];
    [mapScrollView refresh];
}
-(void)unloadGPSTrack:(UIButton *)bn{
    [_routRecorder unloadGPSTracks];
    [mapScrollView refresh];
}
-(void)unloadDrawings:(UIButton *)bn{
    [_routRecorder unloadDrawings];
    [mapScrollView refresh];
}
-(void)add_SpeedPanel{
    //Speed panel
    //int screenW=[[UIScreen mainScreen] applicationFrame].size.width;
	//int screenH=[[UIScreen mainScreen] applicationFrame].size.height;
    int screenH=[_baseView frame].size.height;
	speedLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,screenH-180, 400, 140)];
    //speedLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 400, 140)];
	[speedLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6]];
	[speedLabel setTextColor:[UIColor yellowColor]];
	[speedLabel setShadowColor:[UIColor blackColor]];
	[speedLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[speedLabel setFont:[UIFont boldSystemFontOfSize:130]];
	[speedLabel setText:[NSString stringWithFormat:@" %4.1f  ",128.2]];
	[speedLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:speedLabel];
	speedLabel.hidden=YES;  //TODO: change to YES;
	
	//unit label
	UILabel * unitLabel=[[UILabel alloc] initWithFrame:CGRectMake(340, 90, 60, 40)];
	[unitLabel setBackgroundColor:[UIColor clearColor]];
	[unitLabel setTextColor:[UIColor whiteColor]];
	
	//[unitLabel setText:@"MPH"];
	[speedLabel addSubview:unitLabel];
	
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString * unit=(NSString *)[defaults objectForKey:@"unit"];
	//if([unit compare:@"km"]==0){
    bool bMetric=false;     //TODO: do sth with this line
    if(bMetric){
		//bMetric=TRUE;
		[unitLabel setText:@"KM/Hr"];
	}else {
		//bMetric=FALSE;
		[unitLabel setText:@"MPH"];
	}
    [_baseView addSubview:speedLabel];
    [[MainQ sharedManager] register:speedLabel withID:SPEEDLABEL];
}
-(void)add_HeightPanel{
    int screenH=[_baseView frame].size.height;
	heightLabel=[[UILabel alloc] initWithFrame:CGRectMake(402,screenH-80, 300, 40)];
	[heightLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.4 alpha:0.5]];
	[heightLabel setTextColor:[UIColor yellowColor]];
	[heightLabel setShadowColor:[UIColor blackColor]];
	[heightLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[heightLabel setFont:[UIFont boldSystemFontOfSize:30]];
    //heightLabel.hidden=YES;
	//[heightLabel setText:[NSString stringWithFormat:@" %4.1fm ",128.2]];
	[heightLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:heightLabel];
    [[MainQ sharedManager] register:heightLabel withID:ALTITUDELABEL];  //register to receive text for displaying and other settings
}
-(void)add_TripMeter{
    int screenH=[_baseView frame].size.height;
	tripLabel=[[UILabel alloc] initWithFrame:CGRectMake(402,screenH-122, 300, 40)];
	[tripLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.5]];
	[tripLabel setTextColor:[UIColor yellowColor]];
	[tripLabel setShadowColor:[UIColor blackColor]];
	[tripLabel setShadowOffset:CGSizeMake(2.0, 2.0)];
	[tripLabel setFont:[UIFont boldSystemFontOfSize:30]];
    //tripLabel.hidden=YES;
	//[tripLabel setText:[NSString stringWithFormat:@" %4.1fm ",128.2]];
	[tripLabel setTextAlignment:UITextAlignmentRight];
    [_baseView addSubview:tripLabel];
    [[MainQ sharedManager] register:tripLabel withID:TRIPMETER];
}
-(void)add_GPSArrow{
    arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Arrow.png"]];
    [_baseView addSubview:arrow];
    arrow.hidden=NO;   //TODO:need to be YES
    
    [[MainQ sharedManager] register:arrow withID:GPSARROW];
}

@end
