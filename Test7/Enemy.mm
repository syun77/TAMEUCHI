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
#import "Item.h"
#import "Shot.h"
#import "Sound.h"
#import "Banana.h"
#import "Bomb.h"

/**
 * 状態
 */
enum eState {
    eState_Appear,  // 出現
    eState_Main,    // メイン
    eState_Escape,  // 逃走
};

/**
 * プレイヤーとの距離
 */
enum eRange {
    eRange_Short,   // 近距離
    eRange_Middle,  // 中距離
    eRange_Long,    // 遠距離
};

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
 * 破壊点を取得する
 */
- (int)getScore {
    switch (m_Id) {
        case eEnemy_Carrot:
        case eEnemy_Radish:
        case eEnemy_Pokey:
            // 小サイズ
            return 30;
            
        case eEnemy_Nasu:
        case eEnemy_5Box:
        case eEnemy_Tako:
            // 通常サイズ
            return 100;
            
        case eEnemy_Milk:
        case eEnemy_XBox:
        case eEnemy_Pudding:
            // 大サイズ
            return 1000;
            
        default:
            return 10;
    }
}

/**
 * 敵の大きさを取得
 */
- (eSize)getSize {
    switch (m_Id) {
        case eEnemy_Carrot:
        case eEnemy_Radish:
        case eEnemy_Pokey:
            // 小サイズ
            return eSize_Small;
            
        case eEnemy_Nasu:
        case eEnemy_5Box:
        case eEnemy_Tako:
            // 通常サイズ
            return eSize_Middle;
            
        case eEnemy_Milk:
        case eEnemy_XBox:
        case eEnemy_Pudding:
            // 大サイズ
            return eSize_Big;
            
        default:
            return eSize_Middle;
    }
}

/**
 * 目標の相手を取得する
 */
