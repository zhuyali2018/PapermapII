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

@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;
@property (nonatomic, strong) MapSources * mapSources;
@property BOOL orientationChanging;

-(void)applicationWillTerminate:(NSNotification *)notification;

@end
