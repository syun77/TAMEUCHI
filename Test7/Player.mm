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
#import "Particle.h"
#import "Item.h"
#import "Bullet.h"
#import "Bomb.h"

// ダメージタイマー
static const int TIMER_DAMAGE = 30;

// ダメージ時の移動量
static const float SPEED_DAMAGE = 200;
static const float DECAY_DAMAGE = 0.95f; // 移動量の減衰値 

// 弾の移動量
static const float SPEED_SHOT = 360;

// チャージが有効となる開始時間
static const int TIMER_CHARGE_START = 20;

// ■チャージゲージ
// チャージ初期値
static const int POWER_MIN = 40;
// チャージ最大量
static const int POWER_MAX = 240;
// チャージレベルアップ時増加分
static const int POWER_INC = 10;

// HPの最大
static const int MAX_HP = 100;

// 自動回復用タイマー
// 初回回復までの時間
static const int TIMER_AUTO_RECOVER_INIT = 100;
// それ以降の回復時間
static const int TIMER_AUTO_RECOVER = 20;

// HP回復アイテム取得
static const float RECOVER_ITEM_HP_RATIO = 0.2f;

// ダメージ量
// 初回
static const float DAMAGE_HP_RATIO_INIT   = 0.3f;
// 連続ダメージ
static const float DAMAGE_HP_RATIO_REPEAT = 0.02f;


/**
 * 状態
 */
