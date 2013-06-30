//
//  MainMenuViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MainMenuViewController : UITableViewController
@property (nonatomic,strong)MenuItem * gpsTrackMenuItem;
@property (nonatomic,strong)NSArray * drawingMenuItems;
@property (nonatomic,strong)NSArray * gpsMenuItems;
@property (nonatomic,strong)NSArray * poiMenuItems;
@property (nonatomic,strong)NSArray * helpMenuItems;

-(void)showGPSTrackList:(id) sender;

@end
