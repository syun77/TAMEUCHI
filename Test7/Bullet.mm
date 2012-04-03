//
//  Bullet.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Bullet.h"

#import "GameScene.h"
#import "Particle.h"
#import "Exerinya.h"

@implementation Bullet

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_Bullet);
    [self.m_pSprite setTextureRect:r];
    
    return self;
}

- (void)initialize {
    m_Timer = 0;
    [self setRotation:0];
    [self setScale:1];
    
    NSLog(@"Intialize[%d].", [self getIndex]);
}

- (void)update:(ccTime)dt {
    [self move:dt];
    
    m_Timer++;
    
    GameScene* scene = [GameScene sharedInstance];
    
    [self setRotation: self.rotation + 5];
    if (m_Timer > 120) {
        [self setScale: self.scale * 0.95f];
        
        self._vx *= 0.97f;
        self._vy *= 0.97f;
        
        if (m_Timer % 4 < 2) {
            [self setVisible:YES];
        } else {
            [self setVisible:NO];
        }
        
        
    }
    
    if( m_Timer > 160 ) {
        NSLog(@"Vanish[%d].", [self getIndex]);
        [self removeFromParentAndCleanup:YES];
        [self setExist:NO];
        
        float rot = Math_Randf(360);
        for (int i = 0; i < 8; i++) {
            rot += Math_Randf(30) + 15;
            
            Token* t = (Particle*)[scene.mgrParticle add];
            [t set2:self._x y:self._y rot:rot speed:360 ax:0 ay:-5];
        }
        
        return;
        
    }
    
    if ([self isBoundRectX:32]) {
        // 横方向ヒット
        self._vx *= -1;
    }
    
    if ([self isBoundRectY:32]) {
        // 縦方向ヒット
        self._vy *= -1;
    }
    
    //    if ([self isOutRect:32 h:32]) {
    //        
    //        NSLog(@"Vanish[%d].", [self getIndex]);
    //        [self removeFromParentAndCleanup:YES];
    //        [self setExist:NO];
    //        return;
    //    }
}

@end
