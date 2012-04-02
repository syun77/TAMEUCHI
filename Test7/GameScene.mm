//
//  GameScene.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "GameScene.h"

#include "Vec.h"


// シングルトン
static GameScene* scene_ = nil;


@implementation GameScene

// 実体定義
@synthesize baseLayer;
@synthesize player;
@synthesize mgrBullet;
@synthesize mgrParticle;
@synthesize interfaceLayer;
@synthesize asciiFont;
@synthesize asciiFont2;

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
    
    self.player = [Player node];
    [self addChild:self.player];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.mgrBullet = [TokenManager node];
    [self.mgrBullet create:self.baseLayer size:32 className:@"Bullet"];
    
    self.mgrParticle = [TokenManager node];
    [self.mgrParticle create:self.baseLayer size:256 className:@"Particle"];
    
    self.asciiFont = [AsciiFont node];
    [self.asciiFont createFont:self.baseLayer length:16];
    [self.asciiFont setPosScreen:8 y:320-24];
    
    self.asciiFont2 = [AsciiFont node];
    [self.asciiFont2 createFont:self.baseLayer length:16];
    [self.asciiFont2 setPosScreen:8 y:320-24-16];
    
    // 更新スケジューラー登録
    [self scheduleUpdate];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    // 更新スケジューラー解除
    [self unscheduleUpdate];
    
    // インスタンス開放
    self.asciiFont = nil;
    self.mgrParticle = nil;
    self.mgrBullet = nil;
    self.player = nil;
    self.baseLayer = nil;
    self.interfaceLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    //NSLog(@"update.");
    
    // 敵弾の生存数を表示
    [self.asciiFont setText:[NSString stringWithFormat:@"Bullet:%d", [self.mgrBullet count]]];
    [self.asciiFont2 setText:[NSString stringWithFormat:@"Particle:%d", [self.mgrParticle count]]];
    
    if ([self.interfaceLayer isTouch] == NO) {
        return;
    }
    
    float x = [self.interfaceLayer getPosX];
    float y = [self.interfaceLayer getPosY];
    
    static int s_count = 0;
    Token* t = [self.mgrBullet add];
    [t set2:x y:y rot:(s_count%36)*10 speed:240 ax:0 ay:0];
    s_count++;
    
}

@end
