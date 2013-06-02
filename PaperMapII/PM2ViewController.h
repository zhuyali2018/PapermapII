//
//  PM2ViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class TiledScrollView; //TODO: delete this line
@class DrawableMapScrollView;
@class MapSources;
@class Recorder;
@interface PM2ViewController : UIViewController

@property (nonatomic, strong) DrawableMapScrollView * mapScrollView;
@property (nonatomic, strong) MapSources * mapSources;
@property (nonatomic, strong) Recorder * routRecorder;
@end
