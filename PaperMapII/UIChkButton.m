//
//  UIChkButton.m
//  PicOrganizer
//
//  Created by zhuyali on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIChkButton.h"

@implementation UIChkButton
@synthesize checked;
@synthesize imgChecked, imgUnchecked;

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)coder{
	[super encodeWithCoder:coder];
	[coder encodeBool:self.checked forKey:kCheckedKey];
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super initWithCoder:coder]){
		self.checked=TRUE; //[coder decodeBoolForKey:kCheckedKey];
	}
	return self;
}
-(id)copyWithZone:(NSZone *)zone {
	//[super copyWithZone:zone];
	UIChkButton * bnCopy=[[[self class] allocWithZone:zone] init];
	bnCopy.checked=self.checked;
	return bnCopy;
}

- (void)checkAction{
	self.checked=!self.checked;
	if(self.checked){
		//UIImage *img = [UIImage imageNamed:@"checked.png"];
		[self setImage:imgChecked forState:UIControlStateNormal];		
	}else{
		//UIImage *img = [UIImage imageNamed:@"unchecked.png"];
		[self setImage:imgUnchecked forState:UIControlStateNormal];		
	}
}
- (void)set_Checked:(bool)bChecked{
	self.checked=bChecked;
	if(self.checked){
		//UIImage *img = [UIImage imageNamed:@"checked.png"];
		[self setImage:imgChecked forState:UIControlStateNormal];		
	}else{
		//UIImage *img = [UIImage imageNamed:@"unchecked.png"];
		[self setImage:imgUnchecked forState:UIControlStateNormal];		
	}
}

@end
