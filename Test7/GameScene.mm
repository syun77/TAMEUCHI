//
//  GameScene.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "GameScene.h"

#include "Vec.h"

#import "Enemy.h"
#import "Shot.h"
#import "Bullet.h"

// 描画プライオリティ
enum {
    ePrio_Back,     // 背景
    ePrio_Player,   // プレイヤー
    ePrio_Item,     // アイテム
    ePrio_Enemy,    // 敵
    ePrio_Shot,     // 自弾
    ePrio_Bullet,   // 敵弾
    ePrio_Aim,      // 照準
    ePrio_Charge,   // チャージエフェクト
    ePrio_Particle, // パーティクル
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
@synthesize mgrShot;
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

// シングルトンを取得
+ (GameScene*)sharedInstance {
    
    if (scene_ == nil) {
        
        scene_ = [GameScene node];
    }
    
    return scene_;
}

// コンストラクタ
- (id)init {
    
    // 乱数初期化
    Math_Init();
    
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.back = [Back node];
    [self.baseLayer addChild:self.back z:ePrio_Back];
    
    self.player = [Player node];
    [self.baseLayer addChild:self.player z:ePrio_Player];
    
    self.aim = [Aim node];
    [self.baseLayer addChild:self.aim z:ePrio_Aim];
    
    self.charge = [Charge node];
    [self.baseLayer addChild:self.charge z:ePrio_Charge];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.mgrShot = [TokenManager node];
    [self.mgrShot create:self.baseLayer size:64 className:@"Shot"];
    [self.mgrShot setPrio:ePrio_Shot];
    
    self.mgrEnemy = [TokenManager node];
    [self.mgrEnemy create:self.baseLayer size:8 className:@"Enemy"];
    [self.mgrEnemy setPrio:ePrio_Enemy];
    
    self.mgrBullet = [TokenManager node];
    [self.mgrBullet create:self.baseLayer size:64 className:@"Bullet"];
    [self.mgrBullet setPrio:ePrio_Bullet];
    
    self.mgrParticle = [TokenManager node];
    [self.mgrParticle create:self.baseLayer size:256 className:@"Particle"];
    [self.mgrParticle setPrio:ePrio_Particle];
    
    self.levelMgr = [LevelMgr node];
    [self.levelMgr initialize];
    
    self.asciiFont1 = [AsciiFont node];
    [self.asciiFont1 createFont:self.baseLayer length:24];
    [self.asciiFont1 setPosScreen:8 y:320-24];
    
    self.asciiFont2 = [AsciiFont node];
    [self.asciiFont2 createFont:self.baseLayer length:24];
    [self.asciiFont2 setPosScreen:8 y:320-24-16];
    
    self.asciiFont3 = [AsciiFont node];
    [self.asciiFont3 createFont:self.baseLayer length:24];
    [self.asciiFont3 setPosScreen:8 y:320-24-32];
    
    self.asciiFont4 = [AsciiFont node];
    [self.asciiFont4 createFont:self.baseLayer length:24];
    [self.asciiFont4 setPosScreen:8 y:320-24-48];
    
    self.asciiFont5 = [AsciiFont node];
    [self.asciiFont5 createFont:self.baseLayer length:24];
    [self.asciiFont5 setPosScreen:8 y:320-24-64];
    
    // 更新スケジューラー登録
    [self scheduleUpdate];
    
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    // 更新スケジューラー解除
    [self unscheduleUpdate];
    
    // インスタンス開放
    self.asciiFont5 = nil;
    self.asciiFont4 = nil;
    self.asciiFont3 = nil;
    self.asciiFont2 = nil;
    self.asciiFont1 = nil;
    self.levelMgr = nil;
    self.mgrParticle = nil;
    self.mgrBullet = nil;
    self.mgrEnemy = nil;
    self.mgrShot = nil;
    self.charge = nil;
    self.aim = nil;
    self.player = nil;
    self.back = nil;
    self.baseLayer = nil;
    self.interfaceLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    //NSLog(@"update.");
    
    // Tokenの生存数を表示
    [self.asciiFont4 setText:[NSString stringWithFormat:@"Shot    :%3d/%3d %3d", [self.mgrShot count], [self.mgrShot max], [self.mgrShot leak]]];
    [self.asciiFont1 setText:[NSString stringWithFormat:@"Enemy   :%3d/%3d %3d", [self.mgrEnemy count], [self.mgrEnemy max], [self.mgrEnemy leak]]];
    [self.asciiFont2 setText:[NSString stringWithFormat:@"Bullet  :%3d/%3d %3d", [self.mgrBullet count], [self.mgrBullet max], [self.mgrBullet leak]]];
    [self.asciiFont3 setText:[NSString stringWithFormat:@"Particle:%3d/%3d %3d", [self.mgrParticle count], [self.mgrParticle max], [self.mgrParticle leak]]];
    
    [self.asciiFont5 setText:[NSString stringWithFormat:@"Power: %3d", [self.player getPower]]];
    
    [self.levelMgr update:dt];

    // 当たり判定を行う
    
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
                [e hit:s._vx y:s._vy];
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
        //if ([self.aim isActive])
        {
            if ([b isHit2:self.aim]) {
                
                // 敵弾消滅
                [b damage:self.aim];
                continue;
            }
        }
        
        // 自機 vs 敵弾
        if ([b isHit2:self.player]) {
            // ダメージ判定
            [self.player damage:b];
            [b damage:self.player];
        }
    }
    
}

@end
