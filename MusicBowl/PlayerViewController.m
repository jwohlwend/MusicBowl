//
//  PlayerViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/4/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "PlayerViewController.h"
#import "RootViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    NSArray *items = [[NSArray alloc] initWithObjects:@"Search", @"Queue", @"Settings", nil];
    self.menu = [[BlurMenu alloc] initWithItems:items parentView:self.view delegate:self];
    self.menuIsShowing = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BlurMenu*) menu{
    return menu;
}
- (void) setMenu:(BlurMenu*) theMenu{
    menu = theMenu;
}

-(BOOL) menuIsShowing{
    return menuIsShowing;
}
- (void) setMenuIsShowing:(BOOL) isShowing{
    menuIsShowing = isShowing;
}

- (IBAction)showHideMenu:(id)sender {
    if (self.menuIsShowing){
        [self.menu hide];
    }
    else{
        [self.menu show];
    }
}

- (void)menuDidShow{
    self.menuIsShowing = YES;
}

- (void)menuDidHide{
    self.menuIsShowing = NO;
}

- (void)selectedItemAtIndex:(NSInteger)index {
    [self.root goToPageWithIdentifier:self.menu.menuItems[index] withInfo:nil];
    [self showHideMenu:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
}


@end
