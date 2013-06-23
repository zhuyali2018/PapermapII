//
//  PropertyButton.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProperty.h"
@interface PropertyButton : UIButton
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong) LineProperty * lineProperty;
@property int ID;
@end
