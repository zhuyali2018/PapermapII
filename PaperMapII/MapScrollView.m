//
//  MapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "MapScrollView.h"
#import "MapTile.h"
#import "GPSTrackPOIBoard.h"
#import "DrawingBoard.h"
#import "TapDetectView.h"
#import "PM2OnScreenButtons.h"
#import "ScaleRuler.h"
#import "MainQ.h"
#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "Settings.h"
#import "MapCenterIndicator.h"
#import "MapSources.h"

@implementation MapScrollView

@synthesize zoomView;
@synthesize gpsTrackPOIBoard;
@synthesize drawingBoard;

//@synthesize maplevel;


const int bz=0;        //bezel width, should be set to 0 eventually
//const int SIZE=256;

float zmc=1;
CGPoint savedOffset;

-(void)setMaplevel:(int)maplevel1{
    maplevel=maplevel1;
    self.gpsTrackPOIBoard.maplevel=maplevel;  //TODO: handle maplevel properly (there are 3 references in gpsTrackBOIBoard)
    NSLOG3(@"MapLevel set to %d on gpsTrackPOIBoard",maplevel);
}
-(int)maplevel{
    NSLOG3(@"getMaplevel returns mapvel %d",maplevel);
    return maplevel;
}
long firstVisibleRowx[4],firstVisibleColumnx[4],lastVisibleRowx[4], lastVisibleColumnx[4];
-(void)initVisibleVarArrays{
    // no rows or columns are visible at first; note this by making the firsts very high and the lasts very low
	for(int i=0;i<4;i++){
		firstVisibleRowx[i]   =NSIntegerMax;
		firstVisibleColumnx[i]=NSIntegerMax;
		lastVisibleRowx[i]    =NSIntegerMin;
		lastVisibleColumnx[i] =NSIntegerMin;
	}
}
-(BOOL)alreadyLoaded:(int)row col:(int)col levelDiff:(int)i{
	if(i==0){
		for (MapTile *view in [zoomView.tileContainer subviews]) {
			if (view.row==row) {
				if(view.col==col){
					if(view.res==maplevel){
						return TRUE;
					}
				}
			}
		}
		return FALSE;
	}else {
		for (MapTile *view in [zoomView.basicMapLayer subviews]) {
			if (view.row==row) {
				if(view.col==col){
					if(view.res==(maplevel-i)){
						return TRUE;
					}
				}
			}
		}
	}
	return FALSE;
}
- (UIView *)dequeueReusableTile {
    UIView *tile = [reusableTiles anyObject];
    if (tile) {
        [reusableTiles removeObject:tile];
    }
    return tile;
}
-(MapTile *)tileForRow:(int)row column:(int)col mapLevel:(int)maplevel1{
    if ((row>=pow(2, maplevel1))||(col>=pow(2, maplevel1))) {  //if asked for out of bound map tiles, return nil
		return nil;
	}
	if((row<0)||(col<0)) return nil;
    
	//////////////////////////////////////////////////
	// Got ImageView tile from resuables or create new
	MapTile *tile1= (MapTile *)[self dequeueReusableTile];  
	if (!tile1) {
		tile1 = [[MapTile alloc] initWithFrame:CGRectZero];
	}else{  //TODO: remve the else before releasing, but remember to set image to NULL
        if (tile1.image) {
            NSLOG7(@"reused tile at %d,%d at level %d still has image in it!!!",tile1.row,tile1.col,tile1.res);
        }
    }
	//got a tile, assign the col,row ane res to it
	tile1.res=maplevel1;
	tile1.row=row;
	tile1.col=col;
	
    if (!Mode) {   //is the map Eastern hemisphere center or western one center of the map
        NSLOG(@"Mode is Eastern:col=%d, width=%.f",col,pow(2,maplevel1));
        int half=pow(2.0, maplevel1)/2;
        if (col>=half) {
            col=col-half;
        }else {
            col+=half;
        }
        NSLOG(@"Mode is Eastern:Converted to col=%d, width=%.f",col,pow(2,maplevel1));
    }else{
        NSLOG(@"Mode is Western=%d, width=%.f",col,pow(2,maplevel1));
    }

    tile1.modeCol=col;
     NSLOG(@"=============>Get Map tile %d, %d on level %d",tile1.row,tile1.col,tile1.res);
    //--------------------call mapsource delegate---------
    [tile1 setImage:NULL];  // important, otherwise the old map tile will show up before new one comes in
    if ([self.mapsourceDelegate respondsToSelector:@selector(mapTile:)]) {
        [self.mapsourceDelegate mapTile:tile1];
    }
	return tile1;
}
-(void)fillWindowWithBasicMap:(int)levelDiff{
    if(levelDiff<0) { NSLOG(@"error: levelDiff < 0, exit fillWindowWithBasicMap"); return;}
    NSLOG(@"in fillWindowWithBasicMap");
    int i=levelDiff;
	float tileSize=TSIZE*pow(2,levelDiff);
	float scaledTileSide  = tileSize  * [self zoomScale];
    
    int maxRow = floorf(([zoomView frame].size.height) / scaledTileSide);  // this is the maximum possible row
    int maxCol = floorf(([zoomView frame].size.width ) / scaledTileSide);  // and the maximum possible column
	
    CGRect visibleBounds = [self bounds];
    int firstNeededRow = MAX(0, floorf((visibleBounds.origin.y-posErr.y-posErr1.y) / scaledTileSide));
    int firstNeededCol = MAX(0, floorf((visibleBounds.origin.x-posErr.x-posErr1.x) / scaledTileSide));                //<======= This is just the ruffly row calculation,
	int lastNeededRow  = MIN(maxRow,floorf((CGRectGetMaxY(visibleBounds)-posErr.y-posErr1.y) / scaledTileSide));
    int lastNeededCol  = MIN(maxCol,floorf((CGRectGetMaxX(visibleBounds)-posErr.x-posErr1.x) / scaledTileSide));      //<=======
	
    if ((firstNeededRow==firstVisibleRowx[i])&&(firstNeededCol==firstVisibleColumnx[i])&&(lastNeededCol==lastVisibleColumnx[i])&&(lastNeededRow==lastVisibleRowx[i])) {
        NSLOG(@"exit fillWindowWithBasicMap (2) i=%d, neededRow=%d, visiRow=%ld",i,firstNeededRow,firstVisibleRowx[i]);
		return;
	}
    int loadedImageCount=0;
	for (int row = firstNeededRow; row <= lastNeededRow; row++) {
        for (int col = firstNeededCol; col <= lastNeededCol; col++) {
			BOOL tileIsMissing = (firstVisibleRowx[i] > row || firstVisibleColumnx[i] >= col ||lastVisibleRowx[i]  < row || lastVisibleColumnx[i]  < col);
			//NSLog(@"%d>%d ?  %d >%d ? %d - %d ",firstVisibleRowx[i],row,firstVisibleColumnx[i],col,lastVisibleRowx[i],lastVisibleColumnx[i]);
			if (tileIsMissing) {
				if([self alreadyLoaded:row col:col levelDiff:i]){
					NSLOG7(@"Already loaded image %d,%d on level %d",row,col,(maplevel-levelDiff));
					continue;
				}
				NSLOG(@"Load image %d,%d on level %d(%d-%d)",row,col,(maplevel-levelDiff),maplevel,levelDiff);
				MapTile * tile=[self tileForRow:row column:col mapLevel:(maplevel-levelDiff)];   //get the map tile image
                if(!tile){
                    NSLOG7(@"Returned nil when requesint tile at %d,%d on level %d",row,col,(maplevel-levelDiff));
                    continue;  //if tile is nil, return for the next one
                }
				[tile setFrame:CGRectMake(tileSize*col+posErr.x+posErr1.x, tileSize*row+posErr.y+posErr1.y, tileSize,tileSize)];
				if(i>0)
					[zoomView.basicMapLayer addSubview:tile];
				else{
                    //[zoomView.tileContainer annotateTile:tile res:tile.res row:tile.row col:tile.col];
					[zoomView.tileContainer addSubview:tile];
                }
				//[zoomView.tileContainer annotateTile:tile res:tile.res row:row col:col];  //add label to tile
				loadedImageCount++;
                if(loadedImageCount>36){
                    return;   // if it is more than 36, it must not be the layer that needs loading
                }
			}else{
                NSLOG(@"Tile NOT MISSING on image %d,%d on level %d",row,col,(maplevel-levelDiff));
            }
		}
	}

	firstVisibleRowx[i] = firstNeededRow; firstVisibleColumnx[i] = firstNeededCol;
    lastVisibleRowx[i]  = lastNeededRow;  lastVisibleColumnx[i]  = lastNeededCol;
    NSLOG(@"fillWindowWithBasicMap returns");
}

