//
//  MainVC.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "AMSlideMenuMainViewController.h"
#import "ServerRequest.h"

@interface MainVC : AMSlideMenuMainViewController
{
    BOOL isPlaying;
    BOOL isPaused;
    BOOL isStopped;
}

- (BOOL) isPlaying;
- (BOOL) isPaused;
- (BOOL) isStopped;
- (void) setIsPlaying:(BOOL) playing;
- (void) setIsPaused:(BOOL) paused;
- (void) setIsStopped:(BOOL) stopped;


@end
