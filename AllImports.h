//
//  AllImports.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/4/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#ifndef PaperMapII_AllImports_h
#define PaperMapII_AllImports_h

const static int TSIZE=256;     // tile size

typedef enum  {GPSLIST,DRAWLIST,POILIST,GOTOPOI} ListType;  //GPSTrack List or Drawing List table

const static bool showLog=false;
#define NSLOG(fmt, ...) if(showLog) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog1=true;   //redrawn
#define NSLOG1(fmt, ...) if(showLog1) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog2=false;   //touch handler log
#define NSLOG2(fmt, ...) if(showLog2) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog3=false;   //New Log
#define NSLOG3(fmt, ...) if(showLog3) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog4=false;   //New Log
#define NSLOG4(fmt, ...) if(showLog4) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog5=false;   //track the node added
#define NSLOG5(fmt, ...) if(showLog5) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog6=false;   //Application Delegate methods calling log
#define NSLOG6(fmt, ...) if(showLog6) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog7=false;   //Tile Debug
#define NSLOG7(fmt, ...) if(showLog7) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog8=false;   //Tile Debug
#define NSLOG8(fmt, ...) if(showLog8) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog9=false;   //Tile Debug
#define NSLOG9(fmt, ...) if(showLog9) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog10=true;   //Tile Debug
#define NSLOG10(fmt, ...) if(showLog10) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

#endif