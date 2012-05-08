//
//  Bullet.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

enum eBulletVanish {
    eBulletVanish_Normal,   // そのまま消すだけ
    eBulletVanish_Reflect,  // 打ち返し弾発生
    eBulletVanish_Banana,   // バナナボーナス
};

// 敵弾実装
@interface Bullet : Token {
    int m_Timer;
}

// オブジェクト追加
+ (Bullet*)add:(float)x y:(float)y rot:(float)rot speed:(float)speed;

// 弾を消して打ち返し弾にする
- (void)vanishReflect;

// 敵弾をすべて消す
+ (void)vanishAll:(eBulletVanish)type;

// ダメージ
- (void)damage:(Token*)t;

@end
