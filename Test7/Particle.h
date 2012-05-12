//
//  Particle.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Token.h"

/**
 * パーティクルの種類
 */
enum eParticle {
    eParticle_Ball,     // 球体
    eParticle_Ring,     // 輪っか
    eParticle_Blade,    // 刃
    eParticle_ChargeRecover, // チャージゲージ回復
};

@interface Particle : Token {
    eParticle   m_Type;     // 種別
    BOOL        m_bBlink;   // 点滅して消える
    int         m_Timer;    // タイマー
    float       m_Val;      // 汎用パラメータ
}

// 種別の設定
- (void)setType:(eParticle)type;

// 要素の追加
+ (Particle*)add:(eParticle)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

@end
