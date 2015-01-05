//
//  PlayerViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*) findTracks:(NSString *)name fromArtist:(NSString*) artist{
    NSArray* trackList = @[];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.library.search"];
    NSMutableDictionary* searchQuery = [[NSMutableDictionary alloc] init];
    if (![name isEqualToString:@""]){
        [searchQuery setValue:name forKey:@"any"];
    }
    if (![artist isEqualToString:@""]){
        [searchQuery setValue:artist forKey:@"artist"];
    }
    NSArray* parameters = [NSArray arrayWithObjects:searchQuery, nil];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [self handleError:[request getError]];
    }
    else{
        trackList = (NSArray*)[[request getResponse] valueForKey:@"tracks"][0];
    }
    return trackList;
}

- (void) addTrack:(NSDictionary*) track{
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.add"];
    NSArray* parameters = [NSArray arrayWithObjects:@[track], nil];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [self handleError:[request getError]];
    }
}


- (IBAction)playTest:(id)sender {
    NSArray* tracks = [self findTracks:@"take me to church" fromArtist:@"Hozier"];
    [self addTrack:tracks[0]];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.playback.play"];
    [request start];
    [request synchronize];
    if ([request getError]){
        [self handleError:[request getError]];
    }
}

- (void) handleError:(NSError*) error {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:[error description]
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
