//
//  Sound.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/**
 * BGMを再生する
 */
void Sound_PlayBgm(NSString* pPath);

/**
 * BGMを停止する
 */
void Sound_StopBgm();

/**
 * BGMの音量を設定する
 */
void Sound_SetBgmVolume(float vol);

/**
 * SEを再生する
 */
void Sound_PlaySe(NSString* pPath);

/**
 * SEをロードする
 */
void Sound_LoadSe(NSString* pPath);