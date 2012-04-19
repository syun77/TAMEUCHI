//
//  LevelMgr.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * レベル管理
 */
@interface LevelMgr : CCNode {
    int m_tPast; // 経過時間
    int m_Timer;  // 汎用タイマー
    int m_nLevel; // レベル
}

// 初期化
- (void)initialize;

// 更新
- (void)update:(ccTime)dt;

// レベルの取得
- (int)getLevel;

// タイマーの取得
- (int)getTimer;

@end
