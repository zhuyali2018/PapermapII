//
//  ExpandableMenuViewController.m
//  CollapsableMenu
//
//  Created by Yali Zhu on 7/21/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "ExpandableMenuViewController.h"
#import "MenuNode.h"
#import "AllImports.h"

@implementation ExpandableMenuViewController
@synthesize  trackList;
@synthesize  menuList;
@synthesize  subMenuList;
@synthesize  trackHandlerDelegate;
@synthesize  plusButton;
@synthesize id;         //for identifying menu instance
@synthesize readOnly;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     //self.clearsSelectionOnViewWillAppear = NO;
    //self.tableView.allowsSelection=NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    plusButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAFolder:)];
    if(!readOnly)
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing=TRUE; // this line enables the selection during editing mode
    
    //initialize the menuList with Tracklist passed in
    menuList=[NSMutableArray arrayWithCapacity:11];
    for (int i=0; i<[trackList count]; i++) {
        MenuNode * nd=[trackList objectAtIndex:i];
        nd.emvc=self;
        nd.rootArrayIndex=i;            //important, do not forget to update the rootArrayIndex
        if((nd.folder)&&(nd.open)){     
            nd.open=false;              //initialize with all folders closed
        }
        if (!nd.infolder) {             // all the infolder item not showing up on first load
            [menuList addObject:[trackList objectAtIndex:i]];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"ExpandableMenuViewWillAppear !");
    [self recreateMenuList];
    [self.tableView reloadData];  //now it will update the tracklist as you create them
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }else{
//        //remove all subviews:
//        NSArray * subviews=[cell subviews];
//        for (int i=0; i<[subviews count];i++) {    
//            [subviews[i] removeFromSuperview];
//        }
//    }
    // Configure the cell...
    MenuNode * node=(MenuNode *)menuList[indexPath.row];
    if (node.folder)
        node.dataSource=self;
    [node updateAppearance];
    [cell addSubview:node.mainLabel];
    [cell addSubview:node.subLabel];
    [cell addSubview:node.icon];
    [cell addSubview:node.checkbox];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
// for adding an item
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing) {
        self.navigationItem.leftBarButtonItem = self.plusButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;    //so that the default back button will show
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void) addAFolder:(id)sender{
    MenuNode * nd=[[MenuNode alloc]initWithTitle:@"untitled folder" asFolder:YES];
    nd.dataSource=self;     //important,or the display / hide of track wont work
    nd.emvc=self;           //very important, or children's checkbox wont work with parent
    nd.open=true;           //newly added folder is open
    [trackList addObject:nd];
    nd.rootArrayIndex=(int)[trackList count]-1;      //it is the last one that is added
    [menuList addObject:nd];
    [self.tableView reloadData];
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUInteger row=[indexPath row];
        MenuNode * nodeToBeDeleted=[menuList objectAtIndex:row];
        bool isFolder=nodeToBeDeleted.folder;
        if(isFolder&&nodeToBeDeleted.open) return;  //can not delete open folder
        NSUInteger trackListRow=nodeToBeDeleted.rootArrayIndex;
        [trackList removeObjectAtIndex:trackListRow];
        [menuList removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (isFolder) {     //if it is a folder, delete all its children
            for (int i =(int)trackListRow; i<[trackList count];) {
                if(((MenuNode *)[trackList objectAtIndex:i]).infolder)
                    [trackList removeObjectAtIndex:i];
                else
                    break;
            }
        }
        [self recreateMenuList];   //some rootArrayIndexes will change, so, recreate the menulist for safety and avoid invalid references
        [self displayArrays];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //MenuNode * nd=[[MenuNode alloc]initWithTitle:@"folder name"];
        
    }   
}
-(void)moveFolder:(MenuNode *)object From:(int)fromRow To:(int)toRow{
    if (object.open) {
        return;     //do not move open folder
    }
    if (fromRow>toRow) {
        int fromIdx=object.rootArrayIndex;
        MenuNode * objAtTrackList=[trackList objectAtIndex:fromIdx];
        [menuList removeObjectAtIndex:fromRow];
        [trackList removeObjectAtIndex:fromIdx];
        MenuNode * toObject = [menuList objectAtIndex:toRow];
        int toIdx=toObject.rootArrayIndex;
        [trackList insertObject:objAtTrackList atIndex:toIdx];
        //move its children if any
        for(int i=fromIdx+1;i<[trackList count];i++){
            MenuNode * tmp=[trackList objectAtIndex:i];
            if (!tmp.infolder) {
                break;
            }
            [trackList removeObjectAtIndex:i];
            [trackList insertObject:tmp atIndex:toIdx+i-fromIdx];
        }
    }else{  //if toRow>=fromRow
        int fromIdx=object.rootArrayIndex;
        [menuList removeObjectAtIndex:fromRow];   //important, affect the following line
        int toIdx;
        if (toRow>=[menuList count]) {
            toIdx=(int)trackList.count;
            [trackList insertObject:object atIndex:toIdx];
        }else{
            MenuNode * toObject = [menuList objectAtIndex:toRow];
            toIdx=toObject.rootArrayIndex;
            [trackList insertObject:object atIndex:toIdx];
        }
        [trackList removeObjectAtIndex:fromIdx];

        //move its children if any
        for(int i=fromIdx;i<[trackList count];i++){
            MenuNode * tmp=[trackList objectAtIndex:i];
            if (!tmp.infolder) {
                break;
            }
            [trackList insertObject:tmp atIndex:toIdx+i-fromIdx];
            [trackList removeObjectAtIndex:i];
        }
    }
    //=====================
    [self recreateMenuList];
    [self.tableView reloadData];  //no animation is needed here
    [self displayArrays];
}

