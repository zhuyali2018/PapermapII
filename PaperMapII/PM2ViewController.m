//
//  PM2ViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "PM2ViewController.h"
//#import "MapScrollView.h"
//#import "TappableMapScrollView.h"
#import "DrawableMapScrollView.h"
#import "MapSources.h"
#import "Recorder.h"
#import "LineProperty.h"

@interface PM2ViewController ()

@end

@implementation PM2ViewController

@synthesize mapScrollView;
@synthesize mapSources;
@synthesize lineProperty;
//float zmc;

-(void)add_MapScrollView{
    float bazel=20;     //set to 0 to maxmize map area
	CGRect visibleBounds = [self.view bounds];
	float width=visibleBounds.size.width-2*bazel;
	float height=visibleBounds.size.height-2*bazel;
	//mapScrollView=[[TappableMapScrollView alloc] initWithFrame:CGRectMake(bazel,bazel,width,height)];
    mapScrollView=[[DrawableMapScrollView alloc] initWithFrame:CGRectMake(bazel,bazel,width,height)];
    mapSources=[[MapSources alloc]init];
    mapSources.mapType=googleMap;
    
    mapScrollView.mapsourceDelegate=mapSources;	
    [[self view] addSubview:mapScrollView];
    
    //Drawing Recoder or GPS Recorder
    self.routRecorder=[[Recorder alloc]init];
    if(self.routRecorder)
        mapScrollView.recordingDelegate=_routRecorder;
    lineProperty=[[LineProperty alloc]initWithRed:0.2 green:0.3 blue:0.9 alpha:0.8 linewidth:3];
    [self.routRecorder start:lineProperty];   //user tap to enter intow drawing state here
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