enum eState {
    eState_Standby, // 待機
    eState_Damage,  // ダメージ
    eState_Vanish,  // 消滅
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
 * チャージが開始できるかどうか
 */
- (BOOL)isChargeStart {
    
    // TODO: 開始判定は不要
    return YES;
    
    int max = TIMER_CHARGE_START + m_nLevel * 10;
    if (m_tCharge >= max) {
        
        // 開始できる
        m_tCharge = max;
        return YES;
    }
    
    // 溜まっていない
    return NO; 
}

/**
 * 状態遷移
 */
- (void)changeState:(eState)state {

    if (m_State == eState_Vanish) {
        // 消滅状態は状態変化不可
        return;
    }
    m_State = state;
}

// レベルアップ判定
- (BOOL)checkLevelUp {
    
    // レベルアップしたかどうか
    BOOL ret = NO;

    if ([self isLevelUp]) {
            
        // レベルアップ
        m_nLevel++;
        GameScene* scene = [GameScene sharedInstance];
        [scene startLevelUp];
        
        ret = YES;
    }
    
    return ret;
}

/**
 * 初期化
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    [self create];
    
    // 初期パラメータ設定
    self._x = System_CenterX();
    self._y = System_CenterY();
    m_Target.Set(self._x, self._y);
    
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    [self setScale:0.5f];
    [self setSize2:24];
    
    // 変数初期化
    m_State = eState_Standby;
    m_Timer = 0;
    m_tPast = 0;
    m_tShot = 0;
    m_tDamage = 0;
    m_tPower = 0;
    m_tCharge = 0;
    m_Combo = 0;
    m_ComboMax = 0;
    m_nLevel = 0;
    
    
    return self;
}

// 開始
- (void)initialize {
   
    // HP初期化
    m_Hp = MAX_HP;
    //m_Hp = 1;
    m_PowerMax = POWER_MIN;
    
    Gauge* gauge = [self getGauge];
    [gauge initialize:m_PowerMax];
    
    GaugeHp* gaugeHp = [self getGaugeHp];
    [gaugeHp initialize:MAX_HP];
}

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y {
    
    // コンボ初期化
    [self initCombo];
    
    m_Start.x = self._x;
    m_Start.y = self._y;
    
    if (m_State == eState_Damage) {
        
        // ダメージ中だったら待機状態に戻す
        [self changeState:eState_Standby];
    }
}

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y {
    m_tCharge = 0;
}


/**
 * 移動量を画面内に収める
 */
- (void)clipScreen:(Vec2D*)v {
    
    float s = self._r;
    float x1 = s;
    float y1 = s * 1.2;
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

// 移動中かどうか
- (BOOL)isMoving {
    return [self isTouch];
}

// HPが最大値かどうか
- (BOOL)isHpMax {
    return m_Hp == MAX_HP;
}

// 弾を撃つ
- (void)shot:(float)rot {
    // 弾を撃つ
    float speed = SPEED_SHOT * (1 + ((float)m_tPower / m_PowerMax));
    [Shot add:eShot_Normal x:self._x y:self._y rot:rot + Math_RandFloat(-5, 5) speed:speed];
    
    if ([self getPowerRatio] > 0.3) {
        // 3WAV
        [Shot add:eShot_Normal x:self._x y:self._y rot:rot - 15 speed:speed];
        [Shot add:eShot_Normal x:self._x y:self._y rot:rot + 15 speed:speed];
    }
    
    if (m_nLevel > 4) {
        if ([self getPowerRatio] > 0.8) {
            // 5WAV
            [Shot add:eShot_Normal x:self._x y:self._y rot:rot - 30 speed:speed];
            [Shot add:eShot_Normal x:self._x y:self._y rot:rot + 30 speed:speed];
        }
    }
    
    if (m_nLevel > 9) {
        
        if ([self getPowerRatio] > 0.95 && m_PowerMax - m_tPower < 8) {
            // 7WAV
            [Shot add:eShot_Normal x:self._x y:self._y rot:rot - 45 speed:speed];
            [Shot add:eShot_Normal x:self._x y:self._y rot:rot + 45 speed:speed];
        }
    }
}

// 弾を撃つ
- (void)shotAim {
    
    // 照準に向けて弾を撃つ
    Aim* aim = [self getAim];
    Vec2D v = Vec2D(aim._x - self._x, aim._y - self._y);
    
    [self shot:v.Rot()];
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
        
        float nearestLength = 9999999;
        e = [Enemy getNearest:self._x y:self._y];
        if (e) {
            Vec2D v = Vec2D(e._x - self._x, e._y - self._y);
            nearestLength = v.LengthSq();
        }

        // ショットタイマー更新
        if (m_tShot > 0) {
            m_tShot--;
        }
        if (m_tShot <= 0) {
            // 弾を撃つ
            [self shotAim];
            if (m_tPower > 0) {
                m_tPower--;
                m_tShot += 2;
                if (nearestLength < 20000) {
                    m_tShot = 0;
                }
            }
            else {
                // パワー切れ
                // コンボ終了
                [self initCombo];
                
                // 近くに敵がいるほど連射性能がアップ
                float ratio = nearestLength / (160 * 120);
                if (ratio > 1) {
                    ratio = 1;
                }
                m_tShot = SHOT_TIMER * ratio;
            }
        }
    }
    else {
        m_tShot = 0;
        
        // パワーをためる
        m_tCharge++;
        if ([self isChargeStart]) {
            
            m_tPower += 0.3f;
            if (m_tPower > m_PowerMax) {
                m_tPower = m_PowerMax;
            }
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
   
    m_tRecover++;
    if (m_tRecover > TIMER_AUTO_RECOVER_INIT) {
        // HP 回復
        m_Hp++;
        if (m_Hp > MAX_HP) {
            m_Hp = MAX_HP;
        }
        
        m_tRecover -= TIMER_AUTO_RECOVER;
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
        if ([self isChargeStart]) {
            
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
        [self changeState:eState_Standby];
        
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
    
    if ([self isDanger] && m_tPast%64 / 32) {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_PlayerDamage)];
    }
    
    if (m_tDamage > 0) {
        // ダメージ中画像
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_PlayerDamage)];
    }
    
    Aim* aim = [self getAim];
    if ((aim._x - self._x) > 0) {
        if (self.scaleX < 0) {
            self.scaleX = -self.scaleX;
        }
    }
    else {
        if (self.scaleX > 0) {
            self.scaleX = -self.scaleX;
        }
    }
    
}

/**
 * ゲージ更新
 */
- (void)updateGauge {
    Gauge* gauge = [self getGauge];
    
    [gauge set:m_tPower x:self._x y:self._y];
    
    GaugeHp* gaugeHp = [self getGaugeHp];
    [gaugeHp set:m_Hp x:self._x y:self._y];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if (m_State == eState_Vanish) {
        
        // 死亡したので何もしない
        return;
    }
    
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
            // 待機中
            [self updateStandby:dt];
            break;
        
        case eState_Damage:
            // ダメージ中
            [self updateDamage:dt];
            break;
            
        case eState_Vanish:
            // 消滅
            break;
            
        default:
            break;
    }
    
