//
//  GameScene.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "GameScene.h"

#include "Vec.h"
#import "SceneManager.h"

#import "Enemy.h"
#import "Item.h"
#import "Shot.h"
#import "Bullet.h"

#import "SaveData.h"

// レベルアップ演出タイマー
static const int TIMER_LEVELUP = 60;

// 描画プライオリティ
enum {
    ePrio_Back,     // 背景
    ePrio_LevelUp,  // レベルアップ文字
    ePrio_Player,   // プレイヤー
    ePrio_Enemy,    // 敵
    ePrio_Item,     // アイテム
    ePrio_Shot,     // 自弾
    ePrio_Bullet,   // 敵弾
    ePrio_Aim,      // 照準
    ePrio_Charge,   // チャージエフェクト
    ePrio_Black,    // 画面全体を暗くする
    ePrio_Particle, // パーティクル
    ePrio_Gauge,    // ゲージ表示
    ePrio_UI,       // ユーザインターフェース
};

// 状態
enum eState {
    eState_Init,        // 初期化
    eState_Main,        // メイン
    estate_GameOver,    // ゲームオーバー
};

enum eStep {
    eStep_Main,     // メイン
    eStep_Levelup,  // レベルアップ
};


// シングルトン
static GameScene* scene_ = nil;


@implementation GameScene

// 実体定義
@synthesize baseLayer;
@synthesize back;
@synthesize player;
@synthesize aim;
@synthesize charge;
@synthesize gauge;
@synthesize gaugeHp;
@synthesize combo;
@synthesize comboResult;
@synthesize black;
@synthesize mgrShot;
@synthesize mgrItem;
@synthesize mgrEnemy;
@synthesize mgrBullet;
@synthesize mgrParticle;
@synthesize interfaceLayer;
@synthesize levelMgr;
@synthesize asciiFont1;
@synthesize asciiFont2;
@synthesize asciiFont3;
@synthesize asciiFont4;
@synthesize asciiFont5;
@synthesize asciiFontLevel;
@synthesize asciiFontScore;

// シングルトンを取得
+ (GameScene*)sharedInstance {
    
    if (scene_ == nil) {
        
        scene_ = [GameScene node];
    }
    
    return scene_;
}

+ (void)releaseInstance {
    scene_ = nil;
}

