//
//  ViewController.m
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize recordingList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTimer {
    
    NSLog(@"Yoohoo");
    self.progressBar.progress = self.progressBar.progress + .2;
    
}

-(ViewController*) initWithCoder: (NSCoder*) aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.recordingList = [NSMutableArray init alloc];
        
        //self.recordingList = self.unarchiveArray;
        NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingsArchive", NSHomeDirectory()];
        NSMutableArray* recordingSet = [[NSMutableArray alloc] init];
        if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
            recordingSet = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
            [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
        }else{
            // Doesn't exist!
            NSLog(@"No file to open!!");
            //exit(1);
        }
        self.recordingList = recordingSet;

    }
    return self;
}
 

-(void) viewWillDisappear:(BOOL)animated
{
    //self.archiveArray;
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingsArchive", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject: recordingList toFile: archive];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController* tableView = segue.destinationViewController;
    tableView.otherRecordingsList = self.recordingList;
}

- (IBAction)start:(id)sender {
    
    //1. make a recording object
    //2. set currentRecording to new Recording
    //3. put into the list
    //4. set up recording session
    //5. set up timer to update progressBar & to expire the recording session
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
    
    [recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    [recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
    
    [recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
    
    [recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    
    [recordingSettings setValue:@(AVAudioQualityHigh)
                         forKey:AVEncoderAudioQualityKey];
    
    
    NSDate* now = [NSDate date];
    
    self.currentRecording = [[Recording alloc] initWithDate: now];
    [self.recordingList addObject: self.currentRecording];
    
    NSLog(@"%@",self.currentRecording);
    
    err = nil;
    
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.currentRecording.url
                     settings:recordingSettings
                     error:&err];
    
    if(!self.recorder){
        NSLog(@"recorder: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"Warning"
                                    message:[err localizedDescription]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if( !audioHWAvailable ){
        UIAlertController* cantRecordAlert = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"Audio input hardware not available."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
        
        [cantRecordAlert addAction:defaultAction];
        [self presentViewController:cantRecordAlert animated:YES completion:nil];
        
        
        return;
    }
    
    // start recording
    [self.recorder recordForDuration:(NSTimeInterval)5];
    
    self.statusLabel.text = @"Recording...";
    self.progressBar.progress = 0.0;
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.2
                  target:self
                  selector:@selector(handleTimer)
                  userInfo:nil
                  repeats:YES];
    
    
}

- (IBAction)stop:(id)sender {
    
    [self.recorder stop];
    
    [self.timer invalidate];
    self.statusLabel.text = @"Stopped";
    self.progressBar.progress = 1.0;
    
    if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
        NSLog(@"File exists");
        
    }else{
        NSLog(@"File does not exist");
    }
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    [self.timer invalidate];
    self.statusLabel.text = @"Stopped";
    self.progressBar.progress = 1.0;
    
    if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
        NSLog(@"File exists");
    }else{
        NSLog(@"File does not exist");
    }
}
//didFinish(a new method)
//1. turn off timer for progressView
//2. Clean up the session
//3. Set currentRecording to nil
//reset progressView


- (IBAction)swipe:(id)sender {
    
    //recognizes swipe from the left
    //moves to another view which will be controlled by tableViewController
}

@end
