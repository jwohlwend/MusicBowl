//
//  PlayerViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"
#import "UIViewController+AMSlideMenu.h"
#import "TracksTableViewController.h"

@interface PlayerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *artistField;
@property (weak, nonatomic) IBOutlet UITextField *songField;
@end
