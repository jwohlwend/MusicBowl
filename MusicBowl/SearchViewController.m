//
//  SearchViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/8/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "SearchViewController.h"
#import "RootViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGSize logoSize = CGSizeMake(280.0, 70.0);
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - logoSize.width)/2.0, self.view.frame.size.height/2.0 - 2*logoSize.height, logoSize.width, logoSize.height)];
    logo.image = [UIImage imageNamed:@"Black_and_white_on_transparent_background_282x75.png"];
    [self.view addSubview:logo];
    CGSize size = CGSizeMake(300.0, 50);
    _songField.frame = CGRectMake((self.view.frame.size.width - size.width)/2.0, logo.frame.origin.y + logo.frame.size.height + 20.0, size.width, size.height);
    _artistField.frame = CGRectMake(_songField.frame.origin.x, _songField.frame.origin.y + _songField.frame.size.height+10.0, size.width, size.height);
    
    for (UITextField *field in @[_songField, _artistField]){
        [field setValue:[UIColor colorWithWhite:1.0 alpha:0.6]
                        forKeyPath:@"_placeholderLabel.textColor"];
        field.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        field.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.7] CGColor];
        field.layer.masksToBounds = YES;
        field.layer.borderWidth = 2.0;
        field.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        field.layer.cornerRadius = 1.0;
        [self.view addSubview:field];
    }
    CGSize buttonSize = CGSizeMake(120.0, 50.0);
    _searchButton.frame = CGRectMake((self.view.frame.size.width - buttonSize.width)/2.0, _artistField.frame.origin.y + _artistField.frame.size.height + 50.0, buttonSize.width, buttonSize.height);
    _searchButton.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.7] CGColor];
    _searchButton.layer.masksToBounds = YES;
    _searchButton.layer.borderWidth = 2.0;
    _searchButton.layer.cornerRadius = 1.0;
    
    
    NSArray *items = [[NSArray alloc] initWithObjects:@"Player", @"Queue", @"Settings", nil];
    
    self.menu = [[BlurMenu alloc] initWithItems:items parentView:self.view delegate:self];
    self.menuIsShowing = NO;
    
    // Do any additional setup after loading the view.
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
- (IBAction)resign:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)search:(id)sender {
    NSDictionary* info = @{@"song":_songField.text, @"artist":_artistField.text};
    [self.root goToPageWithIdentifier:@"Results" withInfo:info];
}

- (void)selectedItemAtIndex:(NSInteger)index {
    [self.root goToPageWithIdentifier:self.menu.menuItems[index] withInfo:nil];
    [self showHideMenu:self];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
 }

@end
