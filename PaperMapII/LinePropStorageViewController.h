//
//  LinePropStorageViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyButton.h"
#import "LinePropPickerViewController.h"

@class LinePropertyViewController;

@interface LinePropStorageViewController : UIViewController
@property (nonatomic, strong) NSMutableArray * propBns;
@property (nonatomic, strong) NSMutableArray * propChgBns;
@property (nonatomic,strong) LinePropPickerViewController * linePPVCtrl;
@property (nonatomic, weak) UIView * parentView;
@property (nonatomic, weak) LinePropertyViewController * parentViewCtrlr;
@end