- (Player*)getTarget {
    GameScene* scene = [GameScene sharedInstance];
    return scene.player;
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
 * 現在のレベルを取得する
 */
- (int)getLevel {
    LevelMgr* level = [GameScene sharedInstance].levelMgr;
    return [level getLevel];
}

/**
 * プレイヤーとの距離を計算する
 */
- (eRange)getRange {
    
    // プレイヤーとの距離を計算する
    Player* p = [self getTarget];
    
    float dx = p._x - self._x;
    float dy = p._y - self._y;
    
    float distance = Math_Sqrt(dx * dx + dy * dy);
    
    if (distance < 144) {
        
        // 近距離 (√80^2 + 120^2)
        return eRange_Short;
    }
    if (distance < 288) {
        
        // 中距離 (√160^2 + 240^2)
        return eRange_Middle;
    }
    
    // 遠距離
    return eRange_Long;
}

/**
 * 危険な状態かどうか
 * @return 危険な状態であれば「YES」
 */
- (BOOL)isDanger {
    float ratio = (float)m_Hp / m_HpMax;
    
    return ratio < 0.3;
}

/**
 * 初期化
 */
- (void)initialize {
    [self setRotation:0];
    [self setScale:1];
    
    [self setScale:0.5];
    
    [self setSize2:32];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    
    m_tPast = 0;
    m_Val = Math_Rand(360);
    m_Val2 = 0;
    m_Timer = 0;
    m_Hp    = 3;
    m_State = eState_Appear;
    m_bWhip = NO;
    m_Step  = 0;
    m_AimX  = [self getTarget]._x;
    m_AimY  = [self getTarget]._y;
    
}

/**
 * 敵種別の設定
 */
- (void)setType:(eEnemy)type {
    m_Id = type;
    
    switch (type) {
        case eEnemy_Nasu:    // ナス
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Nasu)];
            self._r = 16;
            m_HpMax = 3;
            break;
            
        case eEnemy_Tako:    // たこ焼き
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Tako)];
            self._r = 16;
            m_HpMax = 3;
            break;
            
        case eEnemy_5Box:    // ５箱
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_5Box)];
            self._r = 16;
            m_HpMax = 30;
            break;
            
        case eEnemy_Pudding: // プリン
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pudding)];
            self._r = 48;
            m_HpMax = 50;
            break;
            
        case eEnemy_Milk:    // 牛乳
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Milk)];
            self._r = 48;
            m_HpMax = 50;
            break;
            
        case eEnemy_XBox:    // XBox
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_XBox)];
            self._r = 48;
            m_HpMax = 50;
            break;
            
        case eEnemy_Radish:  // 大根
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Radish)];
            self._r = 8;
            m_HpMax = 3;
            break;
            
        case eEnemy_Carrot:  // 人参
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Carrot)];
            self._r = 8;
            m_HpMax = 3;
            break;
            
        case eEnemy_Pokey2:
            
            // 緑色ポッキー
            [self setColor:ccc3(0xC0, 0xFF, 0xC0)];
            
        case eEnemy_Pokey:   // ポッキー
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pokey)];
            self._r = 8;
            m_HpMax = 3;
            m_Timer = 300;
            break;
            
        default:
            break;
    }
    
    // HPを設定する
    m_Hp = m_HpMax;
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
        if ([e getSize] == eSize_Small) {
            // サイズ・小はロックしない
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
 * 登場時の移動量を設定
 */
- (void)moveAppear:(float)speed radius:(float)radius {
    if ([self isOutCircle:-radius]) {
        // 画面外の場合、画面内に入ろうとする
        float dx = System_CenterX() - self._x;
        float dy = System_CenterY() - self._y;
        if (abs(dx) > abs(dy)) {
            if (dx > 0) {
                self._vx = speed;
            }
            else {
                self._vx = -speed;
            }
        }
        else {
            if (dy > 0) {
                self._vy = speed;
            }
            else {
                self._vy = -speed;
            }
        }
    }
    
}

/**
 * サイズ小
 */
- (void)vanishSmall {
    Particle* p = [Particle add:eParticle_Ring x:self._x y:self._y rot:0 speed:0];
    if (p) {
        [p setScale:0.125];
        [p setAlpha:255];
    }
    
    float rot = 0;
    for (int i = 0; i < 3; i++) {
        rot += Math_RandFloat(30, 60);
        float scale = Math_RandFloat(.1725, .3725);
        float speed = Math_RandFloat(60, 320);
        Particle* p2 = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
        }
    }
    
}

/**
 * 通常サイズの敵の消滅
 */
- (void)vanishNormal {
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
}

/**
 * 巨大サイズ
 */
- (void)vanishBig {
    Particle* p = [Particle add:eParticle_Ring x:self._x y:self._y rot:0 speed:0];
    if (p) {
        [p setScale:2];
        [p setAlpha:0xff];
    }
    
    float rot = 0;
    for (int i = 0; i < 6; i++) {
        rot += Math_RandFloat(30, 60);
        float scale = Math_RandFloat(.75, 1.5);
        float speed = Math_RandFloat(120, 640);
        Particle* p2 = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
        }
    }
    rot = 0;
    for (int i = 0; i < 3; i++) {
        rot += Math_RandFloat(60, 120);
        float scale = Math_RandFloat(1, 2);
        float speed = Math_RandFloat(30, 120);
        float x = self._x + speed * Math_CosEx(rot);
        float y = self._y + speed * -Math_SinEx(rot);
        Particle* p2 = [Particle add:eParticle_Blade x:x y:y rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
            [p2 setRotation:rot];
        }
    }
    
}


/**
 * 更新・ナス
 */
