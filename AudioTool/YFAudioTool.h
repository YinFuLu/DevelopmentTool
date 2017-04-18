//
//  YFAudioYool.h
//  AudioDemo
//
//  Created by LYF on 16/11/27.
//  Copyright © 2016年 LYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFAudioTool : NSObject

/** 播放音乐*/
+ (BOOL) playMusic:(NSString *)filename;

/** 暂停音乐*/
+(void) pauseMusic:(NSString *)filename;

/** 停止音乐*/
+(void) stopMusic:(NSString *)filename;

/** 播放音效*/
+ (void)playSound:(NSString *)filename;

/** 销毁音效*/
+ (void)disposeSound:(NSString *)filename;


@end
