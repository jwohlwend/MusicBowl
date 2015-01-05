//
//  PlayerViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"

@interface PlayerViewController : UIViewController
- (NSArray*) findTracks:(NSString *)name fromArtist:(NSString*) artist;
- (void) addTrack:(NSDictionary*) track;
- (IBAction)playTest:(id)sender;
- (void) handleError:(NSError*) error;
@end
