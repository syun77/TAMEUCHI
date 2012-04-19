//
//  Player.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Player.h"

#import "GameScene.h"

#include "Vec.h"
#import "Exerinya.h"
#import "Enemy.h"
#import "Shot.h"
#import "Aim.h"
#import "Charge.h"
#import "Gauge.h"
#import "GaugeHp.h"

// ダメージタイマー
static const int TIMER_DAMAGE = 30;

// ダメージ時の移動量
static const float SPEED_DAMAGE = 200;
static const float DECAY_DAMAGE = 0.95f; // 移動量の減衰値 

// 弾の移動量
static const float SPEED_SHOT = 360;

// チャージが有効となる開始時間
static const int TIMER_CHARGE_START = 60;

// チャージ最大量
static const int MAX_POWER = 120;

// HPの最大
static const int MAX_HP = 100;


/**
 * 状態
 */
enum eState {
    eState_Standby, // 待機
    eState_Damage,  // ダメージ
};

/**
 * 自機クラスを実装する
 */
@implementation Player

/**
 * 照準を取得
 */
- (Aim*)getAim {
    GameScene* scene = [GameScene sharedInstance];
    return scene.aim;
}

/**
 * チャージエフェクトを取得
 */
- (Charge*)getCharge {
    GameScene* scene = [GameScene sharedInstance];
    return scene.charge;
}

/**
 * ゲージ描画オブジェクトを取得する
 */
- (Gauge*)getGauge {
    GameScene* scene = [GameScene sharedInstance];
    return scene.gauge;
}

/**
 * HPゲージ描画オブジェクトを取得する
 */
- (GaugeHp*)getGaugeHp {
    GameScene* scene = [GameScene sharedInstance];
    return scene.gaugeHp;
}

/**
 * 初期化
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all-hd.png"];
    
    [self create];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    m_Target.Set(self._x, self._y);
    
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    [self setScale:0.5f];
    [self setSize2:32];
    
    m_State = eState_Standby;
    m_Timer = 0;
    m_tPast = 0;
    m_tShot = 0;
    m_tDamage = 0;
    m_tPower = 0;
    
    return self;
}

// 開始
- (void)initialize {
   
    // HP初期化
    m_Hp = MAX_HP;
    
    Gauge* gauge = [self getGauge];
    [gauge initialize:MAX_POWER];
    
    GaugeHp* gaugeHp = [self getGaugeHp];
    [gaugeHp initialize:MAX_HP];
}

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y {
    
    m_Start.x = self._x;
    m_Start.y = self._y;
    
    if (m_State == eState_Damage) {
        
        // ダメージ中だったら待機状態に戻す
        m_State = eState_Standby;
    }
}

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y {
    m_tPower -= TIMER_CHARGE_START;
    if (m_tPower < 0) {
        m_tPower = 0;
    }
}

/**
 * 移動量を画面内に収める
 */
- (void)clipScreen:(Vec2D*)v {
    
    float s = self._r;
    float x1 = s;
    float y1 = s;
    float x2 = System_Width() - s;
    float y2 = System_Height() - s;
    
    if (v->x < x1) {
        v->x = x1;
    }
    if (v->x > x2) {
        v->x = x2;
    }
    if (v->y < y1) {
        v->y = y1;
    }
    if (v->y > y2) {
        v->y = y2;
    }
    
}

/**
 * タッチしているかどうか
 */
- (BOOL)isTouch {
    GameScene* scene = [GameScene sharedInstance];
    return [scene.interfaceLayer isTouch];
}

/**
 * 弾を撃つ
 */
- (void)checkShot {
    if ([self isTouch] == NO) {
        // タッチしていない
        // 一番近い敵を探す
        Aim* aim = [self getAim];
        Enemy* e = [Enemy getNearest:aim._x y:aim._y];
        if (e) {
            [aim setTarget:e._x y:e._y];
        }

        // ショットタイマー更新
        if (m_tShot > 0) {
            m_tShot--;
        }
        if (m_tShot <= 0) {
            // 弾を撃つ
            [self shot];
            if (m_tPower > 0) {
                m_tPower--;
            }
            else {
                // パワー切れ
                m_tShot = SHOT_TIMER;
            }
        }
    }
    else {
        m_tShot = 0;
        
        // パワーをためる
        m_tPower++;
        if (m_tPower > MAX_POWER + TIMER_CHARGE_START) {
            m_tPower = MAX_POWER + TIMER_CHARGE_START;
        }
    }
}

/**
 * 入力インターフェース受け取り
 */
- (InterfaceLayer*)getInterfaceLayer {
    GameScene* scene = [GameScene sharedInstance];
    return scene.interfaceLayer;
}

/**
 * 更新・待機中
 */
