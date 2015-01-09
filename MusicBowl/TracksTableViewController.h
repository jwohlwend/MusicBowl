//
//  TracksTableViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"
#import "HMSegmentedControl.h"
#import "ContentViewController.h"

@class RootViewController;
@interface TracksTableViewController : ContentViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    NSString* artist;
    NSString* song;
    NSArray* results;
    NSArray* sources;
    HMSegmentedControl *segmentedControl;
}

- (NSString*) song;
- (NSString*) artist;
- (NSArray*) results;
- (NSArray*) sources;
- (HMSegmentedControl*) segmentedControl;
- (void) setSegmentedControl: (HMSegmentedControl*) theSegment;
- (void) setSources: (NSArray*) theSources;
- (void) setSong: (NSString*)songName;
- (void) setArtist: (NSString*)artistName;
- (void) setResults: (NSArray*)resultList;
- (NSArray*) findTracks:(NSString *)songName fromArtist:(NSString*) artistName fromSource:(NSString*) source;
- (void) play: (NSDictionary*) track;
- (void) addToQueue: (NSDictionary*) track;
- (void) playNext: (NSDictionary*) track;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
