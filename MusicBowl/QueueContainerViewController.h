//
//  QueueContainerViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/9/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurMenu.h"
#import "ContentViewController.h"

@interface QueueContainerViewController : ContentViewController<BlurMenuDelegate>
{
    BlurMenu *menu;
    BOOL menuIsShowing;
}
- (BlurMenu*) menu;
-(BOOL) menuIsShowing;
- (void) setMenuIsShowing:(BOOL) isShowing;
- (void) setMenu:(BlurMenu*) theMenu;
@end
