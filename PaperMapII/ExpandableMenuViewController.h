//
//  ExpandableMenuViewController.h
//  CollapsableMenu
//
//  Created by Yali Zhu on 7/21/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDataSource.h"

@protocol TrackHandleDelegate <NSObject>
@optional
- (void)tappedOnIndexPath:(int)row ID:(int)myid;
- (void)onFolderCheckBox;
@end

@interface ExpandableMenuViewController : UITableViewController<MenuDataSource>
@property (nonatomic,strong)NSMutableArray * menuList;   //holding the data for menu display
@property (nonatomic,weak)NSMutableArray * trackList;  //really holding the data
@property (nonatomic,strong)NSArray * subMenuList;      // holding data in a folder temparily
@property (nonatomic) id<TrackHandleDelegate> trackHandlerDelegate;
@property int id;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * plusButton;

@end
