//
//  PM2AppDelegate.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PM2ViewController;
@class Reachability;

@interface PM2AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PM2ViewController *viewController;

@end
