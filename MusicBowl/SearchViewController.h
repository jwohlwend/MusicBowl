//
//  SearchViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/8/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracksTableViewController.h"
#import "BlurMenu.h"
#import "ContentViewController.h"


@interface SearchViewController : ContentViewController<BlurMenuDelegate>
{
    BlurMenu *menu;
    BOOL menuIsShowing;
}

- (BlurMenu*) menu;
-(BOOL) menuIsShowing;
- (void) setMenuIsShowing:(BOOL) isShowing;
- (void) setMenu:(BlurMenu*) theMenu;

@property (strong, nonatomic) IBOutlet UITextField *songField;
@property (strong, nonatomic) IBOutlet UITextField *artistField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@end
