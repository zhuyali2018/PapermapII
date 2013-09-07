//
//  LockupScreen.h
//  TwoDGPS
//
//  Created by zhuyali on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface LockupScreen : UIView {
	UISlider * alfSlider;
	CGFloat  alpha;
	UILabel	 * alfLabel;
    bool    locked;
    bool    screenOn;   //LockScreen is on
}
@property CGFloat  alpha;
@property (nonatomic) UILabel * alfLabel;
@property (nonatomic,weak) UIView * rootView;
-(void) buttonPressed;
@end