// following 2 method support moving record around
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromRow=[fromIndexPath row];  
	NSUInteger toRow=[toIndexPath row];
    if (fromRow==toRow) {  
        if (fromRow==(menuList.count-1)) {  //do nothing
            return;
        }
    }
	MenuNode * object = [menuList objectAtIndex:fromRow];
    //insert this folder condition
    if(object.folder){
        [self moveFolder:object From:(int)fromRow To:(int)toRow];
        return;
    }
    int fromIdx=object.rootArrayIndex;
    MenuNode * object1=[trackList objectAtIndex:fromIdx];
        
	[menuList removeObjectAtIndex:fromRow];  //[trackList removeObjectAtIndex:fromIdx];     //remove the object from both arrays
    MenuNode * toObject;
    bool insertAfter=false;
    if (toRow==[menuList count]) {
        toObject = [menuList objectAtIndex:menuList.count-1];
        insertAfter=true;
    }else
        toObject = [menuList objectAtIndex:toRow];
    int toIdx=toObject.rootArrayIndex;
    
    //if toRow is not 0, copy the infolder value of the one before the move_to position
    if (toRow>0) {
        MenuNode * preNode=[menuList objectAtIndex:toRow-1];
        MenuNode * preNode1=[trackList objectAtIndex:toIdx-1];
        
        
        if (preNode.folder) {
            if(preNode.open){
                if(!object.folder){     //TODO: make sure preNode1 here is a folder too or throw an exception
                    object.infolder=TRUE;
                    object1.infolder=TRUE;  //TODO: make sure here the object and object1 are representing the same menuNode or throw an exception
                }//else here do nothing
            }else{//got to do sth here: preNode is a closed folder, change the infolder to false here! (else here do nothing)
                object.infolder=FALSE;
                object1.infolder=FALSE;
            }
        }else{
            object.infolder=preNode.infolder;
            object1.infolder=preNode1.infolder;
        }
    }else{
        ((MenuNode *)object).infolder=false;   //if the one becomes the first one, it got to be in the root folder !
        ((MenuNode *)object1).infolder=false;
    }
    
    ((MenuNode *)object).rootArrayIndex=toIdx;      //updating the moving object's root array index reference
    
	[menuList insertObject:object atIndex:toRow];
    if (insertAfter) {
        [trackList insertObject:object1 atIndex:toIdx+1];
    }else
        [trackList insertObject:object1 atIndex:toIdx];   //insert the object to both arrays
    
    if (toIdx>fromIdx) {        //then, insertion above wont affect the remove below
        [trackList removeObjectAtIndex:fromIdx]; 
    }else{
        [trackList removeObjectAtIndex:fromIdx+1];
    }     //remove last in order to keep sync with rootArrayIndex
    [self recreateMenuList];
    [self.tableView reloadData];  //no animation is needed here
    [self displayArrays];
}
-(void)recreateMenuList{
    menuList=[NSMutableArray arrayWithCapacity:11];
    bool underOpenFolder=false;
    for (int i=0; i<[trackList count]; i++) {
        MenuNode * nd=[trackList objectAtIndex:i];
        nd.rootArrayIndex=i;            //important, do not forget to update the rootArrayIndex
        if (nd.folder&&nd.open) {
            underOpenFolder=true;
            [menuList addObject:nd];
            continue;
        }else if(nd.folder&&!nd.open){
            underOpenFolder=false;
            [menuList addObject:nd];
            continue;
        }
        //if not a folder
        if (underOpenFolder) {
            [menuList addObject:nd];
            if (!nd.infolder) {
                underOpenFolder=false;
            }
        }else{
            if (!nd.infolder) {
                [menuList addObject:nd];
            }
        }
    }
}
-(void)updateIndexRefBetween:(NSUInteger)fromRow and:(NSUInteger) toRow{
    int n=1;
    if(toRow > fromRow){
        n=-1;
    }
    for (int i=(int)toRow+1; i<=fromRow; i+=n) {  //should be <= to be correct
        ((MenuNode *)[menuList objectAtIndex:i]).rootArrayIndex+=n;
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    MenuNode * mn=[menuList objectAtIndex:indexPath.row];
    //return !mn.folder;   //if this is a folder, make it non-movable because its children need to be moved too if it is movable
    if (!mn.folder) {
        return YES;
    }
    return !mn.open;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    MenuNode * node=(MenuNode *)menuList[indexPath.row];
    int trackListRow = node.rootArrayIndex;
    if(node.folder){
        if (self.editing) {
            return;     //no operation when in editing
        }
        [self updateSubmenuList:trackListRow];
        if (node.open) {
            [self deleteArrayAtIndex:(int)indexPath.row];
        }else{
            [self insertArrayAtIndex:(int)indexPath.row];
        }
        node.open=!node.open;
        [node updateAppearance];
    }else{  //if it is not folder
        if ([trackHandlerDelegate respondsToSelector:@selector(tappedOnIndexPath:ID:)]){
            [trackHandlerDelegate tappedOnIndexPath:trackListRow ID:id];
        }
    }
    [self displayArrays];
}
-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    MenuNode * mn=[menuList objectAtIndex:indexPath.row];
    if (mn.folder) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }else if(self.id==SETTING)
        return UITableViewCellAccessoryNone;
	return UITableViewCellAccessoryDisclosureIndicator;
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"you taped on number %ld (%@)",(long)indexPath.row,((MenuNode *)[menuList objectAtIndex:indexPath.row]).mainText);
    MenuNode * node=(MenuNode *)menuList[indexPath.row];
    int trackListRow = node.rootArrayIndex;
    if ([trackHandlerDelegate respondsToSelector:@selector(tappedOnIndexPath:ID:)])
        [trackHandlerDelegate tappedOnIndexPath:trackListRow ID:id] ;
}
-(void)updateSubmenuList:(int)row{
    NSMutableArray * subMenuList1=[NSMutableArray arrayWithCapacity:10];
    for (int i=row+1; i<[trackList count];i++) {
        MenuNode * nd=[trackList objectAtIndex:i];
        if (!nd.infolder) {
            break;
        }
        nd.rootArrayIndex=i;        //keep track of its position in original array
        [subMenuList1 addObject:nd];
    }
    subMenuList=[NSArray arrayWithArray:subMenuList1];
}
-(void) insertArrayAtIndex:(int) row{
    [self.tableView beginUpdates];
    int count=(int)[subMenuList count];
    NSMutableArray * idx=[NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++) {
        [menuList insertObject:[subMenuList objectAtIndex:i] atIndex:row+i+1];
        [idx addObject:[NSIndexPath indexPathForRow:row+i+1 inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:idx withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
}
-(void) deleteArrayAtIndex:(int) row{
    [self.tableView beginUpdates];
    int count=(int)[subMenuList count];      //for testing, count needs to be passed in
    NSMutableArray * idx=[NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++) {
        [menuList removeObjectAtIndex:row+1];
        [idx addObject:[NSIndexPath indexPathForRow:row+i+1 inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:idx withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}
-(void) displayArrays{
    for (int i=0; i<[trackList count]; i++) {
        if (i<[menuList count]) {
            NSLog(@" menuList[%2d]: %@ %d-%d-%d-%d->%2d      trackList[%2d]: %@ %d-%d-%d-%d->%2d",
                  i,((MenuNode *)menuList[i]).mainText,((MenuNode *)menuList[i]).folder,((MenuNode *)menuList[i]).open,
                  ((MenuNode *)menuList[i]).selected,((MenuNode *)menuList[i]).infolder,((MenuNode *)menuList[i]).rootArrayIndex,
                  i,((MenuNode *)trackList[i]).mainText,((MenuNode *)trackList[i]).folder,((MenuNode *)trackList[i]).open,
                  ((MenuNode *)trackList[i]).selected,((MenuNode *)trackList[i]).infolder,((MenuNode *)trackList[i]).rootArrayIndex
                  );
        }else
            NSLog(@"      --       trackList[%2d]: %@ %d-%d-%d-%d->%2d",i,((MenuNode *)trackList[i]).mainText,((MenuNode *)trackList[i]).folder,((MenuNode *)trackList[i]).open,((MenuNode *)trackList[i]).selected,((MenuNode *)trackList[i]).infolder,((MenuNode *)trackList[i]).rootArrayIndex);
    }
    NSLog(@"---------------------------");
}
-(void)onCheckBox{
    NSLog(@"---------OnMenu's onCheckBox-----------------");
    if ([trackHandlerDelegate respondsToSelector:@selector(onFolderCheckBox)]){
        [trackHandlerDelegate onFolderCheckBox];
    }
}
@end
