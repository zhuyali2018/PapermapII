//
//  PM2ViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawableMapScrollView;
@class MapSources;
@class Recorder;
@class LineProperty;
@interface PM2ViewController : UIViewController

@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UIButton *fdrawButton;
@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;
@property (nonatomic, strong) MapSources * mapSources;
@property (nonatomic, strong) Recorder * routRecorder;
@property (nonatomic, strong) LineProperty * lineProperty;
@property (nonatomic, strong) NSMutableArray  * arrAllTracks;     //array of tracks

-(void)applicationWillTerminate:(NSNotification *)notification;

@end
