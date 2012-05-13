//
//  Gauge.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Gauge.h"
#import "Math.h"
#import "Particle.h"
#import "GameScene.h"

static const int POS_X = 8;
static const int POS_Y = 320-48;
static const int GAUGE_WIDTH  = 2;
static const int GAUGE_HEIGHT = 8;

/**
 * ゲージ実装
 */
@implementation Gauge

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Now = 1;
    m_Max = 1;
    m_tPast = 0;
    
    return self;
}

/**
 * ゲージの描画
 */
- (void)visit {
    
    m_tPast++;
    
    [super visit];
    
    if (self.visible == NO) {
        // 非表示
        return;
    }
    
    float x = self._x;
    float y = self._y;
    
    // 加算ブレンド有効
    System_SetBlend(eBlend_Add);
    
    
    const int COUNT_MAX = 8;
    const int SIZE = 8;
    
    int cnt = (COUNT_MAX - 1) * m_Now / m_Max;
    if (m_Now > 0) {
        cnt++;
    }
    
    float r = 1.0 * cnt / COUNT_MAX;
    float g = 1.0 * (COUNT_MAX - cnt) / COUNT_MAX;
    float b = 0;
    glColor4f(r, g, b, 0.5f);
    
    for (int i = 0; i < cnt; i++) {
        float rot = 360 / COUNT_MAX * i + m_tPast * 8;
        float cx = x + 40 * Math_CosEx(rot);
        float cy = y + 40 * -Math_SinEx(rot);
        
        [self fillRect:cx cy:cy w:SIZE h:SIZE rot:0 scale:1];
    }
    
    // 通常に戻す
    System_SetBlend(eBlend_Normal);
    
    // バーの描画
    if (m_Now == m_Max) {
        g = 0.5 * Math_SinEx((m_tPast*3)%180);
        b = 0.5 * Math_SinEx((m_tPast*3)%180);
        glColor4f(r, g, b, 0.5f);
    }
    
    float px = POS_X;
    float py = POS_Y;
    [self fillRectLT:px y:py w:GAUGE_WIDTH * m_Now h:GAUGE_HEIGHT rot:0 scale:1];
    glColor4f(1, 1, 1, 0.5f);
    glLineWidth(1);
    [self drawRectLT:px y:py w:GAUGE_WIDTH * m_Max h:GAUGE_HEIGHT rot:0 scale:1];
}

// 初期化
- (void)initialize:(int)max {
    m_Max = max;
}

// 現在値を設定
- (void)set:(int)v x:(float)x y:(float)y {
    
    m_Now = v;
    if (m_Now > m_Max) {
        m_Now = m_Max;
    }
    if (m_Now < 0) {
        m_Now = 0;
    }
    
    self._x = x;
    self._y = y;
    [self move:0];
}

// 最大値を設定する
- (void)setMax:(int)v {
    m_Max = v;
    if (m_Now > m_Max) {
        m_Now = m_Max;
    }
}

// 現在値を取得する
- (int)getNow {
    return m_Now;
}

// 値を追加する
- (int)add:(int)v {
    m_Now += v;
    if (m_Now > m_Max) {
        m_Now = m_Max;
    }
    
    return m_Now;
}

// 値を減らす
- (int)sub:(int)v {
    m_Now -= v;
    if (m_Now < 0) {
        m_Now = 0;
    }
    
    return  m_Now;
}

// チャージ回復エフェクトの生成
- (void)addChargeEffect {
    float x = POS_X + GAUGE_WIDTH * m_Now;
    float y = POS_Y + GAUGE_HEIGHT / 2;
    
    [Particle add:eParticle_ChargeRecover x:x y:y rot:0 speed:0];
}

// チャージ回復エフェクト(小)の生成
- (void)addChargeEffectSmall {
    
    float x = POS_X + GAUGE_WIDTH * m_Now;
    float y = POS_Y + GAUGE_HEIGHT / 2;
    
//    float rot = Math_RandInt(-45, 45);
    float rot = Math_RandInt(-180, 180);
    float speed = 100;
    Particle* p = [Particle add:eParticle_Ball x:x y:y rot:rot speed:speed];
    if (p) {
        [p setScale:0.1];
        Player* player = [GameScene sharedInstance].player;
        float pRatio = [player getPowerRatio];
        float r = pRatio;
        float g = 1.0 - pRatio;
        [p setColor:ccc3(0xFF * r, 0xFF * g, 0)];
        [p setTimer:24];
    }
}

@end

