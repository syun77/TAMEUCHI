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

@implementation GameScene

@synthesize baseLayer;
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
    
    baseLayer = [CCLayer node];
    [self addChild:baseLayer];
    
    interfaceLayer = [InterfaceLayer node];
    [baseLayer addChild:interfaceLayer];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    baseLayer = nil;
    interfaceLayer = nil;
    
    [super dealloc];
}

@end