    // ゲージ更新
    [self updateGauge];
    
    // アニメーション更新
    [self updateAnime];
    
    m_PrevX = self._x;
    m_PrevY = self._y;
}

// 危険回避ショット
- (void)shotDanger {
    
    Sound_PlaySe(@"damage.wav");
    
    // オートボム発動
    if (m_nLevel > 1) {
        
        float r = 32 + m_nLevel * 8;
        if (r > 256) {
            r = 256;
        }
        [Bomb add:r x:self._x y:self._y];
    }
    
    if (m_nLevel > 1) {
        int cnt = m_nLevel * 4;
        for (int i = 0; i < cnt; i++) {
            // 全方位弾発射
            [Shot add:eShot_Power x:self._x y:self._y rot:i * (360/cnt) speed:100];
        }
    }
    
    /*
    if (m_nLevel >= 3) {
        // レベル３特典
        // 全方位弾発射
        for (int i = 0; i < 64; i++) {
            [Shot add:eShot_Power x:self._x y:self._y rot:i * (360/64) speed:100];
        }
    }
   
    if (m_nLevel >= 2) {
        // レベル２特典
        // 敵サイズ・小を消して撃ち返し弾発生
        [Enemy vanishAllSmall:YES];
        
        // 敵弾を消して打ち返し発生
        [Bullet vanishAll:eBulletVanish_Reflect];
    }
    
    if (m_nLevel >= 1) {
        // レベル１特典
        // 敵サイズ・小を消す
        [Enemy vanishAllSmall:NO];
        
    }
    
    // 敵弾はいつでも消える
    [Bullet vanishAll:eBulletVanish_Normal];
     */
    
    // レベルリセット
    m_nLevel = 0;
    
    // パワーゲージを初期値に戻す
    m_PowerMax = POWER_MIN;
    Gauge* gauge = [self getGauge];
    [gauge setMax:m_PowerMax];
}

