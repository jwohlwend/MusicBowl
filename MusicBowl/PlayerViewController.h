//
//  PlayerViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "BlurMenu.h"

@interface PlayerViewController : ContentViewController<BlurMenuDelegate>
{
    BlurMenu *menu;
    BOOL menuIsShowing;
}

- (BlurMenu*) menu;
-(BOOL) menuIsShowing;
- (void) setMenuIsShowing:(BOOL) isShowing;
- (void) setMenu:(BlurMenu*) theMenu;
@end
