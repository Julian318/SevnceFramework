//
//  TXSoundPlayer.h
//  易聚
//
//  Created by imac on 15/5/20.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface TXSoundPlayer : NSObject
{
    NSMutableDictionary* soundSet;  //声音设置
    NSString* path;  //配置文件路径
}
@property(nonatomic,assign)float rate;   //语速
@property(nonatomic,assign)float volume; //音量
@property(nonatomic,assign)float pitchMultiplier;  //音调
@property(nonatomic,assign)BOOL autoPlay;  //自动播放
+(TXSoundPlayer*)soundPlayerInstance;
-(void)play:(NSString*)text;
-(void)setDefault;
-(void)writeSoundSet;
-(void)stop;
@end
