//
//  PM2ViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "PM2ViewController.h"
#import "MapScrollView.h"
#import "MapSources.h"

@interface PM2ViewController ()

@end

@implementation PM2ViewController

@synthesize mapScrollView;
@synthesize mapSources;
//float zmc;

-(void)add_MapScrollView{
    float bazel=20;     //set to 0 to maxmize map area
	CGRect visibleBounds = [self.view bounds];
	float width=visibleBounds.size.width-2*bazel;
	float height=visibleBounds.size.height-2*bazel;
	mapScrollView=[[MapScrollView alloc] initWithFrame:CGRectMake(bazel,bazel,width,height)];
    
    mapSources=[[MapSources alloc]init];
    mapSources->bSatMap=FALSE;
    
    mapScrollView.mapsourceDelegate=mapSources;
	
    [[self view] addSubview:mapScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //[self add_ImageScrollView];    //add map tile scroll view
    [self add_MapScrollView];    //add map tile scroll view
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
