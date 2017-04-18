//
//  YFAudioYool.m
//  AudioDemo
//
//  Created by LYF on 16/11/27.
//  Copyright © 2016年 LYF. All rights reserved.
//

#import "YFAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation YFAudioTool
/**
 * 用字典存放所有的音乐播放器
 */

static NSMutableDictionary *_musicPlays;

+ (NSMutableDictionary *) musicPlayers
{
    if (_musicPlays == nil) {
        _musicPlays = [NSMutableDictionary dictionary];
    }
    return _musicPlays;
}

/**
 *   用字典存放所有的音效
 */
static NSMutableDictionary *_soundIDs;
+ (NSMutableDictionary *)soundIDs
{
    if (_soundIDs == nil) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}



/** 播放音乐
 *  @param filename 音乐的文件名
 */

+ (BOOL)playMusic:(NSString *)filename
{
    if(filename == nil) return NO;
    
    // 1.取出对应的播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    
    // 2.播放器没有创建，进行初始化
    if(player == nil) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if(url == nil) return NO;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 缓冲
        if (![player prepareToPlay]) return NO;
        
        // 将播放器存到字典中
        [self musicPlayers][filename] = player;
    }
    
    // 3.播放
    if (![player isPlaying]) {
        return [player play];
    }
    return YES;
}

/** 暂停音乐*/
+ (void)pauseMusic:(NSString *)filename
{
    if(filename == nil) return;
    
    // 取出对应的音乐播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    
    if (player.isPlaying) {
        [player pause];
    }
    
}

/** 停止音乐*/
+ (void)stopMusic:(NSString *)filename
{
    if(filename == nil) return;
    
    // 取出对应的音乐播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    
    [player stop];
    
    // 将播放器从字典中移除
    [[self musicPlayers] removeObjectForKey:filename];
}



/** 播放音效*/
+ (void)playSound:(NSString *)filename
{
    if(filename == nil) return;
    
    // 通过字典属性取出对应的音效ID
    SystemSoundID soundID = [[self soundIDs][filename] doubleValue];
    
    // 初始化
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if(url == nil) return;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        // 存入字典
        [self soundIDs][filename] = @(soundID);
    }
    
    // 播放
    AudioServicesPlayAlertSound(soundID);
    
}

/** 销毁音效*/
+ (void)disposeSound:(NSString *)filename;
{
    if(filename == nil) return;
    
    // 取出对应的音效ID
    SystemSoundID soundID = [[self soundIDs][filename] doubleValue];
    
    // 销毁
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [[self soundIDs] removeObjectForKey:filename];
    }
}
@end