-(void) setMaxandMinZoomScale{
	[self setMaximumZoomScale:16];
	[self setMinimumZoomScale:0.125];
	if (maplevel==19) {
		[self setMaximumZoomScale:1.99];
	}else if (maplevel==18) {
		[self setMaximumZoomScale:2];
	}else if (maplevel==17) {
		[self setMaximumZoomScale:4];
	}else if (maplevel==16) {
		[self setMaximumZoomScale:8];
	}
	
	if(maplevel==minMapLevel){
		[self setMinimumZoomScale:1];
	}else if(maplevel==(minMapLevel+1)){
		[self setMinimumZoomScale:0.5];
	}else if(maplevel==(minMapLevel+2)){
		[self setMinimumZoomScale:0.25];
	}
}

//reload all except those on last Level
- (void)reloadData:(float)zoomFactor {
	// recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (MapTile *view in [zoomView.tileContainer subviews]) {
		//keep the last level
		if ((view.res==lastLevel)&&(lastLevel<maplevel)) {	//do not unload the last maplevel
            //adjust tile frame to the new maplevel for those that stay
            CGRect tileR=[view frame];
            CGRect newRect=CGRectMake(tileR.origin.x/zoomFactor, tileR.origin.y/zoomFactor, tileR.size.width/zoomFactor, tileR.size.height/zoomFactor);
            [view setFrame:newRect];
            //[zoomView.tileContainer annotateTile:view res:view.res row:view.row col:view.col];  //add label to tile
            //NSLOG7(@"tileContainer keep a tile of last level:%d, current level:%d",lastLevel,maplevel);
            continue;
		}
		
		[reusableTiles addObject:view];
		[view removeFromSuperview];
        view.row=-1;
		[(UIImageView *)view setImage:NULL];
        NSLOG(@"One Tile recycled !!!");
    }
	
	for (MapTile *view in [zoomView.basicMapLayer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
        view.row=-1;
		[(UIImageView *)view setImage:NULL];
        NSLOG(@"Another Tile in basic layer recycled !!!");
    }
	[self initVisibleVarArrays];
	[self setNeedsDisplay];
}
//reload all with no exceptions
- (void)reloadData {
	// recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (MapTile *view in [zoomView.tileContainer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
		[(UIImageView *)view setImage:NULL];
    }
    for (MapTile *view in [zoomView.basicMapLayer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
		[(UIImageView *)view setImage:NULL];
    }
	[self initVisibleVarArrays];
	//update maplevel display
	//TravelMapAppDelegate * dele=[[UIApplication sharedApplication] delegate];
	//[dele.viewController.resLabel setText:[NSString stringWithFormat:@" %d", maplevel]];
	[self setNeedsLayout];  //==> this calls layoutSubviews of UIScrollView or its sub class
	//[self setNeedsDisplay];
}
-(void) restoreOffset{  // this is an ugly workaround the random jump
	CGPoint currentOffset=[self contentOffset];
	if((abs(currentOffset.x-savedOffset.x)>200.0)||(abs(currentOffset.y-savedOffset.y)>200.0)){
		[self setContentOffset:savedOffset];
		[self setNeedsDisplay];
	}
	//[self setNeedsLayout];  //this one does not work
}
//reload all with no exceptions
- (void)unLoadAllMapTiles {
	// recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (MapTile *view in [zoomView.tileContainer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
        view.row=-1;
		[(UIImageView *)view setImage:NULL];
    }
    for (MapTile *view in [zoomView.basicMapLayer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
        view.row=-1;
		[(UIImageView *)view setImage:NULL];
    }
	[self initVisibleVarArrays];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int longside=MAX(frame.size.width,frame.size.height);
        int tilesNeeded=ceil(longside/TSIZE);
        int level=ceil(sqrt(tilesNeeded));
        int squareSide=pow(2,level)*TSIZE;
        [self setBackgroundColor:[UIColor blueColor]];
        self.showsVerticalScrollIndicator=NO;
		self.showsHorizontalScrollIndicator=NO;
        self.scrollsToTop=NO;
		[self setMaximumZoomScale:16];
		[self setMinimumZoomScale:1];
		[self setDelegate:self];  //key statement for pinch !
		[self setDecelerationRate:UIScrollViewDecelerationRateFast];  //Make it not too sensitive
        //set initial contentsize
		//need to set it otherwise the initial size is 0 and you can't move it until you zoom so that the content size align with zoomed view size
		CGSize initContentSize=CGSizeMake(squareSide, squareSide);
        [self setContentSize:initContentSize];  //No need to set contentsize(WRONG), the contentsize will be the same as viewFlattener's initial size ONLY WHEN ZOOM CHANGES
        
        //create zoom view
        zoomView=[[ZoomView alloc] initWithFrame:CGRectMake(bz,bz,1000, 1000)];
        [zoomView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:zoomView];
        //gpsTrackPOIBoard.pMode=&Mode;    //pass address to pMode on gpsTrackPOIBoard TODO: handle Mode properly
        
        //creategpsTrackPOIBoardView
        gpsTrackPOIBoard = [[GPSTrackPOIBoard alloc] initWithFrame:CGRectMake(100,100,frame.size.width-200,frame.size.height-200)];
		[self.zoomView addSubview:gpsTrackPOIBoard];
        //[gpsTrackPOIBoard setBackgroundColor:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.5]];
        [gpsTrackPOIBoard setBackgroundColor:[UIColor clearColor]];    //without this line, map view will be blocked black
        [[MainQ sharedManager] register:gpsTrackPOIBoard withID:GPSTRACKPOIBOARD];

        //create drawing board
        drawingBoard=[[DrawingBoard alloc]initWithFrame:frame];
		[drawingBoard setBackgroundColor:[UIColor clearColor]];
		[gpsTrackPOIBoard addSubview:drawingBoard];
        [[MainQ sharedManager] register:drawingBoard withID:DRAWINGBOARD];
        
        [self initVisibleVarArrays];
        //maplevel=level;
        [self setMaplevel:level];
		minMapLevel=level;
		maxMapLevel=19;
        reusableTiles = [[NSMutableSet alloc] init];
        Mode=TRUE;
    }
    return self;
}

