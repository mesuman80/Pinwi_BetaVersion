//
//  Sound.m
//  FrameWorkStarting
//
//  Created by MVN on 23/09/13.
//  Copyright (c) 2013 MVN-Mac2. All rights reserved.
//

#import "SoundInit.h"

@implementation SoundInit

-(id)init:(NSString *)soundPlay withFormat:(NSString *)soundFormat
{
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundPlay ofType:soundFormat];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    
    if(self=[super initWithContentsOfURL:soundFileURL error:nil])
    {
        
    }
    
    return self;
}

-(void)rewind
{
    [self setCurrentTime:0];
}

-(void)playSound
{
    [self play];
}

-(void)stopSound
{
    [self stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   
}



@end
