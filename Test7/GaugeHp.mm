//
//  GaugeHp.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GaugeHp.h"

static const int OFFSET_Y = 64;

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
    
    return self;
}

// 初期化
- (void)initialize:(int)max {
    m_Max = max;
}

// 現在値を設定
- (void)set:(int)v x:(float)x y:(float)y {
    self._x = x;
    self._y = y;
    
    [self move:0];
}

// 現在値を取得
- (int)getNow {
    return m_Now;
}

// ゲージ描画
- (void)visit {
    float x = self._x;
    float y = self._y;
    
    y += OFFSET_Y;
    
    [self drawCircle:x cy:y radius:10];
}

@end
