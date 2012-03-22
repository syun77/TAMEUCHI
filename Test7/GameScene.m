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

@synthesize interfaceLayer;

// シングルトンを取得
+ (GameScene*)sharedInstance {
    
    if (scene_ == nil) {
        
        scene_ = [GameScene node];
    }
    
    return scene_;
}

- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    self.interfaceLayer = [InterfaceLayer node];
    [self addChild:self.interfaceLayer];
    
    return self;
}

@end
