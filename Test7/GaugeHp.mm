//
//  GaugeHp.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GaugeHp.h"

static const int OFFSET_Y = 24;
static const int HP_WIDTH = 48;
static const int HP_HEIGHT = 4;

/**
 * HPゲージ描画モジュール
 */
@implementation GaugeHp

// コンストラクタ
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Now = 1;
    m_Max = 1;
    m_tPast = 0;
    m_X = 0;
    m_Y = 0;
    
    return self;
}

// 初期化
- (void)initialize:(int)max {
    m_Max = max;
}

// 現在値を設定
- (void)set:(int)v x:(float)x y:(float)y {
    m_X = x;
    m_Y = y;
    m_Now = v;
    
    [self move:0];
}

// 現在値を取得
- (int)getNow {
    return m_Now;
}

// ゲージ描画
- (void)visit {
    float x = m_X;
    float y = m_Y;
    
    y -= OFFSET_Y;
    x -= HP_WIDTH / 2;
    y -= HP_HEIGHT / 2;
    
    float ratio = m_Now / (float)m_Max;
    
    glColor4f(1, 0, 0, 1);
    [self fillRectLT:x y:y w:HP_WIDTH h:HP_HEIGHT rot:0 scale:1];
    glColor4f(1, 1, 0, 1);
    [self fillRectLT:x y:y w:HP_WIDTH*ratio h:HP_HEIGHT rot:0 scale:1];
    glLineWidth(1);
    glColor4f(0, 1, 0, 1);
    [self drawRectLT:x y:y w:HP_WIDTH h:HP_HEIGHT rot:0 scale:1];
}

@end