// コンストラクタ
- (id)init {
    
    // 乱数初期化
    Math_Init();
    
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    // 各種オブジェクト生成
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.back = [Back node];
    [self.baseLayer addChild:self.back z:ePrio_Back];
    
    self.aim = [Aim node];
    [self.baseLayer addChild:self.aim z:ePrio_Aim];
    
    self.charge = [Charge node];
    [self.baseLayer addChild:self.charge z:ePrio_Charge];
    
    self.gauge = [Gauge node];
    [self.baseLayer addChild:self.gauge z:ePrio_Gauge];
    
    self.gaugeHp = [GaugeHp node];
    [self.baseLayer addChild:self.gaugeHp z:ePrio_UI];
    
    self.black = [Black node];
    [self.baseLayer addChild:self.black z:ePrio_Black];
    
    self.combo = [Combo node];
    [self.baseLayer addChild:self.combo z:ePrio_UI];
    [self.combo.asciiFont createFont:self.baseLayer length:8];
    [self.combo.asciiFont setText:@""];
    [self.combo.asciiFont2 createFont:self.baseLayer length:8];
    [self.combo.asciiFont2 setText:@""];
    
    self.comboResult = [ComboResult node];
    [self.baseLayer addChild:self.comboResult z:ePrio_UI];
    [self.comboResult.asciiFont createFont:self.baseLayer length:12];
    [self.comboResult.asciiFont setText:@""];
    
    self.player = [Player node];
    [self.baseLayer addChild:self.player z:ePrio_Player];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    [self.interfaceLayer addCB:self];
    
    self.mgrShot = [TokenManager node];
    [self.mgrShot create:self.baseLayer size:256 className:@"Shot"];
    [self.mgrShot setPrio:ePrio_Shot];
    
    self.mgrItem = [TokenManager node];
    [self.mgrItem create:self.baseLayer size:64 className:@"Item"];
    [self.mgrItem setPrio:ePrio_Item];
    
    self.mgrEnemy = [TokenManager node];
    [self.mgrEnemy create:self.baseLayer size:64 className:@"Enemy"];
    [self.mgrEnemy setPrio:ePrio_Enemy];
    
    self.mgrBullet = [TokenManager node];
    [self.mgrBullet create:self.baseLayer size:256 className:@"Bullet"];
    [self.mgrBullet setPrio:ePrio_Bullet];
    
    self.mgrParticle = [TokenManager node];
    [self.mgrParticle create:self.baseLayer size:256 className:@"Particle"];
    [self.mgrParticle setPrio:ePrio_Particle];
    
    self.levelMgr = [LevelMgr node];
    [self.levelMgr initialize];
    
    self.asciiFont1 = [AsciiFont node];
    [self.asciiFont1 createFont:self.baseLayer length:24];
    [self.asciiFont1 setPrio:ePrio_LevelUp];
    [self.asciiFont1 setPosScreen:System_CenterX() y:System_CenterY()];
    [self.asciiFont1 setAlign:eFontAlign_Center];
    [self.asciiFont1 setVisible:NO];
    
    self.asciiFont2 = [AsciiFont node];
    [self.asciiFont2 createFont:self.baseLayer length:24];
    [self.asciiFont2 setPosScreen:8 y:320-24-16];
    
    self.asciiFont3 = [AsciiFont node];
    [self.asciiFont3 createFont:self.baseLayer length:24];
    [self.asciiFont3 setPosScreen:8 y:320-24-32];
    
    self.asciiFont4 = [AsciiFont node];
    [self.asciiFont4 createFont:self.baseLayer length:24];
    [self.asciiFont4 setPosScreen:8 y:32];
    
    self.asciiFont5 = [AsciiFont node];
    [self.asciiFont5 createFont:self.baseLayer length:24];
    [self.asciiFont5 setPosScreen:8 y:320-24-64];
    
    self.asciiFontLevel = [AsciiFont node];
    [self.asciiFontLevel createFont:self.baseLayer length:24];
    [self.asciiFontLevel setPosScreen:8 y:320-24-80];
    
    self.asciiFontScore = [AsciiFont node];
    [self.asciiFontScore createFont:self.baseLayer length:24];
    
    // コールバック関数登録
    [self.interfaceLayer addCB:self.player];
    
    // 更新スケジューラー登録
    [self scheduleUpdate];
    
    
    // 初期化するフラグ
    m_State = eState_Init;
    m_nDestroy = 0;
    m_Score = SaveData_GetHiScore();
    m_ComboMax = 0;
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    // 更新スケジューラー解除
    [self unscheduleUpdate];
    
    // インスタンス開放
    self.asciiFontScore = nil;
    self.asciiFontLevel = nil;
    self.asciiFont5 = nil;
    self.asciiFont4 = nil;
    self.asciiFont3 = nil;
    self.asciiFont2 = nil;
    self.asciiFont1 = nil;
    self.levelMgr = nil;
    self.mgrParticle = nil;
    self.mgrBullet = nil;
    self.mgrEnemy = nil;
    self.mgrItem = nil;
    self.mgrShot = nil;
    self.black = nil;
    self.comboResult = nil;
    self.combo = nil;
    self.gaugeHp = nil;
    self.gauge = nil;
    self.charge = nil;
    self.aim = nil;
    self.player = nil;
    self.back = nil;
    self.baseLayer = nil;
    self.interfaceLayer = nil;
    
    [super dealloc];
}

/**
 * 初期化
 */
- (void)initialize {
    
    // プレイヤー初期化
    [self.player initialize];

    // レベル初期化
    [self.levelMgr initialize];
}

/**
 * 更新・初期化
 */
- (void)updateInit:(ccTime)dt {
    [self initialize];
    m_State = eState_Main;
}

/**
 * 更新・メイン
 */
- (void)updateMain:(ccTime)dt {
    // 当たり判定を行う
    
    // 自機 vs アイテム
    for (Item* item in self.mgrItem.m_Pool) {
        if ([item isExist] == NO) {
            continue;
        }
        
        if ([item isHit2:self.player]) {
            // アイテム取得
            [self.player takeItem:item];
            switch ([item getType]) {
                case eItem_Score:
                    m_Score += 10;
                    break;
                    
                default:
                    break;
            }
            [item vanishWithEffect];
        }
    }
    
    // 自弾 vs 敵
    for (Shot* s in self.mgrShot.m_Pool) {
        if ([s isExist] == NO) {
            continue;
        }
        for (Enemy* e in self.mgrEnemy.m_Pool) {
            if ([e isExist] == NO) {
                continue;
            }
            
            if ([s isHit2:e]) {
                
                [s hit:e._x y:e._y];
                if ([e hit:s._vx y:s._vy]) {
                    
                    // 倒したらコンボ回数アップ
                    [self.player addCombo];
                    
                    // スコアもアップ
                    m_Score += 100;
                    
                    SaveData_SetHiScore(m_Score);
                    
                }
            }
        }
    }
    
    // 自機 vs 敵
    for (Enemy* e in self.mgrEnemy.m_Pool) {
        if ([e isExist] == NO) {
            continue;
        }
        
        if ([e isHit2:self.player]) {
            // ダメージ判定
            [self.player damage:e];
        }
    }
    
    // 敵弾の当たり判定チェック
    for (Bullet* b in self.mgrBullet.m_Pool) {
        if ([b isExist] == NO) {
            continue;
        }
        
        // 照準 vs 敵弾
        if ([b isHit2:self.aim]) {
            
            // 敵弾消滅
            [b damage:self.aim];
            continue;
        }
        
        // 自機 vs 敵弾
        if ([b isHit2:self.player]) {
            // ダメージ判定
            [self.player damage:b];
            [b damage:self.player];
        }
    }
    
    if ([self.player isVanish]) {
        
        // プレイヤー死亡
        m_State = estate_GameOver;
    }
    
}

