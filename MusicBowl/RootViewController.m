//
//  RootViewController.m
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/9/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (UIPageViewController*) pageViewController{
    return pageViewController;
}
- (NSArray*) identifiers{
    return identifiers;
}
- (NSArray*) contentViewControllers{
    return contentViewControllers;
}
- (void) setPageViewController: (UIPageViewController*) controller{
    pageViewController = controller;
}
- (void) setIdentifiers:(NSArray*) theIdentifiers{
    identifiers = theIdentifiers;
}
- (void) setContentViewControllers:(NSArray*) theContentViewControllers{
    contentViewControllers = theContentViewControllers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.identifiers = @[@"Search",@"Results",@"Queue",@"Player"];
    NSMutableArray* contentControllers = [[NSMutableArray alloc] initWithCapacity:[self.identifiers count]];
    for (int i = 0;  i < [self.identifiers count]; i++){
        ContentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:self.identifiers[i]];
        vc.root = self;
        contentControllers[i] = vc;
    }
    self.contentViewControllers = contentControllers;
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"music-wallpaper.jpg"];
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:background atIndex:0];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    SearchViewController* startingViewController = (SearchViewController*)self.contentViewControllers[0];
    
    NSArray* viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.frame = self.view.frame;
    [self.pageViewController didMoveToParentViewController:self];
    for (UIScrollView* theView in self.pageViewController.view.subviews){
        theView.scrollEnabled = NO;
    }
    
    
    // Do any additional setup after loading the view.
}

- (void) goToPageWithIdentifier:(NSString*) identifier withInfo:(NSDictionary*) info{
    ContentViewController* startingViewController;
    UIPageViewControllerNavigationDirection direction;
    if([identifier isEqualToString:@"Results"]){
        TracksTableViewController* vc = (TracksTableViewController*) [self viewControllerAtIndex:(int)[self indexOfViewControllerWithIdentifier:identifier] storyboard:self.storyboard];
            vc.song = [info valueForKey:@"song"];
            vc.artist = [info valueForKey:@"artist"];
            startingViewController = vc;
            direction = UIPageViewControllerNavigationDirectionForward;
    }
    else if([identifier isEqualToString:@"Search"]){
        direction = UIPageViewControllerNavigationDirectionReverse;
        startingViewController = (ContentViewController*)[self viewControllerAtIndex:(int)[self indexOfViewControllerWithIdentifier:identifier] storyboard:self.storyboard];
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
        startingViewController = (ContentViewController*)[self viewControllerAtIndex:(int)[self indexOfViewControllerWithIdentifier:identifier] storyboard:self.storyboard];
    }
    NSArray* viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
    
}
- (UIViewController*)viewControllerAtIndex:(int) index storyboard:(UIStoryboard*) theStoryBoard{
    if ([self.identifiers count] == 0 || index >= [self.identifiers count]){
        return nil;
    }
    return self.contentViewControllers[index];
}

- (int) indexOfViewControllerWithIdentifier: (NSString*) identifier{
    return (int)[self.identifiers indexOfObject:identifier];
}

- (int) indexOfViewController: (UIViewController*) viewController {
    return (int)[self.identifiers indexOfObject:viewController.title];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = [self indexOfViewController:viewController];
    if (index == 0){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = [self indexOfViewController:viewController];
    if (index == ([self.identifiers count] - 1)){
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
