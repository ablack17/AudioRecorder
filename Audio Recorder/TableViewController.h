//
//  TableViewController.h
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/8/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface TableViewController : UITableViewController
@property(strong, nonatomic) NSMutableArray* otherRecordingsList;
@property (strong, nonatomic) AVAudioPlayer* player;
@end
