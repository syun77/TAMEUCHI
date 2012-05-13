//
//  SaveData.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "SaveData.h"

/**
 * セーブデータを初期化する
 */
void SaveData_Init() {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"INIT"]) {
        
        // 初期化済みなので何もしない
        return;
    }
    
    [defaults setBool:YES forKey:@"INIT"];
    [defaults setInteger:0 forKey:@"HI_SCORE"];
    [defaults setInteger:1 forKey:@"RANK"];
    [defaults setInteger:1 forKey:@"RANK_MAX"];
    
    // 保存
    [defaults synchronize];
}

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore() {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults integerForKey:@"HI_SCORE"];
    
}

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 * @param bForce 強制的に更新する
 */
void SaveData_SetHiScore(int score, BOOL bForce) {
    int hiScore = SaveData_GetHiScore();
    
    if (bForce == NO) {
        if (score <= hiScore) {
            // 更新不要
            return;
        }
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:score forKey:@"HI_SCORE"];
    
    // 保存
    [defaults synchronize];
}

/**
 * タイトル画面で選択した難易度を取得する
 * @return 難易度
 */
int SaveData_GetRank() {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults integerForKey:@"RANK"];
}

/**
 * タイトル画面→メインゲーム用の難易度設定
 * @param rank 難易度
 */
void SaveData_SetRank(int rank) {
    int max = SaveData_GetRank();
    
    if (rank < max) {
        
        // 更新不要
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:rank forKey:@"RANK"];
    
    // 保存
    [defaults synchronize];
}

/**
 * 到達したことのある最大難易度を取得する
 * @return 最大難易度
 */
int SaveData_GetRankMax() {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults integerForKey:@"RANK_MAX"];
}

/**
 * 最大難易度を設定する
 * @param rank 最大難易度
 */
void SaveData_SetRankMax(int rank) {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    int max = SaveData_GetRank();
    if (rank < max) {
        
        // 更新不要
        return;
    }
    
    [defaults setInteger:rank forKey:@"RANK_MAX"];
    
    // 保存
    [defaults synchronize];
}
