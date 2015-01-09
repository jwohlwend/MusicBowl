//
//  QueueTableViewController.h
//  MusicBowl
//
//  Created by Jeremy Wohlwend on 1/6/15.
//  Copyright (c) 2015 jwohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequest.h"

@interface QueueTableViewController : UITableViewController <UIActionSheetDelegate>
{
    NSMutableArray* queue;
    NSMutableArray* oldQueue;
}
- (NSMutableArray*) queue;
- (void) setQueue: (NSMutableArray*) queueList;
- (NSMutableArray*) oldQueue;
- (void) setOldQueue: (NSMutableArray*) queueList;
- (void) refresh;
@end