/**
 * レベルアップ演出中
 */
- (void)updateLevelUp:(ccTime)dt {
    
    float px = System_CenterX() - 16 + 16.0 * m_Timer / TIMER_LEVELUP;
    if (m_Timer > TIMER_LEVELUP - 10) {
        
        px += 32 * (10 - (TIMER_LEVELUP - m_Timer));
    }
    
    [self.asciiFont1 setPosScreen:px y:System_CenterY()];
    [self.asciiFont1 setScale:1.5];
    [self.asciiFont1 setText:[NSString stringWithFormat:@"LEVEL %d", [self.player getLevel]]];
    [self.asciiFont1 setVisible:YES];
    
    m_Timer--;
    if (m_Timer < 1) {
        
        [self.asciiFont1 setVisible:NO];
        
        // メインに戻る
        m_Step = eStep_Main;
        
        [self.mgrBullet resumeAll];
        [self.mgrEnemy resumeAll];
        [self.mgrItem resumeAll];
        [self.mgrShot resumeAll];
    }
}

/**
 * 更新・ゲームオーバー
 */
- (void)updateGameOver:(ccTime)dt {
    
    if ([self isPress]) {
        
        // タイトル画面に戻る
        SceneManager_Change(@"TitleScene");
    }
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    switch (m_State) {
        case eState_Init:
            [self updateInit:dt];
            m_Step = eStep_Main;
            break;
            
        case eState_Main:
            switch (m_Step) {
                case eStep_Main:
                    
                    [self updateMain:dt];
                    break;
                    
                case eStep_Levelup:
                    
                    [self updateLevelUp:dt];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case estate_GameOver:
            [self updateGameOver:dt];
            break;
            
        default:
            break;
    }
    
    // Tokenの生存数を表示
//    [self.asciiFont4 setText:[NSString stringWithFormat:@"Shot    :%3d/%3d %3d", [self.mgrShot count], [self.mgrShot max], [self.mgrShot leak]]];
//    [self.asciiFont1 setText:[NSString stringWithFormat:@"Enemy   :%3d/%3d %3d", [self.mgrEnemy count], [self.mgrEnemy max], [self.mgrEnemy leak]]];
//    [self.asciiFont2 setText:[NSString stringWithFormat:@"Bullet  :%3d/%3d %3d", [self.mgrBullet count], [self.mgrBullet max], [self.mgrBullet leak]]];
//    [self.asciiFont3 setText:[NSString stringWithFormat:@"Particle:%3d/%3d %3d", [self.mgrParticle count], [self.mgrParticle max], [self.mgrParticle leak]]];
    
    [self.asciiFont5 setText:[NSString stringWithFormat:@"State: %@", [self.player getStateString]]];
    
    [self.asciiFontLevel setText:[NSString stringWithFormat:@"Level: %3d %5d", [self.levelMgr getLevel], [self.levelMgr getTimer]]];
    
    [self.asciiFontScore setText:[NSString stringWithFormat:@"Score: %d", m_Score]];
    
    [self.asciiFont4 setText:[NSString stringWithFormat:@"Lv :%3d", [self.player getLevel]]];
    
    [self.levelMgr update:dt];

    
    // フラグを下げる
    m_bPress = NO;
}

/**
 * 敵を倒した数を取得する
 */
- (int)getDestroyCount {
    return m_nDestroy;
}

// レベルアップ演出を開始する
- (void)startLevelUp {
    if (m_State != eState_Main) {
        
        // メインでなければ開始できない
        return;
    }
    
    m_Step = eStep_Levelup;
    m_Timer = TIMER_LEVELUP;
    
    [self.mgrBullet pauseAll];
    [self.mgrEnemy pauseAll];
    [self.mgrItem pauseAll];
    [self.mgrShot pauseAll];
    
}

// レベルアップ演出中かどうか
- (BOOL)isLevelUp {
    if (m_State == eState_Main) {
        if (m_Step == eStep_Levelup) {
            return YES;
        }
    }
    
    return NO;
}
@end
