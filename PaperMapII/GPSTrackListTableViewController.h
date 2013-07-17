//
//  GPSTrackListTableViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllImports.h"

@interface GPSTrackListTableViewController : UITableViewController
@property ListType listType;
- (id)initWithType:(ListType)listType;
@end
