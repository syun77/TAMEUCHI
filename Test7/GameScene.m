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
    if (self._x > 480) {
        
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
    [self.mgr create:self.baseLayer size:2 className:@"Bullet"];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    self.mgr = nil;
    self.baseLayer = nil;
    self.interfaceLayer = nil;
    
    [super dealloc];
}

@end
