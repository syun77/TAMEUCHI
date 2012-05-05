//
//  Item.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * アイテムの種類
 */
enum eItem {
    eItem_Recover,  // 回復アイテム
    eItem_Score,    // 得点アイテム
    eItem_Power,    // ショットゲージアップアイテム
    eItem_Weapon,   // 武器切り替えアイテム
};

/**
 * アイテムトークン
 */
@interface Item : Token {
    int     m_tPast;    // 経過時間
    eItem   m_Type;     // アイテムの種類
    BOOL    m_bHorming; // ホーミング開始フラグ
}

// アイテム種別の取得
- (eItem)getType;


// アイテム取得演出の再生
- (void)vanishWithEffect;

// アイテムの生成
+ (Item*)add:(eItem)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

@end
