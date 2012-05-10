//
//  Sound.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Sound.h"
#import "SimpleAudioEngine.h"

/**
 * BGMを再生する
 */
void Sound_PlayBgm(NSString* pPath) {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:pPath];
}

/**
 * BGMを停止する
 */
void Sound_StopBgm() {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

/**
 * BGMの音量を設定する
 */
void Sound_SetBgmVolume(float vol) {
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:vol];
}

/**
 * SEを再生する
 */
void Sound_PlaySe(NSString* pPath) {
    [[SimpleAudioEngine sharedEngine] playEffect:pPath];
}

/**
 * SEをロードする
 */
void Sound_LoadSe(NSString* pPath) {
    [[SimpleAudioEngine sharedEngine] preloadEffect:pPath];
}