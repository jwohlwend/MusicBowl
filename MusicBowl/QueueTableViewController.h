//
//  QueueTableViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/6/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"

@interface QueueTableViewController : UITableViewController
{
    NSMutableArray* queue;
}
- (NSMutableArray*) queue;
- (void) setQueue: (NSMutableArray*) queueList;
- (void) refresh;
- (void) handleError:(NSError*) error;
@end
