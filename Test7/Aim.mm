//
//  Aim.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
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
    [self load:@"all-hd.png"];
    
    [self create];
    
    [self setTargetDirect:System_CenterX() y:SYstem_CenterY()];
    m_tPast = 0;
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftRing);
    [self setTexRect:r];
    
    [self setBlend:eBlend_Add];
    [self setColor:ccc3(0x00, 0xFF, 0x00)];
    
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

// 移動目標座標の取得
- (Vec2D*)getTarget {
    return &m_Target;
}

// 更新
- (void)update:(ccTime)dt {
    m_tPast++;
    [self move:dt];
    
    Vec2D d = Vec2D(m_Target.x - self._x, m_Target.y - self._y);
    d *= .05f;
    if (d.LengthSq() < 20) {
        d *= 2.0f;
    }
    self._x += d.x;
    self._y += d.y;
    
    float scale = 0.25f + (float)(0.25f * (m_tPast%30) / 30);
    [self setScale:scale];
}

@end
