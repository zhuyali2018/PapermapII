//
//  LinePropPickerViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyButton.h"

@interface LinePropPickerViewController : UIViewController
@property (nonatomic,strong)UIButton * okBn;

@property (nonatomic,strong)UILabel * sampleLineLabel;
@property (nonatomic,strong)UILabel * sampleTextLabel;

@property(nonatomic,strong) UISlider * redSlider;
@property(nonatomic,strong) UISlider * greSlider;
@property(nonatomic,strong) UISlider * bluSlider;
@property(nonatomic,strong) UISlider * alfSlider;
@property(nonatomic,strong) UISlider * widSlider;

@property(nonatomic,strong)UILabel * redBarLabel;
@property(nonatomic,strong)UILabel * greBarLabel;
@property(nonatomic,strong)UILabel * bluBarLabel;
@property(nonatomic,strong)UILabel * opqBarLabel;		//label for opaque
@property(nonatomic,strong)UILabel * thiBarLabel;		//label for thickness
@property(nonatomic,strong)PropertyButton * sampleLine;		//Sample line
@property(nonatomic,strong)NSString * savedTitle;
@property float red;
@property float green;
@property float blue;
@property float alf;
@property float wid;

-(void)setProperty:(LineProperty *)lp;

@end
