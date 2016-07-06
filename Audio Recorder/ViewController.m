//
//  ViewController.m
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize recordings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) archiveArray
{
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingsArchive", NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject: recordings toFile: archive];
}
-(NSMutableArray*) unarchiveArray
{
     NSString* archive = [NSString stringWithFormat:@"%@/Documents/recordingsArchive", NSHomeDirectory()];
     NSMutableArray* recordingSet;
    if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
        recordingSet = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
        [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
    }else{
        // Doesn't exist!
        NSLog(@"No file to open!!");
        exit(1);
    }
    return recordingSet;

}

- (IBAction)start:(id)sender {
}

- (IBAction)stop:(id)sender {
}


@end
