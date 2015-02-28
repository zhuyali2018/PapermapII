//
//  PM2AppDelegate.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "AllImports.h"
#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "Recorder.h"
#import "Reachability.h"

@implementation PM2AppDelegate
@synthesize viewController;

bool bWANavailable=FALSE;
bool bWiFiAvailable=FALSE;
bool bHostAvailable=FALSE;

// check for internet availablity
- (void) updateGlobalVarsWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach){
        bHostAvailable=[curReach currentReachabilityStatus];
    }
    if(curReach == internetReach)
    {
        bWANavailable=[curReach currentReachabilityStatus];
    }
    if(curReach == wifiReach)
    {
        bWiFiAvailable=[curReach currentReachabilityStatus];
    }
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateGlobalVarsWithReachability: curReach];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifer];
    [self updateGlobalVarsWithReachability: internetReach];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
    [wifiReach startNotifer];
    [self updateGlobalVarsWithReachability: wifiReach];
    
    //hostReach = [Reachability reachabilityWithHostName: @"www.yalisoft.org"];
    hostReach = [Reachability reachabilityWithHostName: @"68.204.125.18"];
    [hostReach startNotifer];
    [self updateGlobalVarsWithReachability: hostReach];
    //--------------------------------
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CGRect winLocSize=self.window.bounds;
    NSLOG6(@"didFinishLaunchingWithOptions MainWindow: x=%.f, y=%.f, w=%.f, h=%.f",winLocSize.origin.x,winLocSize.origin.y,winLocSize.size.width,winLocSize.size.height);
    // Override point for customization after application launch.
    self.viewController = [[PM2ViewController alloc] initWithNibName:@"PM2ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString * ext=[url pathExtension];
    NSString * fn=[url lastPathComponent];
    NSString * fnInbox=[@"Inbox/" stringByAppendingString:fn];
    NSLog(@"fnInbox=%@",fnInbox);
    if([ext compare:@"dra"]==NSOrderedSame){
        [[Recorder sharedRecorder] addDrawingFile:fnInbox];
    }else if ([ext compare:@"gps"]==NSOrderedSame) {
        [[Recorder sharedRecorder] loadGPSTrackFromFile:fnInbox];   
    }else if ([ext compare:@"poi"]==NSOrderedSame) {
        [[Recorder sharedRecorder] loadPOIFile:fnInbox];
    }
    return TRUE;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [viewController applicationWillTerminate:nil];
    NSLOG6("applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLOG6("applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLOG6("applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLOG6("applicationDidBecomeActive");
    //[[Recorder sharedRecorder] saveAllGpsTracks];       //need to save what was recorded during the inactive period
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLOG6(@"applicationWillTerminate");
    [viewController applicationWillTerminate:nil];
}

@end
