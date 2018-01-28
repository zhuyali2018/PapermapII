//
//  MainMenuViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MenuItem.h"
#import "ExpandableMenuViewController.h"
#import "ListViewController.h"


@interface MainMenuViewController : UITableViewController <TrackHandleDelegate,UITextFieldDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate,MFMailComposeViewControllerDelegate>{

    UIPopoverController *menuPopoverController;
    UIPopoverController *helpPopoverController;
}
@property BOOL adjustingMap;      //flag for adjust Map error

@property (nonatomic,strong)NSArray * menuMatrix;
@property (nonatomic,strong)ListViewController * fileListView;


//bluetooth connection
@property(nonatomic) GKSession *session;
@property(nonatomic,copy) NSString * peerID;

//expandableMenus
@property (nonatomic,strong) ExpandableMenuViewController *menuDrawings;
@property (nonatomic,strong) ExpandableMenuViewController *menuGPSTracks;
@property (nonatomic,strong) ExpandableMenuViewController *menuPOIs;
@property (nonatomic,strong) ExpandableMenuViewController *menuSettings;


-(void)SendEmailToDeveloper;
-(void)Help;

@property (nonatomic) UIPopoverController *menuPopoverController;
@property (nonatomic) UIPopoverController *helpPopoverController;


@end
