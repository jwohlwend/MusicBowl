//
//  TracksTableViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"

@interface TracksTableViewController : UITableViewController
{
    NSString* artist;
    NSString* song;
    NSArray* results;
}

- (NSString*) song;
- (NSString*) artist;
- (NSArray*) results;
- (void) setSong: (NSString*)songName;
- (void) setArtist: (NSString*)artistName;
- (void) setResults: (NSArray*)resultList;
- (NSArray*) findTracks:(NSString *)songName fromArtist:(NSString*) artistName;
- (void) play: (NSDictionary*) track;
- (void) addToQueue: (NSDictionary*) track;
- (void) playNext: (NSDictionary*) track;
- (void) handleError:(NSError*) error;

@end
