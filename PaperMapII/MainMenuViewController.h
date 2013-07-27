//
//  MainMenuViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
#import "ExpandableMenuViewController.h"

@interface MainMenuViewController : UITableViewController <TrackHandleDelegate>

@property (nonatomic,strong)NSArray * menuMatrix;

@end
