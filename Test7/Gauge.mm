//
//  Gauge.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Gauge.h"
#import "Math.h"

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
    glColor4f(r, g, 0, 1);
    
    for (int i = 0; i < cnt; i++) {
        float rot = 360 / COUNT_MAX * i + m_tPast * 8;
        float cx = x + 40 * Math_CosEx(rot);
        float cy = y + 40 * -Math_SinEx(rot);
        
        [self fillRect:cx cy:cy w:SIZE h:SIZE rot:0 scale:1];
    }
    
    // 通常に戻す
    System_SetBlend(eBlend_Normal);
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

@end

