//
//  DrawingViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 7/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "PropertyButton.h"
@interface DrawingViewController : UIViewController
@property (nonatomic,strong) Track * drawTrack;
@property (nonatomic,strong) IBOutlet UILabel * drawTrackName;

@property (nonatomic,strong) IBOutlet UILabel * lbTimeCreated;
@property (nonatomic,strong) IBOutlet UIButton * bnViewDetails;
@property (nonatomic,strong) IBOutlet UIButton * bnEdit;
@property (nonatomic,strong) IBOutlet UIButton * visibleSwitchBn;
@property (nonatomic,strong) IBOutlet UITextField * txtEdit;
@property (nonatomic,strong) IBOutlet UILabel * lbNumberOfNodes;

@property (nonatomic,strong) IBOutlet PropertyButton * propBn;

@property (nonatomic,strong) IBOutlet UIButton * fButton;   //forward button
@property (nonatomic,strong) IBOutlet UIButton * bButton;   //backward button
@property NSInteger idx;
-(IBAction)fButonClicked:(id)sender;
-(IBAction)bButonClicked:(id)sender;


-(IBAction)viewDetailsBnClicked:(id)sender;
-(IBAction)editBnClicked:(id)sender;
- (IBAction) pickLineProperty:(id)sender;
- (IBAction) visibleBnClicked:(id)sender;

@end
