//
//  Enemy.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 敵種別
 */
enum eEnemy {
    eEnemy_Nasu,    // ナス
    eEnemy_Tako,    // たこ焼き
    eEnemy_5Box,    // ５箱
    eEnemy_Pudding, // プリン
    eEnemy_Milk,    // 牛乳
    eEnemy_XBox,    // XBox
    eEnemy_Radish,  // 大根
    eEnemy_Carrot,  // 人参
    eEnemy_Pokey,   // ポッキー
};
/**
 * 敵
 */
@interface Enemy : Token {
    eEnemy m_Id; // 敵番号
}

// 敵の生成
+ (Enemy*)add:(eEnemy)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

// 敵種別の設定
- (void)setType:(eEnemy)type;

@end
