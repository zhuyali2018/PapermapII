//
//  MainMenuViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MenuItem.h"
#import "ExpandableMenuViewController.h"
#import "ListViewController.h"
@interface MainMenuViewController : UITableViewController <TrackHandleDelegate,UITextFieldDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate>

@property (nonatomic,strong)NSArray * menuMatrix;
@property (nonatomic,strong)ListViewController * fileListView;


//bluetooth connection
@property(nonatomic) GKSession *session;
@property(nonatomic,copy) NSString * peerID;

@end
