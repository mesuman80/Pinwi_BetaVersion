//
//  Sound.h
//  FrameWorkStarting
//
//  Created by MVN on 23/09/13.
//  Copyright (c) 2013 MVN-Mac2. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SoundInit : AVAudioPlayer

-(id)init:(NSString *)soundPlay withFormat:(NSString *)soundFormat;

@end
