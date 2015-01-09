//
//  RootViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/9/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SearchViewController.h"

@interface RootViewController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    UIPageViewController *pageViewController;
    NSArray* identifiers;
    NSArray* contentViewControllers;
}
- (UIPageViewController*) pageViewController;
- (NSArray*) identifiers;
- (NSArray*) contentViewControllers;
- (void) setPageViewController: (UIPageViewController*) controller;
- (void) setIdentifiers:(NSArray*) theIdentifiers;
- (void) setContentViewControllers:(NSArray*) theContentViewControllers;
- (void) goToPageWithIdentifier:(NSString*) identifier withInfo:(NSDictionary*) info;
@end
