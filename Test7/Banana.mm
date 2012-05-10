//
//  Banana.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Banana.h"
#import "Exerinya.h"
#import "GameScene.h"

// 消滅タイマー
static const int TIMER_VANISH = 60;

/**
 * バナナボーナスの実装
 */
@implementation Banana

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_Banana_p1);
    [self.m_pSprite setTextureRect:r];
    
    if (System_IsRetina() == NO) {
        [self setScale:0.5f];
    }
    else {
        [self setScale:1];
    }
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;
    [self setVisible:YES];
    [self setBlend:eBlend_Normal];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    self._vx *= 0.9f;
    self._vy *= 0.9f;
    
    m_Timer++;
    
    if (m_Timer > TIMER_VANISH/2) {
        
        [self setBlend:eBlend_Add];
        
        if (m_Timer%4 < 2) {
            [self setVisible:NO];
        }
        else {
            [self setVisible:YES];
        }
    }
    
    if (m_Timer >= TIMER_VANISH) {
        [self vanish];
    }
}

// 種別の設定
- (void)setId:(eBanana)type {
    m_Id = type;
}

/**
 * バナナボーナスの追加
 */
+(Banana*)add:(eBanana)type x:(float)x y:(float)y {
    GameScene* scene = [GameScene sharedInstance];
    Banana* b = (Banana*)[scene.mgrBanana add];
    if (b) {
        [b set2:x y:y rot:Math_Rand(360) speed:100 ax:0 ay:0];
        [b setId:type];
    }
    
    return b;
}

@end
