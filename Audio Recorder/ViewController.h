//
//  ViewController.h
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <AVAudioRecorderDelegate>

@property (weak) NSMutableArray* recordingList;
@property (strong, nonatomic) Recording* currentRecording;
@property (strong, nonatomic) AVAudioRecorder* recorder;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
- (IBAction)swipe:(id)sender;
//@property (strong, nonatomic) Recording* currentRecording;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSTimer* timer;
- (void) handleTimer;
@end

