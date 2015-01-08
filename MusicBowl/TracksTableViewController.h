//
//  TracksTableViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"
#import "MainVC.h"
#import "UIViewController+AMSlideMenu.h"
#import "RS3DSegmentedControl.h"

@interface TracksTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, RS3DSegmentedControlDelegate>
{
    NSString* artist;
    NSString* song;
    NSArray* results;
    NSString* source;
}

- (NSString*) song;
- (NSString*) artist;
- (NSArray*) results;
- (NSString*) source;
- (void) setSource: (NSString*) theSource;
- (void) setSong: (NSString*)songName;
- (void) setArtist: (NSString*)artistName;
- (void) setResults: (NSArray*)resultList;
- (NSArray*) findTracks:(NSString *)songName fromArtist:(NSString*) artistName;
- (void) play: (NSDictionary*) track;
- (void) addToQueue: (NSDictionary*) track;
- (void) playNext: (NSDictionary*) track;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property RS3DSegmentedControl *segmentedControl;

@end
