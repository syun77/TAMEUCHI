//
//  Particle.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Particle.h"
#import "Exerinya.h"

@implementation Particle

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

- (void)initialize {
    m_Timer = 0;    
    [self setVisible:YES];
    
    NSLog(@"initialize[%d].", [self getIndex]);
}

- (void)update:(ccTime)dt {
    [self move:dt];
    
    m_Timer++;
    
    self._vx *= 0.95f;
    self._vy *= 0.95f;
    
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
        
        [self removeFromParentAndCleanup:YES];
        [self setExist:NO];
    }
}

@end

