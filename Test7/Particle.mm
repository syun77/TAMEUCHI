//
//  Particle.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Particle.h"
#import "Exerinya.h"
#import "GameScene.h"

// 消滅用のタイマー
static const int TIMER_VANISH = 48;

@implementation Particle

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self setScale:0.5];
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall);
    [self.m_pSprite setTextureRect:r];
    
    [self setBlend:eBlend_Add];
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;    
    m_bBlink = NO;
    [self setVisible:YES];
    [self setAlpha:255];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    self._vx *= 0.95f;
    self._vy *= 0.95f;
    
    switch (m_Type) {
        case eParticle_Ball:
            // 縮小する
            m_Timer++;
            
            self.scale = self.scale * 0.9f;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.97f];
            
            break;
        case eParticle_Ring:
            // 拡大する
            m_Timer++;
            
            m_Val *= 0.97f;
            self.scale = self.scale + m_Val;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.95f];
            
        case eParticle_Blade:
            // 縮小する
            m_Timer++;
            
            self.scale = self.scale * 0.9f;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.97f];
            break;
            
        default:
            break;
    }
    
    if (m_Timer > TIMER_VANISH) {
        // 普通に消す
        [self vanish];
    }
    
    if (m_bBlink) {
        // 点滅して消す
        if (m_Timer > 32) {
            if (m_Timer % 4 < 2) {
                [self setVisible:YES];
            } else {
                [self setVisible:NO];
            }
        }
        
        if (m_Timer > 64) {
            
            // 消滅
            NSLog(@"vanish[%d]", [self getIndex]);
            
            [self vanish];
        }
    }
}

/**
 * プリミティブ描画
 */
- (void)visit {
    [super visit];
    
    switch (m_Type) {
        case eParticle_ChargeRecover:
        {
            // チャージ回復エフェクト
            float ratio = (float)(TIMER_VANISH - m_Timer) / TIMER_VANISH;
            
            float val = ratio * TIMER_VANISH * 0.2f;
            if (val < 1) {
                val = 1;
            }
            m_Timer += val;
            
            Player* player = [GameScene sharedInstance].player;
            float pRatio = [player getPowerRatio];
            float r = pRatio;
            float g = 1.0 - pRatio;
            float a = ratio;
            // チャージ回復エフェクト
            System_SetBlend(eBlend_Add);
            glColor4f(r, g, 0, a);
            glLineWidth(4);
            [self drawCircle:self._x cy:self._y radius:m_Timer];
            System_SetBlend(eBlend_Normal);
        }
            break;
            
        case eParticle_ChargeRecoverSmall:
        {
            // チャージ回復エフェクト
            float ratio = (float)(TIMER_VANISH - m_Timer) / TIMER_VANISH;
            
            float val = ratio * TIMER_VANISH * 0.5f;
            if (val < 1) {
                val = 1;
            }
            m_Timer += val;
            
            Player* player = [GameScene sharedInstance].player;
            float pRatio = [player getPowerRatio];
            float r = pRatio;
            float g = 1.0 - pRatio;
            float a = ratio;
            // チャージ回復エフェクト
            System_SetBlend(eBlend_Add);
            glColor4f(r, g, 0, a);
            glLineWidth(4);
            [self drawCircle:self._x cy:self._y radius:m_Timer/4];
            System_SetBlend(eBlend_Normal);        }
            break;
            
        default:
            break;
    }
}

/**
 * 種別の設定
 */
- (void)setType:(eParticle)type {
    
    [self.m_pSprite setVisible:YES];
    
    m_Type = type;
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall); 
    switch (m_Type) {
        case eParticle_Ball:
            r = Exerinya_GetRect(eExerinyaRect_EftBall);
            break;
            
        case eParticle_Ring:
            r = Exerinya_GetRect(eExerinyaRect_EftRing);
            m_Val = 0.1;
            break;
            
        case eParticle_Blade:
            r = Exerinya_GetRect(eExerinyaRect_EftBlade);
            break;
            
        case eParticle_ChargeRecover:
        case eParticle_ChargeRecoverSmall:
            [self.m_pSprite setVisible:NO];
            break;
            
        default:
            break;
    }
    
    [self setTexRect:r];
}

/**
 * 要素の追加
 */
+ (Particle*)add:(eParticle)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    
    GameScene* scene = [GameScene sharedInstance];
    Particle* p = (Particle*)[scene.mgrParticle add];
    if (p) {
        [p set2:x y:y rot:rot speed:speed ax:0 ay:0];
        [p setType:type];
    }
    
    return p;
}

@end

