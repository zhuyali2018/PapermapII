//
//  PM2OnScreenButtons.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"
#import "DrawableMapScrollView.h"
#import "LinePropertyViewController.h"
#import "MainMenuViewController.h"
#import "OnOffButton.h"

@class GPSReceiver;
@class MainMenuViewController;

@interface PM2OnScreenButtons : NSObject <OnOffBnDelegate>
@property (nonatomic, strong) UIToolbar	* toolbar;
@property (nonatomic, strong) UIBarButtonItem * menuBn;



@property (nonatomic, strong) UIButton * bnStart;       //all onscreen control buttons and menus starts from here
@property (nonatomic, strong) OnOffButton *drawButton;
@property (nonatomic, strong) UIButton *drawBn1;
//@property (nonatomic, strong) UIButton * drawBn;
@property (nonatomic, strong) OnOffButton *fdrawButton;
@property (nonatomic, strong) OnOffButton *undoButton;

@property (nonatomic, strong) OnOffButton *gpsButton;
@property (nonatomic, strong) UIButton * gpsBn1;    //for toolbar
@property (nonatomic, strong) OnOffButton * centerBn;

@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) UIButton *cleanupButton;

@property (nonatomic, strong) UIButton *mapTypeButton;
@property (nonatomic, strong) UIButton *unloadDrawingButton;
@property (nonatomic, strong) UIButton *unloadGPSTrackButton;
@property (nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong) UILabel * speedLabel;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *tripLabel;
@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) Recorder * routRecorder;
@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;
@property (nonatomic, strong) UILabel * resLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) GPSReceiver * gpsReceiver;
@property (strong, nonatomic) UIPopoverController* colorPickPopover;
@property (strong, nonatomic) UIPopoverController* menuPopover;
@property (strong, nonatomic) LinePropertyViewController * linePropertyViewCtrlr;
@property (strong, nonatomic) MainMenuViewController * menuController;
@property (nonatomic, strong) UIImageView * arrow;
+ (id)sharedBnManager;
-(void)addToolBar:(UIView *)vc;
-(void)addButtons:(UIView *)vc;
-(void)add_bnStart;
-(void)addDrawButton;
-(void)addFreeDrawButton;
-(void)addUndoButton;
-(void) addGPSButton;
-(void) add_CenterBn;
-(void) addMapTypeButton;
-(void) addColorButton;
-(void) add_MainMenu;

-(void)addMapLevelLabel;
-(void)addScaleRuler;
-(void)addMapCenterIndicator:(UIView*)vc;
-(void)add_GPSArrow;
-(void)add_buttonsToToolbar:(bool)noGotoBn;

-(void)repositionButtonsFromX:(int)x Y:(int)y;
-(void)positionStartBnWidth:(int)w Height:(int)h;
-(void) colorPicker;
@end
