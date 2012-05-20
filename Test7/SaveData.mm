//
//  SaveData.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "SaveData.h"

/**
 * NSUserDefaultsを取得する
 */
static NSUserDefaults* _Get()
{
    return [NSUserDefaults standardUserDefaults];
}

/**
 * セーブデータを初期化する
 */
void SaveData_Init() {
    NSUserDefaults* defaults = _Get();
    
    if ([defaults boolForKey:@"INIT"]) {
        
        // 初期化済みなので何もしない
        return;
    }
    
    [defaults setBool:YES forKey:@"INIT"];
    [defaults setInteger:0 forKey:@"HI_SCORE"];
    [defaults setInteger:1 forKey:@"RANK"];
    [defaults setInteger:1 forKey:@"RANK_MAX"];
    [defaults setBool:YES forKey:@"BGM"];
    [defaults setBool:YES forKey:@"SE"];
    
    // 保存
    [defaults synchronize];
}

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore() {
    NSUserDefaults* defaults = _Get();
    
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
    
    NSUserDefaults* defaults = _Get();
    [defaults setInteger:score forKey:@"HI_SCORE"];
    
    // 保存
    [defaults synchronize];
}

/**
 * タイトル画面で選択した難易度を取得する
 * @return 難易度
 */
int SaveData_GetRank() {
    
    NSUserDefaults* defaults = _Get();
    
    return [defaults integerForKey:@"RANK"];
}

/**
 * タイトル画面→メインゲーム用の難易度設定
 * @param rank 難易度
 */
BOOL SaveData_SetRank(int rank) {
    
    // 10の倍数になるようにする
    rank = (int)(rank / 10) * 10;
    if (rank < 1) {
        rank = 1;
    }
    
    // 最大ランクの端数切捨てで丸める
    int max = (int)(SaveData_GetRankMax() / 10) * 10;
    
    if (rank > max) {
        
        rank = max;
    }
    if (rank < 1) {
        rank = 1;
    }
    
    if (rank == SaveData_GetRank()) {
        
        // 更新できなかった
        return NO;
    }
    
    NSUserDefaults* defaults = _Get();
    [defaults setInteger:rank forKey:@"RANK"];
    
    // 保存
    [defaults synchronize];
    
    // 更新できた
    return YES;
}

/**
 * 到達したことのある最大難易度を取得する
 * @return 最大難易度
 */
int SaveData_GetRankMax() {
    
    NSUserDefaults* defaults = _Get();
    
    
    return [defaults integerForKey:@"RANK_MAX"];
}

/**
 * 最大難易度を設定する
 * @param rank 最大難易度
 */
void SaveData_SetRankMax(int rank) {
    
    NSUserDefaults* defaults = _Get();
    
    int max = SaveData_GetRankMax();
    if (rank < max) {
        
        // 更新不要
        return;
    }
    
    [defaults setInteger:rank forKey:@"RANK_MAX"];
    
    // 保存
    [defaults synchronize];
}

/**
 * BGMが有効となっているかどうか
 * @return BGMが有効ならば「YES」
 */
BOOL SaveData_IsEnableBgm() {
    NSUserDefaults* ix = _Get();
    
    return [ix boolForKey:@"BGM"];
}

/**
 * BGMが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableBgm(BOOL b) {
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"BGM"];
    
    // 保存
    [ix synchronize];
}

/**
 * SEが有効となっているかどうか
 * @return SEが有効ならば「YES」
 */
BOOL SaveData_IsEnableSe() {
    NSUserDefaults* ix = _Get();
    
    return [ix boolForKey:@"SE"];
}

/**
 * SEが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableSe(BOOL b) {
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"SE"];
    
    // 保存
    [ix synchronize];
}
