//
//  GameScene.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

// シングルトン
static GameScene* scene_ = nil;

// 敵弾実装
@interface Bullet : Token {
}

- (void)update:(ccTime)dt;
@end

@implementation Bullet

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"icon.png"];
    
    return self;
}

- (void)initialize {
    [self set:0 y:240 vx:480 vy:0 ax:0 ay:0];
    
    NSLog(@"Intialize[%d].", [self getIndex]);
}

- (void)update:(ccTime)dt {
    [self move:dt];
    if ([self isOut]) {
        
        NSLog(@"Vanish[%d].", [self getIndex]);
        [self removeFromParentAndCleanup:YES];
        [self setExist:NO];
        return;
    }
}

@end


@implementation GameScene

// 実体定義
@synthesize baseLayer;
@synthesize mgr;
@synthesize interfaceLayer;

// シングルトンを取得
+ (GameScene*)sharedInstance {
    
    if (scene_ == nil) {
        
        scene_ = [GameScene node];
    }
    
    return scene_;
}

// コンストラクタ
- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.mgr = [TokenManager node];
    [self.mgr create:self.baseLayer size:16 className:@"Bullet"];
    
    // 更新スケジューラー登録
    [self scheduleUpdate];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    // 更新スケジューラー解除
    [self unscheduleUpdate];
    
    // インスタンス開放
    self.mgr = nil;
    self.baseLayer = nil;
    self.interfaceLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    //NSLog(@"update.");
    
    if ([self.interfaceLayer isTouch] == NO) {
        return;
    }
    
    Vec2D p = [self.interfaceLayer getPos];
    
    static int s_count = 0;
    Token* t = [self.mgr add];
    [t set2:p.x y:p.y rot:(s_count%36)*10 speed:240 ax:0 ay:0];
    s_count++;
}

@end
