//
//  HelpViewController.h
//  TwoDGPS
//
//  Created by zhuyali on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <WebKit/WebKit.h>

@class MainMenuViewController;
@interface HelpViewController : UIViewController<WKNavigationDelegate> {
	IBOutlet WKWebView * web;
	IBOutlet UIBarButtonItem * dismissBn;
	MainMenuViewController * rootView;
}
@property (nonatomic) WKWebView * web;
@property (nonatomic ) UIBarButtonItem * dismissBn;
@property(nonatomic)MainMenuViewController * rootView;
-(IBAction)dismiss;
@end