// ダメージ
- (void)damage:(Token*)t {
    
    // コンボ回数初期化
    [self initCombo];
    
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
    float bDanger = [self isDanger];
    if (m_State == eState_Standby) {
        
        // 初回ダメージ
        m_Hp -= MAX_HP * DAMAGE_HP_RATIO_INIT;
        
    }
    else {
        
        // 連続ダメージ
        m_Hp -= MAX_HP * DAMAGE_HP_RATIO_REPEAT;
        if (m_Hp < 1) {
            // 連続ダメージでは死なないようにする
            m_Hp = 1;
        }
    }
    if (bDanger == NO) {
        if ([self isDanger]) {
            // 危険状態になった
            // 危険回避ショット
            [self shotDanger];
        }
    }
    
    if (m_Hp < 0) {
        
        // 死亡
        m_Hp = 0;
        
        // 全て非表示にする
        [self setVisible:NO];
        Charge* charge = [self getCharge];
        [charge setVisible:NO];
        Gauge* gauge = [self getGauge];
        [gauge setVisible:NO];
        GaugeHp* gaugeHp = [self getGaugeHp];
        [gaugeHp setVisible:NO];
        
        [self changeState:eState_Vanish];
        
        // 死亡SE再生
        Sound_PlaySe(@"damage.wav");
        
        // 死亡エフェクト生成
        Particle* p = [Particle add:eParticle_Ring x:self._x y:self._y rot:0 speed:0];
        if (p) {
            [p setScale:1.5];
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
    else {
        
        // 回復用タイマーをリセットする
        m_tRecover = 0;
        m_tDamage = TIMER_DAMAGE;
        m_Timer = TIMER_DAMAGE;
        
        [self changeState:eState_Damage];
    }
    
}

// HPの割合を取得 (０〜１)
- (float)getHpRatio {
    return (float)m_Hp / MAX_HP;
}

// 危険状態かどうか
- (BOOL)isDanger {
    if (m_State == eState_Vanish) {
        // 死んでたら何もしない
        return NO;
    }
    
    // 0.3以下で危険
    return [self getHpRatio] < 0.3;
}

// パワーの取得
- (int)getPower {
    return m_tPower;
}

// パワーの割合を取得
- (float)getPowerRatio {
    return m_tPower / (float)m_PowerMax;
}

// パワーの追加
- (void)addPower:(float)v {
    m_tPower += v;
    if (m_tPower > m_PowerMax) {
        m_tPower = m_PowerMax;
    }
}


// チャージタイマーの取得
- (int)getChargeTimer {
    return m_tCharge;
}

// レベルの取得
- (int)getLevel {
    return m_nLevel + 1;
}

// 消滅したかどうか
- (BOOL)isVanish {
    return m_State == eState_Vanish;
}

// コンボ初期化
- (void)initCombo {
    
    if (m_Combo > 0) {
        
        // コンボ結果表示
        ComboResult* result = [GameScene sharedInstance].comboResult;
        [result start:m_Combo];
        
        // レベルアップ判定
        if ([self checkLevelUp]) {
            m_PowerMax += POWER_INC;
            Gauge* gauge = [self getGauge];
            [gauge setMax:m_PowerMax];
        }
    }
    
    m_Combo = 0;
    Combo* combo = [GameScene sharedInstance].combo;
    [combo end];
    Back* back = [GameScene sharedInstance].back;
    [back beginLight];
}

// コンボ回数増加
- (void)addCombo {
    
    if ([self isMoving]) {
        // 移動中は増えない
        return;
    }
    
    if (m_tPower < 1) {
        // ゲージが溜まっていないと増えない
        return;
    }
    
    m_Combo++;
    if (m_Combo > m_ComboMax) {
        
        // コンボ回数更新
        m_ComboMax = m_Combo;
    }
    
    
    // コンボ演出開始
    Combo* combo = [GameScene sharedInstance].combo;
    [combo start:m_Combo];
    Back* back = [GameScene sharedInstance].back;
    [back beginDark];
}

// コンボ回数を取得
- (int)getCombo {
    return m_Combo;
}

// コンボ最大回数を取得
- (int)getComboMax {
    return m_ComboMax;
}

// コンボが有効かどうか
- (BOOL)isEnableCombo {
    Combo* combo = [GameScene sharedInstance].combo;
    return [combo isEnable];
}

// アイテム取得
- (void)takeItem:(Token*)t {
    
    Item* item = (Item*)t;
    switch ([item getType]) {
        case eItem_Recover:
            m_Hp += MAX_HP * RECOVER_ITEM_HP_RATIO;
            if (m_Hp > MAX_HP) {
                m_Hp = MAX_HP;
            }
            break;
            
        case eItem_Score:
            [self addPower:3];
            break;
            
        default:
            break;
    }
}

// レベルアップできるかどうか
- (BOOL)isLevelUp {
    
//    if (m_nLevel < 10) {
    if (m_Combo >= m_nLevel + 1) {
        
        // レベルアップできる
        return YES;
    }
    
    // レベルアップできない
    return NO;
}

// 状態を取得
- (NSString*)getStateString {
    switch (m_State) {
        case eState_Standby:
            return @"Standby";
            
        case eState_Damage:
            return @"Damage";
            
        case eState_Vanish:
            return @"Vanish";
            
        default:
            return @"None";
    }
}

@end
