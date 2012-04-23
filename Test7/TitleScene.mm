//
//  TitleScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "SceneManager.h"

// シングルトン
static TitleScene* scene_ = nil;

@implementation TitleScene

@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize asciiFont;

// シングルトンを取得する
+ (TitleScene*)sharedInstance {
    
    if (scene_ == nil) {
        scene_ = [TitleScene node];
    }
    
    return scene_;
}

+ (void)releaseInstance {
    scene_ = nil;
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
    
    self.asciiFont = [AsciiFont node];
    [self.asciiFont createFont:self.baseLayer length:24];
    [self.asciiFont setPosScreen:8 y:320-24];
    [self.asciiFont setText:@"TITLE"];
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    self.asciiFont = nil;
    self.interfaceLayer = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

// 更新
- (void)update:(ccTime)dt {
    if ([self.interfaceLayer isTouch]) {
        NSLog(@"Touch!!!");
        
        SceneManager_Change(@"GameScene");
        
//        [TitleScene releaseInstance];
//        
//        [[CCDirector sharedDirector] replaceScene:[GameScene sharedInstance]];
        
    }
}

@end
