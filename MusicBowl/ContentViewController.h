//
//  ContentViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/9/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface ContentViewController : UIViewController
{
   RootViewController* root;
}
- (RootViewController*) root;
- (void) setRoot:(RootViewController*) theRoot;
@end
