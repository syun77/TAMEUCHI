//
//  SaveData.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 */
void SaveData_SetHiScore(int score, BOOL bForce=false);

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore();