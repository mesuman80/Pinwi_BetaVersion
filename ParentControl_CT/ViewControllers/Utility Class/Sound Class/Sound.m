//
//  Sound.m
//  FrameWorkStarting
//
//  Created by MVN on 23/09/13.
//  Copyright (c) 2013 MVN-Mac2. All rights reserved.
//

#import "Sound.h"

@implementation Sound
{
    NSMutableArray *soundArray;
}

-(id)init
{
    if(self=[super init])
    {
        soundArray =[[NSMutableArray alloc]init];
    }
    
    return self;
}


-(void)rewind
{
   // [self setCurrentTime:0];
}


-(void)playButtonSound:(NSString*)soundName withFormat:(NSString*)soundFormat
{
    NSString *soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.child.child_ID];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"1"])
    {
//        if(!buttonSound)
//        {
            buttonSound=[[SoundInit alloc]init:soundName withFormat:soundFormat];
            buttonSound.delegate=(id)self;
//        }
        if(![buttonSound isPlaying])
        {
           // [self stopSound];
            [buttonSound play];
            [soundArray addObject:buttonSound];
        }
    }
}

-(void)playPageFlipSound:(NSString*)soundName withFormat:(NSString*)soundFormat
{
    NSString *soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.child.child_ID];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"1"])
    {
        if(!pageSound)
        {
            pageSound=[[SoundInit alloc]init:soundName withFormat:soundFormat];
        }
        if(![pageSound isPlaying])
        {
            //[self stopSound];
            [pageSound play];
            [soundArray addObject:pageSound];
        }
    }
}


-(void)playWheelRotationSound:(NSString*)soundName withFormat:(NSString*)soundFormat
{
    NSString *soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.child.child_ID];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"1"])
    {
        if(!wheelSound)
        {
            wheelSound=[[SoundInit alloc]init:soundName withFormat:soundFormat];
        }
        if(![wheelSound isPlaying])
        {
            //[self stopSound];
            [wheelSound play];
            [soundArray addObject:wheelSound];
        }
    }
}

-(void)playVoiceOverSounds:(NSString*)soundName withFormat:(NSString*)soundFormat
{
    NSString *soundPlayString=[NSString stringWithFormat:@"VoiceOverOnOff-%@",self.child.child_ID];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"1"])
    {
        if(!voiceOverSound)
        {
            voiceOverSound=[[SoundInit alloc]init:soundName withFormat:soundFormat];
            voiceOverSound.delegate=(id)self;
        }
        if(![voiceOverSound isPlaying])
        {
            // [self stopSound];
            [voiceOverSound play];
            //[soundArray addObject:voiceOverSound];
        }
    }
}


-(void)stopSound
{
    if(soundArray.count>0)
    {
        for(SoundInit *sI in soundArray)
        {
            [sI stop];
        }
    }
    [soundArray removeAllObjects];
    wheelSound.delegate=nil;
    pageSound.delegate=nil;
    buttonSound.delegate=nil;
    wheelSound=nil;
    pageSound=nil;
    buttonSound=nil;
    
}

-(void)stopVoiceOver
{
    [voiceOverSound stop];
    voiceOverSound.delegate=nil;
    voiceOverSound=nil;
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.soundDelegate audioPlayerDidFinishedPlaying];
}


@end
