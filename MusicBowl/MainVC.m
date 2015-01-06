//
//  MainVC.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/5/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ServerRequest* request = [[ServerRequest alloc] initWithType:@"core.tracklist.set_consume"];
    NSArray* parameters = @[[NSNumber numberWithInt:1]];
    [request addParameter:@"params" withValue:parameters];
    [request start];
    [request synchronize];
    if ([request getError]){
        [self handleError:[request getError]];
    }
    // Do any additional setup after loading the view.
}

- (void) handleError:(NSError*) error {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:[error description]
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AMPrimaryMenu)primaryMenu{
    return AMPrimaryMenuLeft;
}

- (BOOL)deepnessForLeftMenu
{
    return NO;
}

- (NSIndexPath *)initialIndexPathForLeftMenu{
    return [NSIndexPath indexPathForRow:0 inSection:1];
}

-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return @"search";
            break;
        case 1:
            return @"queue";
            break;
            
        default:
            return @"Error little buddy";
            break;
    }
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