-(BOOL)handleDrawingView{
	
	CGRect visibleBounds = [self bounds];   // get the bounds of scrollview on the coordinate system of its contentView - scrollView's frame always is 0,0,320,640 yali320
	
	int edge=MIN(visibleBounds.size.height,visibleBounds.size.width);
	//for production
	int DrawingFrameBezel=-1*edge;
	int DrawingFrameBezel1=-90;
	
	/////debug setings//////////
	//int DrawingFrameBezel=60;    //for drawing view, should be minus the size of buffering distance
	//int DrawingFrameBezel1=200;  //for windows, should be zero or minus for release
	
	//X0Y0 for frame visible
	static bool init = true;
	CGFloat X0=([self contentOffset].x+        DrawingFrameBezel1)/[self zoomScale];
	CGFloat Y0=([self contentOffset].y+        DrawingFrameBezel1)/[self zoomScale];
	CGFloat X1=X0+(visibleBounds.size.width -2*DrawingFrameBezel1)/[self zoomScale];
	CGFloat Y1=Y0+(visibleBounds.size.height-2*DrawingFrameBezel1)/[self zoomScale];
	
	static CGFloat x0,y0,x1,y1;
	//NSLog(@"[handleDrawingView] Checking Range:X0(%.0f) Y0(%.0f) X1(%.0f) Y1(%.0f) | (%.0f,%.0f),(%.0f,%.0f),[%.0f,%.0f],[%.0f,%.0f]",  X0-x0,Y0-y0,x1-X1,y1-Y1,  x0,y0,x1,y1,X0,Y0,X1,Y1);
	if(init){
		//lowercase x0y0 for drawingview moving with scrollview and adjust its position when far enough
		x0=([self contentOffset].x+        DrawingFrameBezel)/[self zoomScale];
		y0=([self contentOffset].y+        DrawingFrameBezel)/[self zoomScale];
		x1=x0+(visibleBounds.size.width -2*DrawingFrameBezel)/[self zoomScale];
		y1=y0+(visibleBounds.size.height-2*DrawingFrameBezel)/[self zoomScale];
		
		//[viewFlattener.drawLineView setFrame:CGRectMake(x0,y0,x1-x0,y1-y0)];
        [gpsTrackPOIBoard setFrame:CGRectMake(x0,y0,x1-x0,y1-y0)];
		[drawingBoard  setFrame:CGRectMake(0,0,x1-x0,y1-y0)];   //version 4.0
		init=false;
	} // else{[viewFlattener.drawLineView setFrame:CGRectMake(x0,y0,x1-x0,y1-y0)];}
	BOOL correct=(x0>X0)||(x1<X1)||(y0>Y0)||(y1<Y1);
	// this line of code keeps drawview stable relative to window
	if(correct){   //if offset is enough, centralize the drawing board
		x0=([self contentOffset].x+        DrawingFrameBezel)/[self zoomScale];
		y0=([self contentOffset].y+        DrawingFrameBezel)/[self zoomScale];
		x1=x0+(visibleBounds.size.width- 2*DrawingFrameBezel)/[self zoomScale];
		y1=y0+(visibleBounds.size.height-2*DrawingFrameBezel)/[self zoomScale];
		[gpsTrackPOIBoard setFrame:CGRectMake(x0,y0,x1-x0,y1-y0)];
		[drawingBoard setFrame:CGRectMake(0,0,x1-x0,y1-y0)];   //version 4.0
		[gpsTrackPOIBoard setNeedsDisplay];   //redrawLines
        //[viewFlattener.drawLineView setNeedsLayout];   //redrawLines
	}
	return true;   //always return true to update the tile while making move map with drawing smooth
	//return correct||resolutionChanged;
}
-(void) updateArrowPosition{
    //update the arrow position
    MainQ * mQ=[MainQ sharedManager];
    UIImageView * arrow =(UIImageView *)[mQ getTargetRef:GPSARROW];
    if ([arrow isEqual:@"0"]) {
        return;
    }
    //GPSTrackPOIBoard * trackBoard=self.zoomView.gpsTrackPOIBoard;
    GPSNode * node=((Recorder *)[Recorder sharedRecorder]).lastGpsNode;
    CGPoint arrowCenter=[gpsTrackPOIBoard ConvertPoint:(Node *)node];
    PM2AppDelegate * appD=[[UIApplication sharedApplication] delegate];
	CGPoint arrowCenter0=[gpsTrackPOIBoard  convertPoint:arrowCenter toView:appD.viewController.view];
    arrow.center=arrowCenter0;
}
- (void)layoutSubviews{
    if ([Recorder sharedRecorder].gpsRecording) {
        [Recorder sharedRecorder].userBusy=true;
    }
    [[ScaleRuler shareScaleRuler:CGRectMake(30, 0,700,30)] updateRuler:self];
    //update maplevel
    UILabel * lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).resLabel;
    lb.hidden=(![[Settings sharedSettings] getSetting:SHOW_MAP_LEVEL]);
    [lb setText:[NSString stringWithFormat:@" %d", maplevel]];
    //update map center
    [MapCenterIndicator sharedMapCenter];
    
    if (self.zooming){
        NSLOG(@"self.zooming, exit layoutSubviews:W:%.f, H:%.f",self.contentSize.width,self.contentSize.height);
        return;
    }
    [self updateArrowPosition];
    NSLOG(@"in layoutSubviews");
    NSLOG(@"ContentOffset:x:%.f, y:%.f",self.contentOffset.x,self.contentOffset.y);
    NSLOG(@"ContentSize:W:%.f, H:%.f\n\n",self.contentSize.width,self.contentSize.height);
    
    int x1=self.contentOffset.x;
    int x2=[self bounds].size.width;
    if ((x1+x2)>=self.contentSize.width) {
        NSLOG(@"====================> right edge reached, time to change mode!: %d+%d=%d>%.f",x1,x2,(x1+x2),self.contentSize.width);
        CGPoint offset=[self contentOffset];
        CGSize Size=[self contentSize];
        if (offset.x>Size.width/2) {
            offset.x-=Size.width/2;
            [self setContentOffset:offset];
            [self unLoadAllMapTiles];
            [self setNeedsDisplay];
            [gpsTrackPOIBoard setNeedsDisplay];
             Mode=!Mode;
            return;
        }
    }
    if (x1<0) {
        CGPoint offset=[self contentOffset];
        CGSize Size=[self contentSize];
        CGSize bsz=[self bounds].size;
        if (bsz.width<Size.width/2) {
            offset.x+=Size.width/2;
            [self setContentOffset:offset];
            [self unLoadAllMapTiles];
            [self setNeedsDisplay];
            [gpsTrackPOIBoard setNeedsDisplay];
            Mode=!Mode;
            return;
        }
    }

    [self handleDrawingView];   //drawing view here
    
    if(maplevel>4){
		int levelDiff=maplevel-4;
		
		if(levelDiff>3)
			levelDiff=3;
		for(int i=levelDiff;i>0;i--){
			[self fillWindowWithBasicMap:i];
		}
	}
    [self fillWindowWithBasicMap:0];   //version 5.03 added
    if([Recorder sharedRecorder].gpsRecording)
        [Recorder sharedRecorder].userBusy=false;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#define MAPLEVEL @"maplevel"
