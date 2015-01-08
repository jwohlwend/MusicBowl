//
//  TracksTableViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "TracksTableViewController.h"

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
- (NSString*) source{
    return source;
}
- (void) setSource: (NSString*) theSource{
    source = theSource;
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
    self.source = @"spotify";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _segmentedControl = [[RS3DSegmentedControl alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y + 15, self.view.frame.size.width, 40)];
    _segmentedControl.delegate = self;
    [self.view addSubview:_segmentedControl];
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.results = [self findTracks:self.song fromArtist:self.artist];
    [self.tableView reloadData];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) play: (NSDictionary*) track{
    [self playNext:track];
    MainVC *mainVC = (MainVC*)[self mainSlideMenu];
    if (![mainVC isStopped]){
        ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.playback.stop"];
        NSArray* parameters = @[[NSNumber numberWithBool:YES]];
        [request addParameter:@"params" withValue:parameters];
        [request start];
        [request synchronize];
        if ([request getError]){
            [request handleError:[request getError] withVC:self];
            return;
        }
    }
    ServerRequest* request2 = [[ServerRequest alloc] initWithType:@"core.playback.play"];
    [request2 start];
    [request2 synchronize];
    if ([request2 getError]){
        [request2 handleError:[request2 getError] withVC:self];

        return;
    }
    mainVC.isStopped = NO;
    mainVC.isPlaying = YES;
}

- (void) playNext: (NSDictionary*) track{
    MainVC *mainVC = (MainVC*)[self mainSlideMenu];
    NSNumber *position = [NSNumber numberWithBool:!([mainVC isStopped])];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.add"];
    NSArray* parameters = @[@[track],position];
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

- (NSArray*) findTracks:(NSString *)songName fromArtist:(NSString*) artistName{
    NSArray* trackList = @[];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.library.search"];
    NSMutableDictionary* searchQuery = [[NSMutableDictionary alloc] init];
    if (![songName isEqualToString:@""]){
        [searchQuery setValue:songName forKey:@"any"];
    }
    if (![artistName isEqualToString:@""]){
        [searchQuery setValue:artistName forKey:@"artist"];
    }
    NSArray* parameters = [NSArray arrayWithObjects:searchQuery, @[[self.source stringByAppendingString:@":"]],nil];
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

- (NSUInteger)numberOfSegmentsIn3DSegmentedControl:(RS3DSegmentedControl *)segmentedControl{
    return 2;
}
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl{
    switch (segmentIndex) {
        case 0:
            return @"Spotify";
        case 1:
            return @"SoundCloud";
        default:
            return @"Unknowm";
    }
}
- (void)didSelectSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl{
    switch (segmentIndex) {
        case 0:
            self.source = @"spotify";
            self.results = [self findTracks:self.song fromArtist:self.artist];
            [_tableView reloadData];
            break;
        case 1:
            self.source = @"soundcloud";
            self.results = [self findTracks:self.song fromArtist:self.artist];
            [_tableView reloadData];
            break;
        default:
            break;
    }
    
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
