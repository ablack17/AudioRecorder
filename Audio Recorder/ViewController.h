//
//  ViewController.h
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
@interface ViewController : UIViewController

@property (weak) NSMutableArray* recordings;

-(void) archiveArray;
-(NSMutableArray*) unarchiveArray;
- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end

