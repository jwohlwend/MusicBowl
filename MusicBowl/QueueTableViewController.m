//
//  QueueTableViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/6/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "QueueTableViewController.h"

@interface QueueTableViewController ()

@end

@implementation QueueTableViewController

- (NSMutableArray*) queue{
    return queue;
}
- (void) setQueue: (NSMutableArray*) queueList{
    queue = queueList;
}

- (NSMutableArray*) oldQueue{
    return oldQueue;
}
- (void) setOldQueue: (NSMutableArray*) queueList{
    oldQueue = queueList; 
}
- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self refresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
}
- (IBAction)refreshAction:(id)sender {
    [self refresh];
    [sender endRefreshing];
}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];[self.tableView setEditing:editing animated:animated];
    if (!editing) {
        [self updateQueueOnServer];
    }
    else {
        self.oldQueue = [self.queue copy];
    }
}

- (void) refresh{
    self.queue = [NSMutableArray arrayWithObjects: nil];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.get_tl_tracks"];
    [request start];
    [request synchronize];
    if ([request getError]){
        [request handleError:[request getError] withVC:self];
    }
    if ([request getResponse]){
        self.queue = [[request getResponse] mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.queue count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track" forIndexPath:indexPath];
    NSDictionary* track = [self.queue[indexPath.row] valueForKey:@"track"];
    cell.textLabel.text = [track valueForKey:@"name"];
    cell.detailTextLabel.text = [[track valueForKey:@"artists"] valueForKey:@"name"][0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:@"Remove"
                                                    otherButtonTitles:@"Play now", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = indexPath.row;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        self.oldQueue = [self.queue copy];
        [self.queue removeObjectAtIndex:actionSheet.tag];
        [self updateQueueOnServer];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionSheet.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if(buttonIndex == 1){
        //[self playNow:self.results[actionSheet.tag]];
    }
}

- (void) updateQueueOnServer {

    int length = (int)[self.oldQueue count];
    if (length > 1){
        ServerRequest* request1 = [[ServerRequest alloc] initWithType:@"core.tracklist.remove"];
        NSMutableArray* set = [[NSMutableArray alloc] initWithCapacity:length];
        for (int i = 0; i < length - 1; i++){
            set[i] = [NSNumber numberWithInt:[[self.oldQueue[i+1] valueForKey:@"tlid"] intValue]];
        }
        NSArray* parameters1 = @[@{@"tlid":set}];
        NSLog(@"%@",set);
        [request1 addParameter:@"params" withValue:parameters1];
        [request1 start];
        [request1 synchronize];
        if ([request1 getError]){
            [request1 handleError:[request1 getError] withVC:self];
            return;
        }
        ServerRequest* request2 = [[ServerRequest alloc] initWithType:@"core.tracklist.add"];
        NSRange range2 = NSMakeRange(1, [self.queue count] - 1);
        NSArray* tracksWithID = [self.queue subarrayWithRange:range2];
        NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:[tracksWithID count]];
        for (int i = 0; i < [tracksWithID count]; i++){
            tracks[i] = [tracksWithID[i] valueForKey:@"track"];
        }
        [request2 addParameter:@"params" withValue:@[tracks]];
        [request2 start];
        [request2 synchronize];
        if ([request2 getError]){
            [request2 handleError:[request2 getError] withVC:self];
        }
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0){
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.queue removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSDictionary* temp = self.queue[fromIndexPath.row];
    self.queue[fromIndexPath.row] = self.queue[toIndexPath.row];
    self.queue[toIndexPath.row] = temp;
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
