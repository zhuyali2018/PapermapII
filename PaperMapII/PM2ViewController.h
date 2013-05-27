//
//  PM2ViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TiledScrollView; //TODO: delete this line
@class TappableMapScrollView;
@class MapSources;

@interface PM2ViewController : UIViewController

@property (nonatomic, strong) TappableMapScrollView * mapScrollView;
@property (nonatomic, strong) MapSources * mapSources;
@end