#define ZOOMSCALE  @"zoomScale"
#define CONTENTOFFSET_X @"ContentOffsetX"
#define CONTENTOFFSET_Y @"ContentOffsetY"
#define CONTENTSIZEWIDE @"CONTENTSIZEWIDE"
#define CONTETSIZEHEIGHT @"CONTETSIZEHEIGHT"
#define MODE            @"MODE"
#define SATMAP			@"SATORMAP"
-(void)saveMapState{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:self.maplevel forKey:MAPLEVEL];
	//float zs=imageScrollView.zoomScale;
	[defaults setFloat:self.zoomScale forKey:ZOOMSCALE];
	
	[defaults setFloat:[self contentOffset].x forKey:CONTENTOFFSET_X];
    [defaults setFloat:[self contentOffset].y forKey:CONTENTOFFSET_Y];
	
	[defaults setFloat:[self contentSize].width forKey:CONTENTSIZEWIDE];
    [defaults setFloat:[self contentSize].height forKey:CONTETSIZEHEIGHT];
    [defaults setBool:Mode forKey:MODE];
	//[defaults setBool:imageScrollView.bSatMap forKey:SATMAP];
	//[defaults setBool:bResetPrecinct forKey:@"bResetPrecinct"];
	[defaults synchronize];
}
-(void)restoreMapState{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	float zScale= [defaults floatForKey:ZOOMSCALE];
    Mode=[defaults boolForKey:MODE];
	self.maplevel=(int)[defaults integerForKey:MAPLEVEL];
    if (self.maplevel==0) {
        self.maplevel=2;
        return;     //it means the state has never beensaved
    }
	// if the saved level is less than minMapLevel, that means data is corrupted, start over
	[self setZoomScale:zScale];
	
	CGPoint contentOffset;
	contentOffset.x=[defaults floatForKey:CONTENTOFFSET_X];
	contentOffset.y=[defaults floatForKey:CONTENTOFFSET_Y];
	[self setContentOffset: contentOffset];
    
	CGSize contentSize;
	contentSize.width=[defaults floatForKey:CONTENTSIZEWIDE];
	contentSize.height=[defaults floatForKey:CONTETSIZEHEIGHT];
	[self setContentSize:contentSize];
	CGRect fr=CGRectMake(0, 0, contentSize.width, contentSize.height);
	[self.zoomView setFrame:fr];
	[self setMaxandMinZoomScale];
	
	float calSide=TSIZE*pow(2, self.maplevel);
	CGRect fr1=CGRectMake(0, 0, calSide, calSide);
	[self.zoomView.basicMapLayer setFrame:fr1];
	[self.zoomView.tileContainer setFrame:fr1];
	[gpsTrackPOIBoard.tapDetectView setFrame:fr1];
}

