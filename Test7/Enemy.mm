//
//  Enemy.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Enemy.h"

#import "Exerinya.h"
#import "GameScene.h"
#import "Particle.h"
#import "Bullet.h"


/**
 * 敵の実装
 */
@implementation Enemy

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    return self;
    
}

/**
 * 初期化
 */
- (void)initialize {
    [self setRotation:0];
    [self setScale:1];
    
    [self setScale:0.5];
    
    [self setSize2:32];
    
    m_Val = Math_Rand(360);
    m_Timer = 0;
    m_Hp    = 3;
    
}

/**
 * 目標の相手を取得する
 */
- (Player*)getTarget {
    GameScene* scene = [GameScene sharedInstance];
    return scene.player;
}

/**
 * 敵種別の設定
 */
- (void)setType:(eEnemy)type {
    switch (type) {
        case eEnemy_Nasu:    // ナス
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Nasu)];
            break;
            
        case eEnemy_Tako:    // たこ焼き
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Tako)];
            break;
            
        case eEnemy_5Box:    // ５箱
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_5Box)];
            break;
            
        case eEnemy_Pudding: // プリン
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pudding)];
            break;
            
        case eEnemy_Milk:    // 牛乳
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Milk)];
            break;
            
        case eEnemy_XBox:    // XBox
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_XBox)];
            break;
            
        case eEnemy_Radish:  // 大根
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Radish)];
            break;
            
        case eEnemy_Carrot:  // 人参
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Carrot)];
            break;
            
        case eEnemy_Pokey:   // ポッキー
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pokey)];
            break;
            
        default:
            break;
    }
}

/**
 * 敵の生成
 */

+ (Enemy*)add:(eEnemy)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    GameScene* scene = [GameScene sharedInstance];
    Enemy* e = (Enemy*)[scene.mgrEnemy add];
    if (e) {
        [e set2:x y:y rot:rot speed:speed ax:0 ay:0];
        [e setType:type];
    }
    
    return e;
}

/**
 * 狙い撃ち角度を取得する
 */
- (float)getAim {
    Player* p = [self getTarget];
    
    float dx = p._x - self._x;
    float dy = p._y - self._y;
    
    return Math_Atan2Ex(dy, dx);
}

/**
 * 指定の座標に一番近い敵を探す
 */
+ (Enemy*)getNearest:(float)x y:(float)y {
    Enemy* ret = nil;
    
    GameScene* scene = [GameScene sharedInstance];
    TokenManager* mgr = scene.mgrEnemy;
    
    float len = 9999999;
    for (Enemy* e in mgr.m_Pool) {
        if ([e isExist] == NO) {
            // 存在しない
            continue;
        }
        
        if ([e isOutCircle:0]) {
            // 画面外の敵は昇順をあわせない
            continue;
        }
        
        Vec2D d = Vec2D(e._x - x, e._y - y);
        float len2 = d.LengthSq();
        if (len2 < len) {
            ret = e;
            len = len2;
        }
    }
    
    return ret;
}

/**
 * 更新・ナス
 */
- (void)updateNasu {
    const float speedIn  = 100; // 画面に入る速度
    const float speedMove = 50; // 移動速度
    m_Timer++;
    if (m_Timer < 100) {
        // 登場シーケンス
        if ([self isOutCircle:-self._r]) {
            // 画面外の場合、画面内に入ろうとする
            float dx = System_CenterX() - self._x;
            float dy = System_CenterY() - self._y;
            if (abs(dx) > abs(dy)) {
                if (dx > 0) {
                    self._vx = speedIn;
                }
                else {
                    self._vx = -speedIn;
                }
            }
            else {
                if (dy > 0) {
                    self._vy = speedIn;
                }
                else {
                    self._vy = -speedIn;
                }
            }
        }
    }
    else if ([self isOutCircle:self._r]) {
        // 画面外に出たら消える
        [self vanish];
        return;
    }
    else if (m_Timer > 2000) {
        // 退場シーケンス
        float aim = [self getAim];
        float dx = Math_CosEx(aim) * -speedMove;
        float dy = -Math_SinEx(aim) * -speedMove;
        self._vx = dx;
        self._vy = dy;
    }
    else if (m_Timer%320 < 160) {
        // 移動シーケンス
        float dx = Math_CosEx(m_Timer) * speedMove;
        float dy = Math_SinEx(m_Timer) * speedMove;
        self._vx = dx;
        self._vy = dy;
        if (m_Timer%320 == 10) {
            // 弾を打つ
            float rot = [self getAim];
            [Bullet add:self._x y:self._y rot:rot speed:100];
        }
        
    }
    
    Vec2D v = Vec2D(self._vx, self._vy);
    [self setRotation:Math_SinEx(m_Timer + m_Val) * 15];
}

/**
 * 更新・タコ
 */
- (void)updateTako {
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    self._vx *= 0.9f;
    self._vy *= 0.9f;
    
    switch (m_Id) {
        case eEnemy_Nasu:
            [self updateNasu];
            break;
            
        default:
            break;
    }
    
    if (m_Timer > 100) {
    }
}

/**
 * 弾がヒットした
 */
- (BOOL)hit:(float)dx y:(float)dy {
    m_Hp--;
    
    Vec2D v = Vec2D(dx, dy);
    v.Normalize();
    v *= 20;
    self._vx += v.x;
    self._vy += v.y;
    
    if (m_Hp <= 0) {
        
        // エフェクトの生成
        Particle* p = [Particle add:eParticle_Ring x:self._x y:self._y rot:0 speed:0];
        if (p) {
            [p setScale:0.25];
            [p setAlpha:255];
        }
        
        float rot = 0;
        for (int i = 0; i < 6; i++) {
            rot += Math_RandFloat(30, 60);
            float scale = Math_RandFloat(.35, .75);
            float speed = Math_RandFloat(120, 640);
            Particle* p2 = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:speed];
            if (p2) {
                [p2 setScale:scale];
            }
        }
        [self vanish];
    }
    
    return YES;
}
@end