- (void)updateNasu {
    const float speedIn  = 100; // 画面に入る速度
    const float speedMove = 50; // 移動速度
    eRange range = [self getRange]; // プレイヤーとの距離
    
    switch (m_State) {
        case eState_Appear:
            m_Timer++;
            // 登場シーケンス
            [self moveAppear:speedIn radius:self._r];
            if (m_Timer >= 200) {
                m_State = eState_Main;
                m_Timer = 0;
            }
            break;
            
        case eState_Main:
            m_Timer++;
            if (m_Timer%160 < 40) {
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
            
            if ([self getLevel] > 100) {
                
                if ([self getRange] == eRange_Middle) {
                
                    // 中距離のみ、乱射する
                    if (500 < m_Timer && m_Timer < 700) {
                        
                        // 周期
                        int cycle = 30 - [self getLevel] / 100;
                        if (cycle < 5) {
                            cycle = 5;
                        }
                        
                        if (m_Timer%20 == 0) {
                            
                            float speed = [self getLevel];
                            
                            if (speed > 200) {
                                speed = 200;
                            }
                            
                            float rot = [self getAim] + Math_RandInt(-20, 20);
                            [Bullet add:self._x y:self._y rot:rot speed:speed];
                        }
                        
                    }
                }
            }
            
            if ([self getLevel] > 50) {
                
                // レベルが高いときのみ発動
                // 遠距離のみ
                if ([self getRange] == eRange_Long) {
                    float speed = [self getLevel];
                    
                    if (speed > 500) {
                        speed = 500;
                    }
                    
                    if (m_Timer%1000 == 100) {
                        int cnt = 3;
                        for (int i = 0; i < cnt; i++) {
                            float rot = [self getAim] + Math_RandInt(-20, 20);
                            [Bullet add:self._x y:self._y rot:rot speed:speed + i * 20];
                        }
                    }
                }
            }
            
            if (m_Timer%80 == 0) {
                if (range >= eRange_Long) {
                    // 遠距離以上なら近づく
                    float aim = [self getAim];
                    self._vx += Math_CosEx(aim) * speedMove * 5;
                    self._vy += Math_SinEx(aim) * speedMove * 5;
                }
            }
            
            if (m_Timer > 2000) {
                
                // 逃走する
                m_State = eState_Escape;
                m_Timer = 0;
            }
            break;
            
        case eState_Escape:
            
            // 退場シーケンス
            // プレイヤーを逆方向に移動する
        {
            float aim = [self getAim];
            float dx = Math_CosEx(aim) * -speedMove;
            float dy = -Math_SinEx(aim) * -speedMove;
            self._vx = dx;
            self._vy = dy;
        }
            
            if([self isOutCircle:self._r]) {
                // 画面外に出たら消える
                [self vanish];
                return;
            }
            break;
            
        default:
            break;
    }
    
    self._vx *= 0.9f;
    self._vy *= 0.9f;
    
    
    [self setRotation:Math_SinEx(m_Timer + m_Val) * 15];
}

/**
 * 更新・タコ
 */
- (void)updateTako {
    const float speedIn  = 100; // 画面に入る速度
    float speedMove = 300; // 移動速度
    
    speedMove += [self getLevel] * 2;
    if (speedMove > 800) {
        speedMove = 800;
    }
    
    m_Timer++;
    if (m_Timer < 40) {
        // 登場シーケンス
        [self moveAppear:speedIn radius:self._r];
    }
    else if ([self isOutCircle:self._r]) {
        // 画面外に出たら消える
        [self vanish];
        return;
    }
    else if (m_Timer%200 == 0) {
        // 移動シーケンス
        // プレイヤーに向かって移動する
        float aim = [self getAim];
        float dx = Math_CosEx(aim) * speedMove;
        float dy = Math_SinEx(aim) * speedMove;
        self._vx = dx;
        self._vy = dy;
        
    }
    else if(m_Timer%200 > 0) {
        int t = m_Timer%200;
        self.rotation = self.rotation + t * 0.1;
    }
    
    self._vx *= 0.95f;
    self._vy *= 0.95f;
    
}

/**
 * 更新・5箱
 */
- (void)update5Box {
    
    self._vx *= 0.1f;
    self._vy *= 0.1f;
    
    switch (m_State) {
        case eState_Appear:
            
            // 出現開始
            [self setHitEnabled:NO];
            m_Timer++;
            [self setVisible:m_Timer%4 < 2];
            if (m_Timer > 45) {
                m_Timer = 0;
                [self setVisible:YES];
                [self setHitEnabled:YES];
                m_State = eState_Main;
                m_Step = 0;
            }
            break;
            
        case eState_Main:
            
            // メイン
            switch (m_Step) {
                case 0:
                    m_Timer++;
                    m_Val = m_Val * 0.97f;
                    if(m_Val == 0)
                    {
                        // 3Way
                        float aim = [self getAim] - 30;
                        for (int i = 0; i < 3; i++) {
                            [Bullet add:self._x y:self._y rot:aim speed:100];
                            aim += 30;
                        }
                        m_Val = 360 + Math_Rand(720);
                    }
                    
                    
                    if(m_Timer > 320)
                    {
                        m_Val = [self getAim];
                        m_Timer = 0;
                        m_Step = 1;
                    }
                    
                    break;
                    
                case 1:
                    m_Timer++;
                    m_Val += m_Timer / 3;
                    switch (m_Timer) {
                        case 80:
                        case 120:
                        case 160:
                            if ([self getLevel] > 50) {
                            
                                // 16way
                                for (int i = 0; i < 16; i++) {
                                    float rot = i * (360 / 16);
                                    [Bullet add:self._x y:self._y rot:rot speed:200];
                                }
                            }
                            break;
                            
                        default:
                            break;
                    }
                    if (m_Timer > 160) {
                        m_Step++;
                        if (m_Step >= 0) {
                            
                            // 自動消滅
                            [self vanishNormal];
                            [self vanish];
                        }
                        m_Timer = 0;
                        m_State = eState_Appear;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    [self setRotation:m_Val];
}

/**
 * 更新・牛乳
 */
- (void)updateMilk {
    
    const float speedIn  = 100; // 画面に入る速度
    const float speedMove = 150; // 移動速度
    
    switch (m_State) {
        case eState_Appear:
            // 登場シーケンス
            m_Timer++;
            [self moveAppear:speedIn radius:self._r];
            if ([self isOutCircle:-self._r] == NO || m_Timer > 200) {
                m_Timer = 0;
                m_State = eState_Main;
                // プレイヤーに向かって移動する
                float aim = [self getAim];
                float dx = Math_CosEx(aim) * speedMove;
                float dy = -Math_SinEx(aim) * speedMove;
                self._vx = dx;
                self._vy = dy;
            }
            self._vx *= 0.5f;
            self._vy *= 0.5f;
            break;
            
        case eState_Main:
            m_Timer++;
            if (Math_Rand(100) == 0) {
                m_Timer += 10;
            }
            if (m_Timer%180 == 11) {
                // 移動シーケンス
                // プレイヤーから直角に移動する
                float deg1 = Math_RandInt(-1, 1) * 90;
                float deg2 = Math_RandInt(-1, 1) * 90;
                
                float aim = [self getAim];
                float dx = Math_CosEx(aim + deg1) * speedMove;
                float dy = -Math_SinEx(aim + deg2) * speedMove;
                self._vx = dx;
                self._vy = dy;
                
                if ([self getRange] == eRange_Middle) {
                    
                    // にんじん発射
                    float speed = 100 + [self getLevel];
                    if (speed > 250) {
                        speed = 250;
                    }
                    int cnt = 1 + [self getLevel] / 50;
                    if (cnt > 8) {
                        cnt = 8;
                    }
                    
                    float dir = 180;
                    if ([self getLevel] > 100 && Math_Rand(2) == 0) {
                        dir = 0;
                    }
                    
                    float dRot = 225 / cnt;
                    float rot = dir + aim + (cnt / 2) * - dRot;
                    for (int i = 0; i < cnt; i++) {
                        [Enemy add:eEnemy_Carrot x:self._x y:self._y rot:rot speed:speed];
                        rot += 45;
                    }
                }
                else if([self getRange] == eRange_Long) {
                    
                    // だいこん発射
                    float speed = 100 + [self getLevel];
                    if (speed > 250) {
                        speed = 250;
                    }
                    
                    if ([self isDanger]) {
                        // 発狂モード
                        for (int i = 0; i < 8; i++) {
                            [Enemy add:eEnemy_Radish x:self._x y:self._y rot:i * (360/8) speed:speed];
                        }
                    }
                    else {
                        
                        int cnt = 1 + [self getLevel] / 50;
                        if (cnt > 8) {
                            cnt = 8;
                        }
                        float dRot = 60 / cnt;
                        float rot = aim + (cnt / 2) * - dRot;
                        for (int i = 0; i < cnt; i++) {
                            [Enemy add:eEnemy_Radish x:self._x y:self._y rot:rot speed:speed];
                            rot += dRot;
                        }
                    }
                    
                }
            }
            if([self isBoundRectX:self._r])
            {
                self._vx = -self._vx * 0.8;
            }
            if([self isBoundRectY:self._r])
            {
                self._vy = -self._vy * 0.8;
            }
            self._vx *= 0.95f;
            self._vy *= 0.95f;
            break;
            
        default:
            break;
    }
    
    
}

/**
 * 更新・プリン
 */
- (void)updatePudding {
    
    const float speedIn  = 100; // 画面に入る速度
    const float speedMove = 150; // 移動速度
    eRange range = [self getRange]; // プレイヤーとの距離
    
    switch (m_State) {
        case eState_Appear:
            // 登場シーケンス
            m_Timer++;
            [self moveAppear:speedIn radius:self._r];
            if ([self isOutCircle:-self._r] == NO || m_Timer > 200) {
                m_Timer = 0;
                m_State = eState_Main;
                // プレイヤーに向かって移動する
                float aim = [self getAim];
                float dx = Math_CosEx(aim) * speedMove;
                float dy = -Math_SinEx(aim) * speedMove;
                self._vx = dx;
                self._vy = dy;
            }
            self._vx *= 0.5f;
            self._vy *= 0.5f;
            break;
            
        case eState_Main:
            m_Timer++;
            if (m_bWhip) {
                if (m_Val2 > 0) {
                    m_Val2--;
                    
                    [Bullet add:self._x y:self._y rot:m_Val+m_Val2*7 speed:100 + m_Val2 * 1];
                    [Bullet add:self._x y:self._y rot:m_Val-m_Val2*7 speed:100 + m_Val2 * 1];
                    
                    if (m_Val2 < 1) {
                        // ウィップ弾終了
                        m_bWhip = NO;
                    }
                }
            }
            
            if (m_Timer%180 == 11) {
                // 移動シーケンス
                // プレイヤーから直角に移動する
                float deg1 = Math_RandInt(-1, 1) * 90;
                float deg2 = Math_RandInt(-1, 1) * 90;
                
                float aim = [self getAim];
                float dx = Math_CosEx(aim + deg1) * speedMove;
                float dy = -Math_SinEx(aim + deg2) * speedMove;
                self._vx = dx;
                self._vy = dy;
                
                // 弾を打つ
                for (int i = 0 ; i < 3; i++) {
                    [Bullet add:self._x y:self._y rot:aim - 30 + 30 * i speed:100];
                }
                
                if (range == eRange_Long) {
                    // 遠距離
                    if ([self isDanger]) {
                        
                        // ウィップ弾
                        m_Val = [self getAim];
                        m_Val2 = [self getLevel]; // これだけ撃つ
                        if (m_Val2 > 96) {
                            m_Val2 = 96;
                        }
                        m_bWhip = YES;
                    }
                    else {
                        
                        // リング弾
                        float base = 150 + [self getLevel] / 2;
                        if (base > 300) {
                            base = 300;
                        }
                        
                        for (int i = 0; i < 16; i++) {
                            float rot = i * (360 / 16);
                            float x = self._x + Math_CosEx(rot) * 64;
                            float y = self._y + Math_SinEx(rot) * 64;
                            
                            Player* p = [self getTarget];
                            float rot2 = Math_Atan2Ex(p._y - y, p._x - x);
                            
                            [Bullet add:x y:y rot:rot2 speed:base];
                        }
                        
                    }
                }
                else if(range == eRange_Middle) {
                    // 中距離
                    
                    // 緑ポッキーを撃つ
                    if (Math_Rand(10) == 0 && [self getLevel] > 60) {
                        
                        float speed = 400;
                        int cnt = [self getLevel] / 20 - 2;
                        if (cnt > 10) {
                            cnt = 10;
                        }
                        
                        // ランダム方向
                        for (int i = 0; i < cnt; i++) {
                            [Enemy add:eEnemy_Pokey2 x:self._x y:self._y rot:aim + Math_RandInt(-135, 135) speed:speed];
                        }
                    }
                    if (m_Timer%500 == 300) {
                        // プレイヤーから離れようとする
                        float aim = [self getAim] + 180;
                        float dx = Math_CosEx(aim) * speedMove;
                        float dy = -Math_SinEx(aim) * speedMove;
                        self._vx = dx;
                        self._vy = dy;
                    }
                }
                else {
                    // 近距離・ポッキー発射
                    float speed = 400;
                    int cnt = 1 + [self getLevel] / 10;
                    if (cnt > 10) {
                        cnt = 10;
                    }
                    float dRot = 225 / cnt;
                    float rot = 180 + aim + (cnt / 2) * - dRot;
                    for (int i = 0; i < cnt; i++) {
                        [Enemy add:eEnemy_Pokey x:self._x y:self._y rot:rot speed:speed];
                        rot += dRot;
                    }
                    
                }
                
            }
            if([self isBoundRectX:self._r])
            {
                self._vx = -self._vx * 0.8;
            }
            if([self isBoundRectY:self._r])
            {
                self._vy = -self._vy * 0.8;
            }
            self._vx *= 0.95f;
            self._vy *= 0.95f;
            break;
            
        default:
            break;
    }
    
}

/**
 * 更新・XBox
 */
- (void)updateXBox {
    
}

/**
 * 更新・ポッキー
 */
- (void)updatePokey {
    float speed = 100;
    
    speed += [self getLevel] * 2;
    
    if (speed > 400) {
        speed = 400;
    }
    
    switch (m_State) {
        case eState_Appear:
            // 出現
            m_Timer = m_Timer * 0.97;
            self._vx *= 0.9f;
            self._vy *= 0.9f;
            [self setRotation:m_Timer*4];
            
            if (m_Timer == 0) {
                // 自機に向かって飛ぶ
                m_State = eState_Main;
                float aim = [self getAim];
                
                float dx = Math_CosEx(aim) * speed;
                float dy = Math_SinEx(aim) * speed;
                
                self._vx = dx;
                self._vy = dy;
                
                [self setRotation:Math_Atan2Ex(-dy, dx)];
            }
            break;
            
        default:
            break;
    }
    
    if ([self isOutCircle:self._r]) {
        // 画面外に出たら消える
        [self vanish];
    }
}

/**
 * 更新・ポッキー2 (砲台)
 */
- (void)updatePokey2 {
    float speed = 50;
    
    speed += [self getLevel];
    
    if (speed > 200) {
        speed = 200;
    }
    
    switch (m_State) {
        case eState_Appear:
            // 出現
            m_Timer = m_Timer * 0.97;
            self._vx *= 0.8f;
            self._vy *= 0.8f;
            [self setRotation:m_Timer*4];
            
            if (m_Timer == 0) {
                
                // 自機に向かって弾を打ち続ける
                m_State = eState_Main;
                m_Timer = 200;
                m_Val = [self getAim] + 30 * Math_RandInt(-1, 1);
                if ([self getLevel] < 50) {
                    m_Val2 = 1;
                }
                else if([self getLevel] < 100) {
                    m_Val2 = 2;
                }
                else {
                    m_Val2 = 3;
                }
            }
            break;
            
        case eState_Main:
            m_Timer = m_Timer * 0.97;
            [self setRotation:m_Timer*4];
            if (m_Timer > 50 && m_Timer%16 == 1) {
                
                [Bullet add:self._x y:self._y rot:m_Val speed:speed];
            } 
            
            if (m_Timer == 0) {
                
                // 自機に向かって弾を打ち続ける
                m_State = eState_Main;
                m_Timer = 200;
                m_Val = [self getAim] + 15 * Math_RandInt(-1, 1);
                
                m_Val2--;
                if (m_Val2 < 1) {
                    
                    // 一定回数で自動消滅する
                    [self vanishSmall];
                    [self vanish];
                }
            }
            
            break;
            
        default:
            break;
    }
    
    if ([self isOutCircle:self._r]) {
        // 画面外に出たら消える
        [self vanish];
    }
}
/**
 * 更新・だいこん
 */
- (void)updateRadish {
    
    // 移動方向に合わせて回転
    float rot = Math_Atan2Ex(-self._vy, self._vx);
    
    [self setRotation:rot];
    
    if ([self isOutRectX:-self._r]) {
        self._vx = -self._vx;
        m_Val2++;
    }
    if ([self isOutRectY:-self._r]) {
        self._vy = -self._vy;
        m_Val2++;
    }
    
    m_Timer++;
    if (m_Timer > 200 || m_Val2 >= 3) {
        
        // 一定時間経過・３回跳ね返りで消える
        [self vanishSmall];
        [self vanish];
    }
}

/**
 * 更新・にんじん
 */
- (void)updateCarrot {
   
    m_Timer++;
    if (m_Timer > 200) {
        m_Val2 = 0;
    }
    if (m_Val2 == 0) {
        Vec2D v = Vec2D(self._vx, self._vy);
        float rot = v.Rot();
        float aim = Math_Atan2Ex(m_AimY-self._y, m_AimX-self._x);;
        
        const float SPEED_ROT = 3;
        float dRot = Math_GetNearestRot(aim, rot);
        if (abs(dRot) > SPEED_ROT) {
            float next = rot;
            if (dRot > 0) {
                next += SPEED_ROT;
            }
            else {
                next -= SPEED_ROT;
            }
            float speed = v.Length();
            self._vx = speed * Math_CosEx(next);
            self._vy = speed * Math_SinEx(next);
        }
        else {
            m_Val2 = 1;
        }
    }
    
    if ([self isOutCircle:self._r]) {
        // 画面外に出たら消える
        [self vanish];
    }
    
    [self setRotation:Math_Atan2Ex(-self._vy, self._vx)];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    m_tPast++;
    
    Player* player = [GameScene sharedInstance].player;
    if ([player isDanger]) {
        // スローモード
        dt *= DANGER_SLOW_RATIO;
    }
    
    [self move:dt];
    
    switch (m_Id) {
        case eEnemy_Nasu:
            [self updateNasu];
            break;
            
        case eEnemy_Tako:
            [self updateTako];
            break;
            
        case eEnemy_5Box:
            [self update5Box];
            break;
            
        case eEnemy_Milk:
            [self updateMilk];
            break;
            
        case eEnemy_Pudding:
            [self updatePudding];
            break;
            
        case eEnemy_XBox:
            [self updateXBox];
            break;
            
        case eEnemy_Pokey:
            [self updatePokey];
            break;
        
        case eEnemy_Pokey2:
            [self updatePokey2];
            break;
            
        case eEnemy_Carrot:
            [self updateCarrot];
            break;
            
        case eEnemy_Radish:
            [self updateRadish];
            break;
            
        default:
            break;
    }
    
    if ([self isDanger]) {
        if (m_tPast%60 < 5) {
            [self setColor:ccc3(0xFF, 0, 0)];
        }
        else {
            [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
        }
    }
}

/**
 * 破壊
 */
- (void)destroy {
    
    // エフェクトの生成
    switch ([self getSize]) {
        case eSize_Small:
            // 小サイズ
            [self vanishSmall];
            break;
            
        case eSize_Middle:
            // 通常サイズ
            [self vanishNormal];
            
            if (m_Id == eEnemy_5Box) {
                // 5箱は爆発する
                
                [Bomb add:80 x:self._x y:self._y];
            }
            
            // チャージゲージ回復アイテム出現
            [Item add:eItem_Score x:self._x y:self._y rot:90 speed:25];
            break;
            
        case eSize_Big:
            // 大サイズ
            [self vanishBig];
            // 体力回復アイテム出現
            [Item add:eItem_Recover x:self._x y:self._y rot:90 speed:50];
            break;
            
        default:
            break;
    }
    [self vanish];
}

/**
 * 弾がヒットした
 */
- (BOOL)hit:(float)dx y:(float)dy {
    
    m_Hp--;
    
    // 反動
    Vec2D v = Vec2D(dx, dy);
    v.Normalize();
    switch ([self getSize]) {
        case eSize_Small:
            v *= 0;
            break;
        
        case eSize_Middle:
            v *= 20;
            break;
            
        default:
            v *= 5;
            break;
    }
    self._vx += v.x;
    self._vy += v.y;
    
    if (m_Hp <= 0) {
        
        // 破壊演出
        [self destroy];
        
        // 中ボスなら弾消し -> バナナボーナス
        if ([self getSize] == eSize_Big) {
            [Bullet vanishAll:eBulletVanish_Banana];
            [Enemy vanishAllSmall:eEnemyVanish_Banana];
        }
        
        return YES;
    }
    
    // まだ生きている
    return NO;
}


// 残りHPの割合を取得(0〜1)
- (float)getHpRatio {
    return (float)m_Hp / (float)m_HpMax;
}

- (void)visit {
    [super visit];
    
    switch (m_Id) {
        case eEnemy_Milk:
        case eEnemy_Pudding:
        case eEnemy_XBox:
            // バリアの描画
            if ([self getHpRatio] > 0.3f) {
                glLineWidth(1);
                for (int i = 0; i < 2; i++) {
                    glColor4f(Math_Randf(0.5), 1, Math_Randf(0.5), 1);
                    [self drawCircle:self._x cy:self._y radius:self._r + 8 + Math_Randf(2)];
                }
            }
            break;
            
        default:
            break;
    }
}

/**
 * サイズ・小をすべて消す
 */
+ (void)vanishAllSmall:(eEnemyVanish)type {
    
    GameScene* scene = [GameScene sharedInstance];
    TokenManager* mgr = scene.mgrEnemy;
    for (Enemy* e in mgr.m_Pool) {
        if ([e isExist] == NO) {
            continue;
        }
        
        if ([e getSize] != eSize_Small) {
            continue;
        }
        
        [e destroy];
        
        float rot = Math_Atan2Ex(e._vy, e._vx);
        switch (type) {
            case eEnemyVanish_Banana:
                // バナナボーナス発生
                [scene addScore: SCORE_BANANA_BONUS];
                [Banana add:eBanana_Normal x:e._x y:e._y];
                break;
                
            case eEnemyVanish_Reflect:
                // 打ち返しあり
                [Shot add:eShot_Power x:e._x y:e._y rot:rot+180 speed:100];
                break;
                
            case eEnemyVanish_Normal:
            default:
                break;
        }
    } 
}
@end
