//
//  Lockon.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/06/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Lockon.h"
#import "Math.h"

static const int TIMER_APPEAR = 30;

enum eState {
    eState_Standby,
    eState_Appear,
    eState_Main,
};

/**
 * ロックオン表示の実装
 */
@implementation Lockon

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    [self setVisible:NO];
    
    m_State = eState_Standby;
    m_Timer = 0;
    m_Id    = -1;
    m_tPast = 0;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    
    if (m_Timer > 0) {
        m_Timer = m_Timer * 0.95;
    }
}

- (void)visit {
    [super visit];
    
    if (m_State == eState_Standby) {
        return;
    }
    
    if (m_tPast%8 < 4) {
        System_SetBlend(eBlend_Add);
    }
    
    glColor4f(0.8, 0.8, 0, 0.5);
    float r = self._r + 16 + 24 * m_Timer / TIMER_APPEAR;
    if (m_Timer > 0) {
        
        glLineWidth(1);
        [self drawCircle:self._x cy:self._y radius:r];
    }
    
    for (int i = 0; i < 4; i++) {
        
        float rot = 45 + 90 * i + m_tPast * 4;
        
        float px = self._x + r * Math_CosEx(rot);
        float py = self._y + r * -Math_SinEx(rot);
        
        [self fillTriangle:px cy:py radius:8 rot:rot+180 scale:1];
    }
    System_SetBlend(eBlend_Normal);
}

- (void)start:(float)idx x:(float)x y:(float)y r:(float)r {
    
    if (m_Id != idx) {
        m_Timer = TIMER_APPEAR;
    }
    
    m_Id = idx;
    self._x = x;
    self._y = y;
    self._r = r;
    
    if (m_State == eState_Standby) {
        m_State = eState_Appear;
        m_Timer = TIMER_APPEAR;
    }
}

- (void)end {
    m_State = eState_Standby;
    m_Id = -1;
}

@end
