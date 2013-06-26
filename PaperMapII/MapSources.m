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
@implementation MapSources

+ (id)sharedManager {
    static MapSources *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
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
    //load built in map for fast loading
	NSString * imgname;
	if((tile1.res<6)&&(mapType==googleMap)){  // if less than 3, do it from builtin map tile
    //if(mapLevel<6){  // if less than 3, do it from builtin map tile
		// The resolution is stored as a power of 2, so -1 means 50%, -2 means 25%, and 0 means 100%.
		imgname=[[NSString alloc]initWithFormat:@"Map%d_%d_%d.jpg", tile1.res, tile1.row, tile1.modeCol];
        UIImage * img=[UIImage imageNamed:imgname];
        imgname=nil;
        [tile1 setImage:img];
		return;
	}else if((tile1.res<5)&&(mapType==googleSat)){
        imgname=[[NSString alloc]initWithFormat:@"Sat%d_%d_%d.jpg", tile1.res, tile1.row, tile1.modeCol];
        UIImage *img=[UIImage imageNamed:imgname];
        imgname=nil;
		[tile1 setImage:img];
		return;
    }
    
    NSString *  rootDir;
    if(mapType==googleSat)
        rootDir=@"Sat";
    else if(mapType==googleMap)
        rootDir=@"Map";
    NSString * imgFn=[[NSString alloc] initWithFormat:@"%@%d_%d_%d.jpg",rootDir,tile1.res,tile1.row,tile1.modeCol];
    NSString * dirName=[self getPathName:tile1.res row:tile1.row col:tile1.modeCol];
    NSString * absPath=[self dataFilePath:dirName];
    NSString * pathFn=[[NSString alloc] initWithFormat:@"%@/%@",absPath,imgFn];   //getPath and filename together;
    
    UIImage * img;
    //TODO: Move following vars to as a property of the map source.
    BOOL bInternetOnly=FALSE;
    BOOL bCachedMapOnly=FALSE;
    
    if (bInternetOnly) {
        img=nil;
    }else {
        img=[UIImage imageWithContentsOfFile:pathFn];  //tring to get image from local
    }
    if(img){    //if got from local, good!
        [tile1 setImage:img];
		return;
    }
    
    if ((!img)&&(!bCachedMapOnly)) {
        //Get maptile from internet -------
        //load the map tile in another thread to increase performance
        [self performSelectorInBackground:@selector(loadImageInBackground:) withObject:tile1];
        //[self loadImageInBackground:tile1];
    }else
        [tile1 setImage:NULL];
    return;
}
-(void)loadImageInBackground:(MapTile *)tile1{
    int satVersion=130;  //TODO: Replaced this hardcoded 113 with some code !!!
    int x=tile1.col; //save here and check at the buttom
    int y=tile1.row;
    int r=tile1.res;
    int c=tile1.modeCol;
    NSString * country=@"en";
    
    NSString * mapUrlFomat;
    static int svr=0;	svr++;	if (svr>2) svr=0;
    NSString * imageUrl;
    if(mapType==googleSat){
        //mapUrlFomat=[[NSString alloc]initWithString:@"http://khm%d.google.com/kh/v=76&x=%d&y=%d&z=%d"];
        mapUrlFomat=@"http://khm%d.google.com/kh/v=%d&x=%d&y=%d&z=%d";    //version 4.0 4-29-2011
        imageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,satVersion,tile1.modeCol, tile1.row, tile1.res];	   //version 5.0
    }else if(mapType==googleMap){
            mapUrlFomat=@"http://mt%d.google.com/vt/v=w2.101&hl=%@&x=%d&y=%d&z=%d";
            imageUrl=[[NSString alloc]initWithFormat:mapUrlFomat, svr,country,tile1.modeCol, tile1.row, tile1.res];
    }
    NSData * imageData;
    if (tile1.row==-1) {  //no need to do it to save time
        NSLOG10(@"No need to load image %d,%d at %d any more",tile1.row,tile1.modeCol,tile1.res);
        return;
    }
    //NSLOG10(@"imageURL=%@",imageUrl);
    imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];  //goto internet to get the maptile
    UIImage * img;
    img=[UIImage imageWithData:imageData];
    //Save images got from internet into buffer
    if (imageData) {
        
        NSString *  rootDir;
        if(mapType==googleSat)
            rootDir=@"Sat";
        else if(mapType==googleMap)
            rootDir=@"Map";
        
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
                [tile1 setImage:img];
            }
        }
    }else
        [tile1 setImage:NULL];

}
- (void)setMapSourceType:(MapType)mapType1{
    mapType=mapType1;
}
@end
