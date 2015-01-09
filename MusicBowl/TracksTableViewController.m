//
//  TracksTableViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "TracksTableViewController.h"
#import "RootViewController.h"

@interface TracksTableViewController ()

@end

@implementation TracksTableViewController

- (NSString*) song{
    return song;
}
- (NSString*) artist{
    return artist;
}
- (NSArray*) results{
    return results;
}
- (NSArray*) sources{
    return sources;
}
- (HMSegmentedControl*) segmentedControl{
    return segmentedControl;
}
- (void) setSegmentedControl: (HMSegmentedControl*) theSegment{
    segmentedControl = theSegment;
}
- (void) setSources: (NSArray*) theSources{
    sources = theSources;
}
- (void) setSong: (NSString*)songName{
    song = songName;
}
- (void) setArtist: (NSString*)artistName{
    artist = artistName;
}
- (void) setResults: (NSArray*)resultList{
    results = resultList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.results = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.sources = @[@"soundcloud",@"spotify",@"youtube"];;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Souncloud", @"Spotify", @"Youtube"]];
    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.backgroundColor = [UIColor clearColor];    segmentedControl.textColor = [UIColor whiteColor];
    segmentedControl.selectedTextColor = [UIColor whiteColor];
    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectedSegmentIndex = HMSegmentedControlSegmentWidthStyleDynamic;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    segmentedControl.shouldAnimateUserSelection = YES;
    segmentedControl.frame = CGRectMake(15.0, 100.0, self.view.frame.size.width- 30.0, 40);
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(15.0, segmentedControl.frame.origin.y - 1.0, self.view.frame.size.width - 30.0, 1.0)];
    topBorder.backgroundColor = [UIColor whiteColor];
    UIView *lowBorder = [[UIView alloc] initWithFrame:CGRectMake(15.0, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 1, self.view.frame.size.width - 30.0, 1.0)];
    lowBorder.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBorder];
    [self.view addSubview:lowBorder];
    
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    CGPoint origin = CGPointMake(0.0, lowBorder.frame.origin.y + 1.0);
    _tableView.frame = CGRectMake(origin.x, origin.y, self.view.frame.size.width - 15.0, self.view.frame.size.height - origin.y - 40.0);
    _tableView.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    self.results = [self findTracks:self.song fromArtist:self.artist fromSource:self.sources[1]];
    [self.tableView reloadData];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated{
    segmentedControl.selectedSegmentIndex = 1;
    self.results = [self findTracks:self.song fromArtist:self.artist fromSource:self.sources[1]];
    [self.tableView reloadData];
}

- (void) segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl{
    self.results = [self findTracks:self.song fromArtist:self.artist fromSource:self.sources[segmentedControl.selectedSegmentIndex]];
    [self.tableView reloadData];
}

- (void) play: (NSDictionary*) track{
    [self playNext:track];
        ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.playback.stop"];
        NSArray* parameters = @[[NSNumber numberWithBool:YES]];
        [request addParameter:@"params" withValue:parameters];
        [request start];
        [request synchronize];
        if ([request getError]){
            [request handleError:[request getError] withVC:self];
            return;
        }
    ServerRequest* request2 = [[ServerRequest alloc] initWithType:@"core.playback.play"];
    [request2 start];
    [request2 synchronize];
    if ([request2 getError]){
        [request2 handleError:[request2 getError] withVC:self];

        return;
    }
}

- (void) playNext: (NSDictionary*) track{
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.add"];
    NSArray* parameters = @[@[track]];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [request handleError:[request getError] withVC:self];
        return;
    }
}

- (void) addToQueue: (NSDictionary*) track{
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.add"];
    NSArray* parameters = @[@[track]];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [request handleError:[request getError] withVC:self];
    }
}

- (NSArray*) findTracks:(NSString *)songName fromArtist:(NSString*) artistName fromSource:(NSString*) source{
    NSArray* trackList = @[];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.library.search"];
    NSMutableDictionary* searchQuery = [[NSMutableDictionary alloc] init];
    if (![songName isEqualToString:@""]){
        [searchQuery setValue:songName forKey:@"any"];
    }
    if (![artistName isEqualToString:@""]){
        [searchQuery setValue:artistName forKey:@"artist"];
    }
    NSArray* parameters = [NSArray arrayWithObjects:searchQuery, @[[source stringByAppendingString:@":"]],nil];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [request handleError:[request getError] withVC:self];
    }
    else{
        trackList = (NSArray*)[[request getResponse] valueForKey:@"tracks"];
        if ([trackList count] > 0){
            trackList = trackList[0];
            NSLog(@"%@", trackList);
        }
    }
    return trackList;
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
    return [self.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackResult" forIndexPath:indexPath];
    NSDictionary* track = (NSDictionary*)self.results[indexPath.row];
    cell.textLabel.text = [track valueForKey:@"name"];
    cell.detailTextLabel.text = [[track valueForKey:@"artists"] valueForKey:@"name"][0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:@"Play"
        otherButtonTitles:@"Play next", @"Add to queue", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = indexPath.row;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSLog(@"Play Button Clicked");
        [self play:self.results[actionSheet.tag]];
    }
    else if(buttonIndex == 1){
        NSLog(@"Play next Button Clicked");
        [self playNext:self.results[actionSheet.tag]];
    }
    else if(buttonIndex == 2){
        NSLog(@"Add to queue Button Clicked");
        [self addToQueue:self.results[actionSheet.tag]];
    }
    
}

- (IBAction)back:(id)sender {
    [self.root goToPageWithIdentifier:@"Search" withInfo:nil];
}
    

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
