//
//  Settings.m
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Settings.h"
#import "SettingItem.h"
#import "PM2OnScreenButtons.h"
#import "PM2ViewController.h"
#import "PM2AppDelegate.h"
#import "ScaleRuler.h"
#import "MapCenterIndicator.h"
#import "MapSources.h"

@implementation Settings
@synthesize settingArray;

+ (Settings *)sharedSettings{
    static Settings *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(id)init{
    self = [super init];
    if (self) {
            NSArray *settingArray1=[[NSArray alloc]initWithObjects:
                            [[SettingItem alloc]initWithTitle:@"Show Scale Ruler"       with:(int)SHOW_SCALE_RULLER  andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Map Center"        with:SHOW_MAP_CENTER    andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Hide Status Bar"        with:HIDE_STATUSBAR     andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Direction Up On GPS"    with:DIRECTION_UP       andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Use Cached Map Only"    with:CACHED_MAP_ONLY    andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Use Internet Map Only"  with:INTERNET_MAP_ONLY  andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Map Level"         with:SHOW_MAP_LEVEL     andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Speed Meter"       with:HIDE_SPEED_METER   andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Altitude Meter"    with:HIDE_ALT_METER     andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Trip Meter"        with:HIDE_TRIP_METER    andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Show Trip Timer"        with:HIDE_TRIP_TIMER    andCheckBoxHandler:self],
                            [[SettingItem alloc]initWithTitle:@"Map In Chinese"         with:SHOW_MAP_CHINESE   andCheckBoxHandler:self],
                            nil];
        settingArray=[[NSMutableArray alloc]initWithCapacity:11];
        [settingArray addObjectsFromArray:settingArray1];
    }
    return self;
}
-(bool)getSetting:(int)index{
    return ((SettingItem *)settingArray[index]).selected;
}
-(void)setSetting:(int)index to:(bool)show{
    ((SettingItem *)settingArray[index]).selected=show;
}
-(void)saveMapLaugnage:(bool)chineseMap{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:chineseMap forKey:@"ChineseMap"];
}
extern float zmc;
extern bool directionUp;
- (void)onCheckBox:(int)index changedTo:(bool)gotSelected{
    UILabel * lb;
    CGRect windowfr,mapviewfr,viewcontrollerfr;
    int W,H;
    NSLog(@"checkbox %d clicked changed to %d",index,gotSelected);
    switch (index) {
        case SHOW_SCALE_RULLER:
            [ScaleRuler update];
            break;
        case SHOW_MAP_CENTER:
            [MapCenterIndicator sharedMapCenter];
            break;
        case HIDE_STATUSBAR:
            [[UIApplication sharedApplication] setStatusBarHidden:gotSelected withAnimation:YES];
            break;
        case DIRECTION_UP:
            windowfr = [[UIScreen mainScreen] bounds];
            mapviewfr=[[DrawableMapScrollView sharedMap] frame];
            viewcontrollerfr=((PM2AppDelegate *)[UIApplication sharedApplication].delegate).viewController.view.bounds;
            if(gotSelected){   //if directionUp just changed to true
                directionUp=true;
                W=viewcontrollerfr.size.width;
                H=viewcontrollerfr.size.height;
                [[DrawableMapScrollView sharedMap] setFrame:CGRectMake((W-1280)/2,(H-1280)/2,1280,1280)];
                zmc=1.3;
            }else { //just resume the North Up Mode
                //change map to NorthUp Position
                CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                [UIView beginAnimations:nil context:NULL];
                [DrawableMapScrollView sharedMap].transform = transform;    //rotate map
                [UIView commitAnimations];
                
                directionUp=false;
                int W=viewcontrollerfr.size.width;
                int H=viewcontrollerfr.size.height;
                [[DrawableMapScrollView sharedMap] setFrame:CGRectMake(0,0,W,H)];
                zmc=1.0;
            }
            break;
        case CACHED_MAP_ONLY:break;
        case INTERNET_MAP_ONLY:break;
        case SHOW_MAP_LEVEL:
            lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).resLabel;
            lb.hidden=(!gotSelected);
            break;
        case HIDE_SPEED_METER:
            lb=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).speedLabel;
            lb.hidden=!gotSelected;
            break;
        case HIDE_ALT_METER:
            lb=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).heightLabel;
            lb.hidden=!gotSelected;
            break;
        case HIDE_TRIP_METER:
            lb=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).tripLabel;
            lb.hidden=!gotSelected;
            break;
        case HIDE_TRIP_TIMER:
            lb=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).timerLabel;
            lb.hidden=!gotSelected;
            break;
        case SHOW_MAP_CHINESE:
            if (gotSelected) {
                [MapSources sharedManager].mapInChinese = true;
                
            }else{
                [MapSources sharedManager].mapInChinese = false;
            }
            [self saveMapLaugnage:gotSelected];
            break;
        default:
            break;
    }
}
@end