- (void)updateStandby:(ccTime)dt {
   
    // HP 回復
    m_Hp++;
    if (m_Hp > MAX_HP) {
        m_Hp = MAX_HP;
    }
    
    // 弾を撃つ
    [self checkShot];
    
    Aim* aim = [self getAim];
    Charge* charge = [self getCharge];
    
    // 移動処理
    if ([self isTouch]) {
        // タッチ中
        InterfaceLayer* input = [self getInterfaceLayer];
        // 移動処理
        float startX = [input startX];
        float startY = [input startY];
        float nowX = [input getPosX];
        float nowY = [input getPosY];
        // 相対で移動する
        float dx = nowX - startX;
        float dy = nowY - startY;
        Vec2D v = Vec2D(m_Start.x + dx, m_Start.y + dy);
        [self clipScreen:&v];
        m_Target.Set(v.x, v.y);
        
        // 照準の動作フラグを設定
        [aim setActive:NO];
        
        // 照準も移動する
        [aim setTarget:[input getPosX] y:[input getPosY]];
        
        // チャージエフェクト有効
        if (m_tPower > TIMER_CHARGE_START) {
            
            [charge setParam:eCharge_Playing x:self._x y:self._y];
        }
        else {
            
            [charge setParam:eCharge_Wait x:self._x y:self._y];
        }
        
    }
    else {
        [aim setActive:YES];
        [charge setVisible:NO];
    }
    
    Vec2D vP = Vec2D(self._x, self._y);
    Vec2D vM = m_Target - vP;
    vM *= 10.0f;
    
    self._x += vM.x * dt;
    self._y += vM.y * dt;
    
}

/**
 * 更新・ダメージ中
 */
- (void)updateDamage:(ccTime)dt {
    m_Timer--;
    if (m_Timer < 1) {
        // ダメージ状態終了
        m_State = eState_Standby;
        
        // 移動先を更新
        m_Target.Set(self._x, self._y);
        
        // タッチ開始座標をリセットする
        InterfaceLayer* input = [self getInterfaceLayer];
        [input resetStartPos];
        m_Start.Set(self._x, self._y);
    }
    
}

/**
 * 更新・アニメ
 */
- (void)updateAnime {
    // アニメーション更新
    if (m_tPast%64 / 32) {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    }
    else {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player2)];
    }
    
    if (m_tDamage > 0) {
        // ダメージ中画像
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_PlayerDamage)];
    }
    
}

/**
 * ゲージ更新
 */
- (void)updateGauge {
    Gauge* gauge = [self getGauge];
    
    [gauge set:m_tPower - TIMER_CHARGE_START x:self._x y:self._y];
    
    GaugeHp* gaugeHp = [self getGaugeHp];
    [gaugeHp set:m_Hp x:self._x y:self._y];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // タイマー更新
    m_tPast++;
    if (m_tDamage > 0) {
        m_tDamage--;
    }
    
    // 移動
    self._vx *= DECAY_DAMAGE;
    self._vy *= DECAY_DAMAGE;
    [self move:dt];
    Vec2D v = Vec2D(self._x, self._y);
    [self clipScreen:&v];
    self._x = v.x;
    self._y = v.y;
    
    // 背景を動かす
    GameScene* scene = [GameScene sharedInstance];
    [scene.back setTarget:self._x y:self._y];
    
    // 各種更新
    switch (m_State) {
        case eState_Standby:
            [self updateStandby:dt];
            break;
        
        case eState_Damage:
            [self updateDamage:dt];
            break;
            
        default:
            break;
    }
    
    // ゲージ更新
    [self updateGauge];
    
    // アニメーション更新
    [self updateAnime];
}

// 弾を撃つ
- (void)shot {
    
    // 照準に向けて弾を撃つ
    Aim* aim = [self getAim];
    Vec2D v = Vec2D(aim._x - self._x, aim._y - self._y);
    
    // 弾を撃つ
    [Shot add:self._x y:self._y rot:v.Rot() + Math_RandFloat(-5, 5) speed:SPEED_SHOT];
    
}

// ダメージ
- (void)damage:(Token*)t {
    m_tDamage = TIMER_DAMAGE;
    m_Timer = TIMER_DAMAGE;
    m_State = eState_Damage;
    
    // パワーゲージをリセット
    m_tPower = 0;
    
    // チャージエフェクト終了
    Charge* charge = [self getCharge];
    [charge setParam:eCharge_Disable x:self._x y:self._y];
   
    // 吹き飛ばす
    Vec2D d = Vec2D(self._x - t._x, self._y - t._y);
    d.Normalize();
    d *= SPEED_DAMAGE;
    self._vx = d.x;
    self._vy = d.y;
    
    // HPを減らす
    m_Hp -= 5;
    if (m_Hp < 0) {
        m_Hp = 0;
    }
    
}

// パワーの取得
- (int)getPower {
    return m_tPower;
}

@end
