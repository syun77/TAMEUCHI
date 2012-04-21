//
//  Charge.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Charge.h"
#import "Exerinya.h"
#import "Math.h"

@implementation Charge

// コンストラクタ
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    [self load:@"all.png"];
    
    [super create];
    
    m_Timer = 0;
    m_State = eCharge_Disable;
    [self setParam:eCharge_Disable x:System_CenterX() y:System_CenterY()];
    
    // エフェクト描画設定
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftRing);
    [self setTexRect:r];
    
    [self setBlend:eBlend_Add];
    [self setColor:ccc3(0xFF, 0xFF, 0x00)];
    
    return self;
}

// 更新
- (void)update:(ccTime)dt {
    switch (m_State) {
        case eCharge_Disable:
            break;
            
        case eCharge_Wait:
            self.scale = Math_RandFloat(0.8, 1.0);
            [self setAlpha:96];
            
            break;
            
        case eCharge_Playing:
            m_Timer++;
        {
            float time = (m_Timer % 30) / 30.0f;
            
            // 拡縮値設定
            self.scale = (1.0f - time) * 1.5f;
            
            // α値設定
            [self setAlpha:64 + time*192];
        }
            break;
            
        default:
            break;
    }
    
    [self move:dt];
}

// パラメータ設定
- (void)setParam:(eCharge)state x:(float)x y:(float)y {

    
    if (state != m_State) {
        m_Timer = 0;
    }
    m_State = state;
    self._x = x;
    self._y = y;
    
    switch (state) {
        case eCharge_Disable:
            [self setVisible:NO];
            break;
        
        case eCharge_Wait:
            [self setVisible:YES];
            break;
            
        case eCharge_Playing:
            [self setVisible:YES];
            break;
            
        default:
            break;
    }
}

@end