#pragma mark ----------------------------
#pragma mark UIScrollViewDelegate methods
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //NSLog(@"scale:%f",scale);
    NSLOG(@"scrollviewContent:%.f,%.f :%.f x %.f",scrollView.contentOffset.x,scrollView.contentOffset.y,scrollView.contentSize.width,scrollView.contentSize.height);
    NSLOG(@"--------> Zoom fingers let go:maplevel:%d, atScale:%.2f, zoomScale:%.2f",maplevel,scale,[self zoomScale]);
    //all the triks should happen here:
    savedOffset=[self contentOffset];
    float zoomFactor=1.0;
    int deltaRes=0;		//resolution/maplevel change change
    for (int x=maxMapLevel; x>maplevel; x--) {
        int deltaRes1=x-maplevel;
        float scaleAtX=pow(2, deltaRes1);   //scale value at maplevel x
        if ([self zoomScale]>=scaleAtX*zmc) {  //for example, 6 of scale > 4 //modify with a 1.3 coefficient
            deltaRes=deltaRes1;
            break;						  //get out of the loop, we have got new maplevel delta: newMapLevel=maplevel+deltaRes;
        }
    }
    if(deltaRes==0){
        for (int x=minMapLevel; x<=maplevel; x++) {
            int deltaRes2=x-maplevel;
            float scaleAtX=pow(2, deltaRes2);
            if([self zoomScale]<scaleAtX*zmc){      //modify with a 1.3 coefficient
                deltaRes=deltaRes2-1;		//back one level so that all the map scale is greater or equal to 1
                break;
            }
        }
    }
    if(deltaRes==0){
        //calculate the new contentsize
        float calW=pow(2,maplevel)*TSIZE*[self zoomScale];
        CGSize calContentSize=CGSizeMake(calW, calW);
        [self setContentSize:calContentSize];
        
		//even if there is no change in map level for this pinch, refresh is still necessary to fill up
		//the spaces left by an zooming out operation
		//if (DBG) {	NSLog(@"setNeedsDisplay called even no level change !");}
		[self setNeedsLayout];     //this one works !!!
		//[self setNeedsDisplay];  //No use calling this one, added a one above
		return;	// do nothing if 0
	}
    
    lastLevel=maplevel;    
    //maplevel+=deltaRes;		//set new maplevel;//
    int newMapLevel=maplevel+deltaRes;
    if(newMapLevel<2)          //minimum maplevel set to 2
        newMapLevel=2;
	[self setMaplevel:newMapLevel];
    
    //update the maplevel display
    //MainQ * mQ=[MainQ sharedManager];
    //UILabel * lb=(UILabel *)[mQ getTargetRef:MAPRES];
    UILabel * lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).resLabel;
    lb.hidden=(![[Settings sharedSettings] getSetting:SHOW_MAP_LEVEL]);
    [lb setText:[NSString stringWithFormat:@" %d", maplevel]];
    
    [self setMaxandMinZoomScale];   //important, immediately change the zooming range here instead of after setting the new zoomscale
    
    zoomFactor=pow(2, deltaRes * -1);			//zoomfactor =newZoomScale/oldZoomScale; or newZoomScale=oldZoomScale*ZoomFactor;
    
    //save size and orgin before set new zoom scale
    //CGSize  contentSize1   = [self contentSize];
    
    [self setZoomScale:[self zoomScale]*zoomFactor];
    //NSLog(@"contensize:W=%.f, H=%.f  - calculated size=W:%.f zScale=%.2f, zf=%.2f",contentSize1.width,contentSize1.height,pow(2,maplevel)*SIZE*[self zoomScale],[self zoomScale],zoomFactor);
    //after setting new zoomscale, need to restore old size and offset of content view
    
    //calculate the new contentsize
    float calW=pow(2,maplevel)*TSIZE*[self zoomScale];
    CGSize calContentSize=CGSizeMake(calW, calW);
    
    //[self setContentSize:contentSize1];
    [self setContentSize:calContentSize];
    [self setContentOffset:savedOffset];
    
    CGRect fr=CGRectMake(0, 0, calContentSize.width, calContentSize.height);
    [zoomView setFrame:fr];
    
    // layer inside scrollview content's zooming view zoomView  is without zoomScale factor:
    float calSide=TSIZE*pow(2, maplevel);
    
    CGRect fr1=CGRectMake(0, 0, calSide, calSide);
    [zoomView.basicMapLayer setFrame:fr1];
    [zoomView.tileContainer setFrame:fr1];
    
    //TODO: May need to uncomment following 2 lines: done
    [gpsTrackPOIBoard.tapDetectView setFrame:fr1];
    posErr=[self adJustErrForResolution:posErr res:posErrResolution];   //posErr needs to be adjusted with the zoom level changes
    posErrResolution = maplevel;        //need to keep track of the new posErr and posErrorResolution pair updated at the same time    
    
    [self reloadData:zoomFactor];
    [self.gpsTrackPOIBoard setNeedsDisplay];    //force Drawing on ddrawing board
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(restoreOffset) userInfo:nil repeats: NO];//TODO: Restore this line
    //[self setNeedsDisplay];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	//return nil;  //return nil if you do not zooming to occur
    return zoomView;
}
- (bool)getMode{
    return Mode;
}
-(void)refreshTilePositions{
    for (MapTile *tile in [zoomView.tileContainer subviews]) {
        CGRect frame = CGRectMake(256 * tile.col+posErr.x+posErr1.x, 256 * tile.row+posErr.y+posErr1.y, 256, 256);
        [tile setFrame:frame];
    }
    for (MapTile *tile in [zoomView.basicMapLayer subviews]) {
        CGRect frame = CGRectMake(256 * tile.col+posErr.x+posErr1.x, 256 * tile.row+posErr.y+posErr1.y, 256, 256);
        [tile setFrame:frame];
    }
}
-(CGPoint) adJustErrForResolution:(CGPoint)e res:(int) res{
    int diff=maplevel-res;
    float factor=pow(2,diff);
    CGPoint x=CGPointMake(e.x*factor, e.y*factor);
    return x;
}
@end
