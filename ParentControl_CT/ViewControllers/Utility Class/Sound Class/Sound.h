//
//  Sound.h
//  FrameWorkStarting
//
//  Created by MVN on 23/09/13.
//  Copyright (c) 2013 MVN-Mac2. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SoundInit.h"
#import "ChildProfileObject.h"

@protocol SounPlayerProtocol <NSObject>

-(void)audioPlayerDidFinishedPlaying;

@end



@interface Sound : UIView<AVAudioPlayerDelegate>
{
    SoundInit *buttonSound;
    SoundInit *pageSound;
    SoundInit *wheelSound;
    SoundInit *voiceOverSound;
    //SoundInit *
}
@property ChildProfileObject *child;
@property id<SounPlayerProtocol>soundDelegate;
-(void)rewind;
-(void)playButtonSound:(NSString*)soundName withFormat:(NSString*)soundFormat;
-(void)playPageFlipSound:(NSString*)soundName withFormat:(NSString*)soundFormat;
-(void)playWheelRotationSound:(NSString*)soundName withFormat:(NSString*)soundFormat;
-(void)playVoiceOverSounds:(NSString*)soundName withFormat:(NSString*)soundFormat;
-(void)stopSound;
-(void)stopVoiceOver;

@end
