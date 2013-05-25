//
//  MapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MapScrollView.h"
#import "MapTile.h"

@implementation MapScrollView

@synthesize zoomView;

const int bz=0;        //bezel width, should be set to 0 eventually
const int SIZE=256;     // tile size

float zmc=1;
CGPoint savedOffset;

int firstVisibleRowx[4],firstVisibleColumnx[4],lastVisibleRowx[4], lastVisibleColumnx[4];
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
	}
	//got a tile, assign the col,row ane res to it
	tile1.res=maplevel1;
	tile1.row=row;
	tile1.col=col;
	
    if (!Mode) {   //is the map Eastern hemisphere center or western one center of the map
        NSLog(@"Mode is Eastern:col=%d, width=%.f",col,pow(2,maplevel1));
        int half=pow(2.0, maplevel1)/2;
        if (col>=half) {
            col=col-half;
        }else {
            col+=half;
        }
    }
     NSLog(@"=============>Get Map tile %d, %d on level %d",tile1.row,tile1.col,tile1.res);
    //--------------------call mapsource delegate---------
    if ([self.mapsourceDelegate respondsToSelector:@selector(mapLevel: row: col:)]) {
        UIImage * img=[self.mapsourceDelegate mapLevel:maplevel1 row:row col:col];
        if (nil!=img) {
            [tile1 setImage:img];
            return tile1;
        }
    }
	[tile1 setImage:NULL];  //important, otherwise the old map tile will show up before new one comes in
	return tile1;
}
-(void)fillWindowWithBasicMap:(int)levelDiff tileSize:(int)sz{
    if(levelDiff<0) { NSLog(@"error: levelDiff < 0, exit fillWindowWithBasicMap"); return;}
    NSLog(@"in fillWindowWithBasicMap");
    int i=levelDiff;
	float tileSize=sz*pow(2,levelDiff);
	float scaledTileSide  = tileSize  * [self zoomScale];
    
    int maxRow = floorf(([zoomView frame].size.height) / scaledTileSide);  // this is the maximum possible row
    int maxCol = floorf(([zoomView frame].size.width ) / scaledTileSide);  // and the maximum possible column
	
    CGRect visibleBounds = [self bounds];
    int firstNeededRow = MAX(0, floorf((visibleBounds.origin.y-posErr1.y) / scaledTileSide));
    int firstNeededCol = MAX(0, floorf((visibleBounds.origin.x-posErr1.x) / scaledTileSide));        //<=======
	int lastNeededRow  = MIN(maxRow,floorf((CGRectGetMaxY(visibleBounds)-posErr1.y) / scaledTileSide));
    int lastNeededCol  = MIN(maxCol,floorf((CGRectGetMaxX(visibleBounds)-posErr1.x) / scaledTileSide));    //<=======
	
    if ((firstNeededRow==firstVisibleRowx[i])&&(firstNeededCol==firstVisibleColumnx[i])&&(lastNeededCol==lastVisibleColumnx[i])&&(lastNeededRow==lastVisibleRowx[i])) {
        NSLog(@"exit fillWindowWithBasicMap (2) i=%d, neededRow=%d, visiRow=%d",i,firstNeededRow,firstVisibleRowx[i]);
		return;
	}
    int loadedImageCount=0;
	for (int row = firstNeededRow; row <= lastNeededRow; row++) {
        for (int col = firstNeededCol; col <= lastNeededCol; col++) {
			BOOL tileIsMissing = (firstVisibleRowx[i] > row || firstVisibleColumnx[i] >= col ||lastVisibleRowx[i]  < row || lastVisibleColumnx[i]  < col);
			//NSLog(@"%d>%d ?  %d >%d ? %d - %d ",firstVisibleRowx[i],row,firstVisibleColumnx[i],col,lastVisibleRowx[i],lastVisibleColumnx[i]);
			if (tileIsMissing) {
				if([self alreadyLoaded:row col:col levelDiff:i]){
					NSLog(@"Already loaded image %d,%d on level %d",row,col,(maplevel-levelDiff));
					continue;
				}
				NSLog(@"Load image %d,%d on level %d(%d-%d)",row,col,(maplevel-levelDiff),maplevel,levelDiff);
				MapTile * tile=[self tileForRow:row column:col mapLevel:(maplevel-levelDiff)];   //get the map tile image
				[tile setFrame:CGRectMake(tileSize*col+posErr1.x, tileSize*row+posErr1.y, tileSize,tileSize)];
				if(i>0)
					[zoomView.basicMapLayer addSubview:tile];
				else{
                    //[zoomView.tileContainer annotateTile:tile res:tile.res row:tile.row col:tile.col];
					[zoomView.tileContainer addSubview:tile];
                }
				[zoomView.tileContainer annotateTile:tile res:tile.res row:row col:col];  //add label to tile
				loadedImageCount++;
				if(loadedImageCount>36) return;   // if it is more than 36, it must not be the layer that needs loading
			}else{
                NSLog(@"Tile NOT MISSING on image %d,%d on level %d",row,col,(maplevel-levelDiff));
            }
		}
	}
	firstVisibleRowx[i] = firstNeededRow; firstVisibleColumnx[i] = firstNeededCol;
    lastVisibleRowx[i]  = lastNeededRow;  lastVisibleColumnx[i]  = lastNeededCol;
    NSLog(@"fillWindowWithBasicMap returns");
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
	static int c=0;   //counter
	static int c1=0;  //number of tiles kept
	
    for (MapTile *view in [zoomView.tileContainer subviews]) {
		//keep the last level
		
		//if ((view.res==lastLevel)&&(!menuObj.GPSRunning)) {	//do not unload the last maplevel
		if ((view.res==lastLevel)&&(lastLevel<maplevel)) {	//do not unload the last maplevel
			
			//CGRect scaledTileFrame = [viewFlattener.tileContainer convertRect:[view frame] toView:self];
			//if (CGRectIntersectsRect(scaledTileFrame, visibleBounds)) {  //if in window, keep them
            c1++;
            //adjust tile frame to the new maplevel for those that stay
            CGRect tileR=[view frame];
            CGRect newRect=CGRectMake(tileR.origin.x/zoomFactor, tileR.origin.y/zoomFactor, tileR.size.width/zoomFactor, tileR.size.height/zoomFactor);
            [view setFrame:newRect];
            [zoomView.tileContainer annotateTile:view res:view.res row:view.row col:view.col];  //add label to tile
            continue;
			//}
		}
		
		[reusableTiles addObject:view];
		[view removeFromSuperview];
		[(UIImageView *)view setImage:NULL];
        NSLog(@"One Tile recycled !!!");
		c++;
    }
	
	for (MapTile *view in [zoomView.basicMapLayer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
		[(UIImageView *)view setImage:NULL];
        NSLog(@"Another Tile recycled !!!");
		c++;
    }
	
	//if(DBG) NSLog(@"[reloadData:zoomFactor] %d tiles were put into reuseables while %d tiles in the lastLevel not",c,c1);
	c=0;
	c1=0;
	//count total tiles in memory
	/*
     int count1=[reusableTiles count];
     NSArray *subviews=[viewFlattener.tileContainer subviews];
     int count2=[subviews count];
     NSArray *subviews2=[viewFlattener.basicMapLayer subviews];
     int count3=[subviews2 count];
	 */
	//if(DBG) NSLog(@"[reloadData:zoomFactor]  %d in recycle, %d in main, %d in basic",count1,count2,count3);
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
 	[self initVisibleVarArrays];
	
	//update maplevel display
	//TravelMapAppDelegate * dele=[[UIApplication sharedApplication] delegate];
	//[dele.viewController.resLabel setText:[NSString stringWithFormat:@" %d", maplevel]];
	//[self setNeedsLayout];  //==> this calls layoutSubviews of UIScrollView or its sub class
	[self setNeedsDisplay];
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
		[(UIImageView *)view setImage:NULL];
    }
    for (MapTile *view in [zoomView.basicMapLayer subviews]) {
		[reusableTiles addObject:view];
		[view removeFromSuperview];
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
        int tilesNeeded=ceil(longside/SIZE);
        int level=ceil(sqrt(tilesNeeded));
        int squareSide=pow(2,level)*SIZE;
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
        
        [self initVisibleVarArrays];
        maplevel=level;
		minMapLevel=level;
		maxMapLevel=19;
        reusableTiles = [[NSMutableSet alloc] init];
        Mode=TRUE;
    }
    return self;
}
- (void)layoutSubviews{
    if (self.zooming){
        NSLog(@"self.zooming, exit layoutSubviews:W:%.f, H:%.f",self.contentSize.width,self.contentSize.height);
        return;
    }
    
    NSLog(@"in layoutSubviews");
    NSLog(@"ContentOffset:x:%.f, y:%.f",self.contentOffset.x,self.contentOffset.y);
    NSLog(@"ContentSize:W:%.f, H:%.f\n\n",self.contentSize.width,self.contentSize.height);
    
    int x1=self.contentOffset.x;
    int x2=[self bounds].size.width;
    if ((x1+x2)>=self.contentSize.width) {
        NSLog(@"====================> right edge reached, time to change mode!: %d+%d=%d>%.f",x1,x2,(x1+x2),self.contentSize.width);
        CGPoint offset=[self contentOffset];
        CGSize Size=[self contentSize];
        if (offset.x>Size.width/2) {
            offset.x-=Size.width/2;
            [self setContentOffset:offset];
            [self unLoadAllMapTiles];
            [self setNeedsDisplay];
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
            Mode=!Mode;
            return;
        }
    }
	//if (([self zoomScale]>=2*zmc)||([self zoomScale]<zmc)) {   //key for not overloading too many tiles //modify with a 1.3 coefficient, zmc is either 1 or 1.3
	//	NSLog(@"zoom scale = %.3f, out or valid range, return",[self zoomScale]);
	//	return;
	//}
    //if(((maplevel>5)&&(!bSatMap))||((maplevel>4)&&bSatMap)){
    if(maplevel>4){
		int levelDiff=maplevel-4;
		
		if(levelDiff>3)
			levelDiff=3;
		for(int i=levelDiff;i>0;i--){
			[self fillWindowWithBasicMap:i tileSize:SIZE];
		}
	}
    [self fillWindowWithBasicMap:0 tileSize:SIZE];   //version 5.03 added
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark ----------------------------
#pragma mark UIScrollViewDelegate methods
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    //NSLog(@"scale:%f",scale);
    NSLog(@"scrollviewContent:%.f,%.f :%.f x %.f",scrollView.contentOffset.x,scrollView.contentOffset.y,scrollView.contentSize.width,scrollView.contentSize.height);
    NSLog(@"--------> Zoom fingers let go:maplevel:%d, atScale:%.2f, zoomScale:%.2f",maplevel,scale,[self zoomScale]);
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
        float calW=pow(2,maplevel)*SIZE*[self zoomScale];
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
    maplevel+=deltaRes;		//set new maplevel;
	
    [self setMaxandMinZoomScale];   //important, immediately change the zooming range here instead of after setting the new zoomscale
    
    zoomFactor=pow(2, deltaRes * -1);			//zoomfactor =newZoomScale/oldZoomScale; or newZoomScale=oldZoomScale*ZoomFactor;
    
    //save size and orgin before set new zoom scale
    //CGSize  contentSize1   = [self contentSize];
    
    [self setZoomScale:[self zoomScale]*zoomFactor];
    //NSLog(@"contensize:W=%.f, H=%.f  - calculated size=W:%.f zScale=%.2f, zf=%.2f",contentSize1.width,contentSize1.height,pow(2,maplevel)*SIZE*[self zoomScale],[self zoomScale],zoomFactor);
    //after setting new zoomscale, need to restore old size and offset of content view
    
    //calculate the new contentsize
    float calW=pow(2,maplevel)*SIZE*[self zoomScale];
    CGSize calContentSize=CGSizeMake(calW, calW);
    
    //[self setContentSize:contentSize1];
    [self setContentSize:calContentSize];
    [self setContentOffset:savedOffset];
    
    CGRect fr=CGRectMake(0, 0, calContentSize.width, calContentSize.height);
    [zoomView setFrame:fr];
    
    // layer inside scrollview content's zooming view zoomView  is without zoomScale factor:
    float calSide=SIZE*pow(2, maplevel);
    
    CGRect fr1=CGRectMake(0, 0, calSide, calSide);
    [zoomView.basicMapLayer setFrame:fr1];
    [zoomView.tileContainer setFrame:fr1];
    
    //TODO: May need to uncomment following 2 lines:
    //[zoomView.tapDetectView setFrame:fr1];
    //posErr1=[zoomView.drawLineView.dataObj.parent adJustErrForResolution:posErr res:zoomView.drawLineView.dataObj.parent.posErrResolution];
    
    [self reloadData:zoomFactor];
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(restoreOffset) userInfo:nil repeats: NO];//TODO: Restore this line
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	//return nil;  //return nil if you do not zooming to occur
    return zoomView;
}
@end
