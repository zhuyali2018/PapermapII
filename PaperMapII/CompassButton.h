//
//  CompassButton.h
//  TwoDGPS
//
//  Created by zhuyali on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface CompassButton : UIView {
	float direction;
	UIImageView *arrow1;
    UIImageView *arrowCenter;
	UIButton * centerButton;
}
@property(nonatomic,assign) float direction;
@property(nonatomic) UIImageView *arrow1;
@property(nonatomic) UIImageView *arrowCenter;
@property(nonatomic) UIButton * centerButton;
@end
