//
//  SaveData.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "SaveData.h"

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 */
void SaveData_SetHiScore(int score)
{
    int hiScore = SaveData_GetHiScore();
    if (score <= hiScore) {
        // 更新不要
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:score forKey:@"HI_SCORE"];
    
    // 保存
    [defaults synchronize];
}

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore()
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"HI_SCORE"];
    
}