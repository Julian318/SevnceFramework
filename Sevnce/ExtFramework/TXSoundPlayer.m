//
//  TXSoundPlayer.m
//  易聚
//
//  Created by imac on 15/5/20.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//
//zh-CN 简体中文，中华人民共和国zh-HK 繁体中文，香港特别行政区zh-MO 繁体中文，澳门特别行政区-zh-SG 繁体中文，新加坡-zh-SG 简体中文，新加坡zh-TW 繁体中文，台湾



#import "TXSoundPlayer.h"
static TXSoundPlayer* soundplayer=nil;
@interface TXSoundPlayer(){
    AVSpeechSynthesizer* player;
}
@end
@implementation TXSoundPlayer
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        soundplayer = [[super allocWithZone:NULL] init] ;
        [soundplayer initSoundSet];
    }) ;
    return soundplayer ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [TXSoundPlayer shareInstance] ;
}
+(id)new{
    return [TXSoundPlayer shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [TXSoundPlayer shareInstance] ;
}
-(void)play:(NSString*)text
{
    if(![text isEqualToString:NULL])
    {
        player=[[AVSpeechSynthesizer alloc]init];
        AVSpeechUtterance* u=[[AVSpeechUtterance alloc]initWithString:text];//设置要朗读的字符串
        u.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];//设置语言
        u.volume=self.volume;  //设置音量（0.0~1.0）默认为1.0
        u.rate=self.rate;  //设置语速
        [player speakUtterance:u];
    }
}
-(void)stop{
    [player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
-(void)initSoundSet
{
    path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SoundSet.plist"];
    soundSet=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    if(soundSet==nil)
    {
        soundSet=[NSMutableDictionary dictionary];
        [soundplayer setDefault];
        [soundplayer writeSoundSet];
    }
    else
    {
        self.autoPlay=[[soundSet valueForKeyPath:@"autoPlay"] boolValue];
        self.volume=[[soundSet valueForKeyPath:@"volume"] floatValue];
        self.rate=[[soundSet valueForKeyPath:@"rate"] floatValue];
        self.pitchMultiplier=[[soundSet valueForKeyPath:@"pitchMultiplier"] floatValue];
    }
}
-(void)setDefault
{
    self.volume=0.7;
    self.rate=0.4;
    self.pitchMultiplier=1.0;
}
-(void)writeSoundSet
{
    [soundSet setValue:[NSNumber numberWithBool:self.autoPlay] forKey:@"autoPlay"];
    [soundSet setValue:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    [soundSet setValue:[NSNumber numberWithFloat:self.rate] forKey:@"rate"];
    [soundSet setValue:[NSNumber numberWithFloat:self.pitchMultiplier] forKey:@"pitchMultiplier"];
    [soundSet writeToFile:path atomically:YES];
}
@end
