//
//  MapSources.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "MapSources.h"
#import "MapTile.h"
#import "Settings.h"

@implementation MapSources

@synthesize myLock;
@synthesize mapType;
@synthesize mapInChinese,useMSNMap;

+ (MapSources *)sharedManager {
    static MapSources *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.myLock=[[NSLock alloc] init];
    });
    return sharedMyManager;
}

-(NSString *)getPathName:(int)res row:(int)row col:(int)col{
	switch (res) {
		case 3:
		case 4:
			return @"Map4";
			break;
		case 5:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%02d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%02d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map5/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0]];
			return path;
			break;
		}
		case 6:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%02d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%02d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map6/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0]];
			return path;
			break;
		}
		case 7:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%03d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%03d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map7/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1]];
			return path;
			break;
		}
		case 8:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%03d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%03d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map8/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1]];
			return path;
			break;
		}
		case 9:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%04d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%04d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map9/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2]];
			return path;
			break;
		}
		case 10:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%04d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%04d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map10/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2]];
			return path;
			break;
		}
		case 11:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%04d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%04d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map11/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2]];
			return path;
			break;
		}
		case 12:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%04d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%04d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map12/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],[strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2]];
			return path;
			break;
		}
		case 13:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%05d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%05d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map13/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3]];
			return path;
			break;
		}
		case 14:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%05d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%05d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map14/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3]];
			return path;
			break;
		}case 15:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%05d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%05d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map15/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3]];
			return path;
			break;
		}case 16:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%06d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%06d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map16/%c%c/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3],[strRow characterAtIndex:4],[strCol characterAtIndex:4]];
			return path;
			break;
		}case 17:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%06d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%06d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map17/%c%c/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3],[strRow characterAtIndex:4],[strCol characterAtIndex:4]];
			return path;
			break;
		}case 18:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%06d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%06d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map18/%c%c/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3],[strRow characterAtIndex:4],[strCol characterAtIndex:4]];
			return path;
			break;
		}case 19:{
			NSString * strRow=[[NSString alloc]initWithFormat:@"%07d",row];
			NSString * strCol=[[NSString alloc]initWithFormat:@"%07d",col];
			NSString * path=[[NSString alloc]initWithFormat:@"Map19/%c%c/%c%c/%c%c/%c%c/%c%c/%c%c",[strRow characterAtIndex:0],[strCol characterAtIndex:0],
							 [strRow characterAtIndex:1],[strCol characterAtIndex:1],[strRow characterAtIndex:2],[strCol characterAtIndex:2],
							 [strRow characterAtIndex:3],[strCol characterAtIndex:3],[strRow characterAtIndex:4],[strCol characterAtIndex:4],[strRow characterAtIndex:5],[strCol characterAtIndex:5]];
			return path;
			break;
		}
		default:
			break;
	}
	return nil;
}
-(NSString *)dataFilePath:(NSString *)localPath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:localPath];
}
#pragma mark Map Source Delegate method
- (void)mapTile:(MapTile *)tile1{
    tile1.mType=mapType;   //20180128
    //load built in map for fast loading
	NSString * imgname;
	if((tile1.res<6)&&(tile1.mType==googleMap)){  // if less than 3, do it from builtin map tile
    //if(mapLevel<6){  // if less than 3, do it from builtin map tile
		// The resolution is stored as a power of 2, so -1 means 50%, -2 means 25%, and 0 means 100%.
		imgname=[[NSString alloc]initWithFormat:@"Map%d_%d_%d.jpg", tile1.res, tile1.row, tile1.modeCol];
        UIImage * img=[UIImage imageNamed:imgname];
        imgname=nil;
        [myLock lock];  //20180128
        if(tile1.mType==mapType)  //20180128     if the maptile's maptype is still the same as current map type, load the image onto tile
            [tile1 setImage:img];
        else
            [tile1 setImage:NULL]; //20180128
        [myLock unlock];  //20180128

		return;
	}else if((tile1.res<5)&&(tile1.mType==googleSat)){
        imgname=[[NSString alloc]initWithFormat:@"Sat%d_%d_%d.jpg", tile1.res, tile1.row, tile1.modeCol];
        UIImage *img=[UIImage imageNamed:imgname];
        imgname=nil;
        [myLock lock];  //20180128
        if(tile1.mType==mapType)  //20180128     if the maptile's maptype is still the same as current map type, load the image onto tile
            [tile1 setImage:img];
        else
            [tile1 setImage:NULL]; //20180128
        [myLock unlock];  //20180128

		return;
    }
    
    NSString *  rootDir;
    if (useMSNMap) {
        if(tile1.mType==googleSat)
            rootDir=@"MSNSat";
        else if(tile1.mType==googleMap)
            rootDir=@"MSNMap";
    }else{
        if(tile1.mType==googleSat)
            rootDir=@"Sat";
        else if(tile1.mType==googleMap)
            rootDir=@"Map";
    }
    
    NSString * imgFn=[[NSString alloc] initWithFormat:@"%@%d_%d_%d.jpg",rootDir,tile1.res,tile1.row,tile1.modeCol];
    NSString * dirName=[self getPathName:tile1.res row:tile1.row col:tile1.modeCol];
    NSString * absPath=[self dataFilePath:dirName];
    NSString * pathFn=[[NSString alloc] initWithFormat:@"%@/%@",absPath,imgFn];   //getPath and filename together;
    
    UIImage * img;
    //TODO: Move following vars to as a property of the map source.
    //BOOL bInternetOnly=FALSE;
    //BOOL bCachedMapOnly=FALSE;
    BOOL bInternetOnly=[[Settings sharedSettings] getSetting:INTERNET_MAP_ONLY];
    BOOL bCachedMapOnly=[[Settings sharedSettings] getSetting:CACHED_MAP_ONLY];
    
    if (bInternetOnly) {
        img=nil;
    }else {
        img=[UIImage imageWithContentsOfFile:pathFn];  //tring to get image from local
    }
    if(img){    //if got from local, good!
        [myLock lock];  //20180128
        if(tile1.mType==mapType)  //20180128     if the maptile's maptype is still the same as current map type, load the image onto tile
            [tile1 setImage:img];
        else
            [tile1 setImage:NULL]; //20180128
        [myLock unlock];  //20180128
		return;
    }
    
    if ((!img)&&(!bCachedMapOnly)) {
        //Get maptile from internet -------
        //load the map tile in another thread to increase performance
        [self performSelectorInBackground:@selector(loadImageInBackground:) withObject:tile1];
        //[self loadImageInBackground:tile1];    //NoThread for debugging
    }else
        [tile1 setImage:NULL];
    return;
}
-(int)GetQFromX:(int)x Y:(int)y R:(int)r{
    double base=2;
    int w=pow(base,r);
    //boundary check
    if(x>w||x<0||y>w||y<0)
        return -1;
    //figure out which quadrant
    int q=0;
    if(x<w/2){
        if(y<w/2){
            q=0;
        }else{
            q=2;
        }
    }else{
        if(y<w/2){
            q=1;
        }else{
            q=3;
        }
    }
    return q;
}
-(NSString *)GetTileNumberStringFromX:(int)x Y:(int)y R:(int)r{
    char * out=(char*)malloc(r + 1);
    char * p=out;
    for (int i=r; i>0; i--) {
        int q=[self GetQFromX:x Y:y R:i];
        *p=q+0x30; p++;
        int nw=pow(2.0, i);
        switch (q) {
            case 0:
                break;
            case 1:
                x=x-nw/2;
                break;
            case 2:
                y=y-nw/2;
                break;
            case 3:
                x=x-nw/2;
                y=y-nw/2;
                break;
            default:
                break;
        }
    }
    *p=0;
    NSString * numString=[NSString stringWithUTF8String:out];
    free(out);
    return numString;
}
extern NSString * satVersion;  //version 5.0
-(void)loadImageInBackground:(MapTile *)tile1{
    int iSatVersion=[satVersion intValue];  //version 5.0;  //TODO: Replaced this hardcoded 113 with some code !!!
    int x=tile1.col; //save here and check at the buttom
    int y=tile1.row;
    int r=tile1.res;
    int c=tile1.modeCol;
    NSString * imageUrl;
    NSString * satImageUrl;
    
    NSString * country=@"en";       //<===============
    if (mapInChinese) {
        country=@"zh-CN";
    }
    tile1.mType=mapType;    //20180128
    if (useMSNMap) {                //<===============  Use MSN map or Google Map
        NSString * mapUrlFomat;
        static int svr=0;	svr++;	if (svr>7) svr=0;
        NSString * mapTileNumStr = [self GetTileNumberStringFromX:c Y:y R:r];
        if(tile1.mType==googleSat){  //20180128
            mapUrlFomat=@"http://ecn.t%d.tiles.virtualearth.net/tiles/a%@.png?g=854";
            imageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,mapTileNumStr];
        }else if(tile1.mType==googleMap){ //20180128
            mapUrlFomat=@"http://ecn.t%d.tiles.virtualearth.net/tiles/r%@.png?g=854&mkt=%@";
            imageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,mapTileNumStr,country];
        }
    }else{
        NSString * mapUrlFomat;
        static int svr=0;	svr++;	if (svr>2) svr=0;
        if(tile1.mType==googleSat){  //20180128
            mapUrlFomat=@"http://khm%d.google.com/kh/v=%%d&x=%d&y=%d&z=%d";    //version 4.0 4-29-2011
            satImageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,tile1.modeCol, tile1.row, tile1.res];	   //version 5.0
        }else if(tile1.mType==googleMap){  //20180128
            mapUrlFomat=@"http://mt%d.google.com/vt/v=w2.101&hl=%@&x=%d&y=%d&z=%d";
            imageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,country,tile1.modeCol, tile1.row, tile1.res];
        }
    }
    NSData * imageData = nil;
    if (tile1.row==-1) {  //no need to do it to save time
        //[[MapSources sharedManager] unlock];    //20180128
        NSLOG10(@"No need to load image %d,%d at %d any more",tile1.row,tile1.modeCol,tile1.res);
        return;
    }
    //NSLOG10(@"imageURL=%@",imageUrl);
    if(tile1.mType==googleSat){  //auto detect sat version  //20180128
        int tryTimes=0;
        int newSatVersion = iSatVersion;
        while (!imageData && tryTimes<50) { //try max 50 times
            imageUrl=[[NSString alloc]initWithFormat:satImageUrl, newSatVersion];
            imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];  //goto internet to get the maptile
            if(!imageData){
                tryTimes++;
                newSatVersion=iSatVersion+tryTimes;
            }
        }
        if(tryTimes > 0 && imageData){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * storedSatVersion=[defaults stringForKey:@"SatMapVersion"];   //version 5.0
            int iStoredSatVersion=[storedSatVersion intValue];
            if(newSatVersion > iStoredSatVersion ){
                NSString * sNewSatVersion=[@(newSatVersion) stringValue];
                [defaults setObject:sNewSatVersion forKey:@"SatMapVersion"];
            }else{
                satVersion=storedSatVersion;   //if stored version is greater, use it (this is possible when auto detect newest version is implemented)
            }
        }
    }else{
        imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];  //goto internet to get the maptile
    }
    UIImage * img;
    img=[UIImage imageWithData:imageData];
    //Save images got from internet into buffer
    if (imageData) {
        
        NSString *  rootDir;
        if (useMSNMap) {
            if(tile1.mType==googleSat) //20180128
                rootDir=@"MSNSat";
            else if(tile1.mType==googleMap)  //20180128
                rootDir=@"MSNMap";
        }else{
            if(tile1.mType==googleSat)  //20180128
                rootDir=@"Sat";
            else if(tile1.mType==googleMap)  //20180128
                rootDir=@"Map";
        }
        //NSString * imgFn=[[NSString alloc] initWithFormat:@"%@%d_%d_%d.jpg",rootDir,tile1.res,tile1.row,tile1.modeCol];
        NSString * imgFn=[[NSString alloc] initWithFormat:@"%@%d_%d_%d.jpg",rootDir,r,y,c];
        //NSString * dirName=[self getPathName:tile1.res row:tile1.row col:tile1.modeCol];
        NSString * dirName=[self getPathName:r row:y col:c];
        NSString * absPath=[self dataFilePath:dirName];
        NSString * pathFn=[[NSString alloc] initWithFormat:@"%@/%@",absPath,imgFn];   //getPath and filename together;
        if([[NSFileManager defaultManager] createDirectoryAtPath:absPath withIntermediateDirectories:YES attributes:nil error:NULL]){
            [imageData writeToFile:pathFn atomically:YES]; //save to cache
        }else {
            NSLOG(@"[loadImageInBackground] Directory creation failed:%@",pathFn);
        }
        
    }
    if(img){
        //if(tile1.row!=-1){
            
        @synchronized(tile1) {
            if ((x!=tile1.col)||(y!=tile1.row)||(r!=tile1.res)||(c!=tile1.modeCol)) {
                NSLOG10(@"We got a problem: x=%d, col=%d, y=%d, row=%d, r=%d, res=%d",x,tile1.col,y,tile1.row,r,tile1.res);
                //the tile requesting this image has been recycled and does not need the image anymore!
            }else{
                [myLock lock];  //20180128
                if(tile1.mType==mapType)  //20180128     if the maptile's maptype is still the same as current map type, load the image onto tile
                    [tile1 setImage:img];
                else
                    [tile1 setImage:NULL]; //20180128
                [myLock unlock];  //20180128
            }
        }
    }else
        [tile1 setImage:NULL];
    
}
//20180128
- (bool)setMapSourceType:(MapType)mapType1{
    [myLock lock];
    mapType=mapType1;
    [myLock unlock];
    return true;
}
- (MapType)getMapSourceType{
    return mapType;
}
@end
