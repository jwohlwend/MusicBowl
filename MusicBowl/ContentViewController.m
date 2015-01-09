//
//  ContentViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/9/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "ContentViewController.h"
#import "RootViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RootViewController*) root{
    return root;
}
- (void) setRoot:(RootViewController*) theRoot{
    root = theRoot;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
