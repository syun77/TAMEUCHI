//
//  Aim.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/13.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Aim.h"
#import "Exerinya.h"

@implementation Aim

// コンストラクタ
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    [self load:@"all.png"];
    
    [self create];
    
    [self setTargetDirect:System_CenterX()+1 y:System_CenterY()];
    m_tPast = 0;
    m_tRot = 0;
    m_bActive = YES;
    
    // 照準の半径
    self._r = 48;
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftRing);
    [self setTexRect:r];
    
    [self setBlend:eBlend_Add];
    
    return self;
}


// 移動座標を強制的に設定する
- (void)setTargetDirect:(float)x y:(float)y {
    [self setTarget:x y:y];
    self._x = x;
    self._y = y;
}

// 移動目標座標の設定
- (void)setTarget:(float)x y:(float)y {
    m_Target.Set(x, y);
}

// 動作フラグを設定する
- (void)setActive:(BOOL)b {
    m_bActive = b;
}

// 動作フラグを取得する
- (BOOL)isActive {
    return m_bActive;
}

// 移動目標座標の取得
- (Vec2D*)getTarget {
    return &m_Target;
}

// 更新
- (void)update:(ccTime)dt {
    m_tPast++;
    m_tRot++;
    if (m_bActive) {
        m_tRot++;
    }
    [self move:dt];
    
    // ターゲットに向かって移動する
    Vec2D d = Vec2D(m_Target.x - self._x, m_Target.y - self._y);
    d *= .09f;
    if (d.LengthSq() < 20) {
        d *= 2.0f;
    }
    self._x += d.x;
    self._y += d.y;
    
    float scale = 0.25f + (float)(0.25f * (m_tPast%30) / 30);
    [self setScale:scale];
}

/**
 * 照準の描画
 */
- (void)visit {
    
    
    // 色の指定
    if ([self isActive]) {
        // 加算ブレンド有効
        System_SetBlend(eBlend_Normal);
        
        glColor4f(Math_SinEx((m_tPast*4)%180), 1, 0, 1);
    }
    else {
        // 反転ブレンド有効 
        System_SetBlend(eBlend_XOR);
        glColor4f(0, 0, 1, 0.5);
    }
    
    // 円の描画
    const float radius = self._r - 4;
    
    glLineWidth(2);
    [self drawCircle:self._x cy:self._y radius:radius-4];
    [self drawCircle:self._x cy:self._y radius:radius+4];
    
    // 回る矩形の描画
    const float w = 4;
    const float h = 4;
    for (int i = 0; i < 8; i++) {
        float rot = i * 360 / 8 + m_tRot * 2;
        float cx = self._x + radius * Math_CosEx(rot);
        float cy = self._y - radius * Math_SinEx(rot);
        
        if ([self isActive]) {
            [self fillRect:cx cy:cy w:w h:h rot:0 scale:1];        
        }
        else {
            [self drawRect:cx cy:cy w:w h:h rot:0 scale:1];        
            
        }
    }
    
    // 通常のブレンドモードに戻す
    System_SetBlend(eBlend_Normal);
}

@end
