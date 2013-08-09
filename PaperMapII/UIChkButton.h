//
//  UIChkButton.h
//  PicOrganizer
//
//  Created by zhuyali on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kCheckedKey  @"checkedKey"

@interface UIChkButton : UIButton {
	bool checked;
	UIImage * imgChecked;
	UIImage * imgUnchecked;
}
@property bool checked;
@property (nonatomic) UIImage * imgChecked;
@property (nonatomic) UIImage * imgUnchecked;

- (void)checkAction;
- (void)set_Checked:(bool)bChecked;
@end
