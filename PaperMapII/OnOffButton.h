//
//  OnOffButton.h
//  PaperMapII
//
//  Created by Yali Zhu on 7/9/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PM2Protocols.h"

@interface OnOffButton : UIButton
@property bool btnOn;
@property bool withGroup;   //with group of buttons or not?
@property bool pushButton;  //is this a push button (single state button)?
@property UIColor * OnBackgroundColor;
@property UIColor * OffBackgroundColor;
@property (nonatomic,strong) NSString * onText;
@property (nonatomic,strong) NSString * offText;
@property SEL tapEventHandler;
@property (nonatomic) id<OnOffBnDelegate> onOffBnDelegate;
-(void)setPositionX:(int)x Y:(int)y;

@end
