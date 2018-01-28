    //
//  HelpViewController.m
//  TwoDGPS
//
//  Created by zhuyali on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController


@synthesize web;
@synthesize dismissBn;
@synthesize rootView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
-(IBAction)dismiss{
#ifdef TARGET_IPAD	
	if (rootView.helpPopoverController != nil) {
        [rootView.helpPopoverController dismissPopoverAnimated:YES];		
    }
#endif	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://68.204.125.18:900/PaperMapiPad4/"]]];   //version 5.5
}

//extern BOOL bAutorotate;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return YES;	
	//return bAutorotate;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
