//
//  Shot.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Shot.h"

#import "GameScene.h"
#import "Particle.h"
#import "Exerinya.h"

/**
 * 自弾の実装
 */
@implementation Shot

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all-hd.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_Bullet);
    [self.m_pSprite setTextureRect:r];
    
    if (System_IsRetina() == NO) {
        [self setScale:0.5f];
    }
    
    [self setColor:ccc3(0x80, 0x80, 0xFF)];
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    if ([super isOutCircle:32]) {
        [self removeFromParentAndCleanup:YES];
        [self setExist:NO];
        return;
    }
    
    m_Timer++;
    if (m_Timer > 120) {
        [self removeFromParentAndCleanup:YES];
        [self setExist:NO];
    }
}

@end
