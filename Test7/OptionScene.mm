//
//  OptionScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OptionScene.h"

#import "SceneManager.h"

enum ePrio {
    ePrio_Back,
};

static OptionScene* scene_ = nil;

@implementation OptionScene

@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize back;
@synthesize btnBack;

/**
 * シングルトンを取得する
 */
+ (OptionScene*)sharedInstance {
    
    if (scene_ == nil) {
        scene_ = [OptionScene node];
    }
    
    return scene_;
}

+ (void)releaseInstance {
    scene_ = nil;
}

/**
 * 戻るボタンを押した時のコールバック
 */
- (void)cbBtnBack {
    
    Sound_PlaySe(@"push.wav");
    
    m_bNextScene = YES;
}

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.back = [BackOption node];
    [self.baseLayer addChild:self.back z:ePrio_Back];
    
    self.btnBack = [Button node];
    [self.btnBack initWith:self.interfaceLayer text:@"BACK" cx:BACK_BUTTON_CX cy:BACK_BUTTON_CY w:BACK_BUTTON_W h:BACK_BUTTON_H cls:self onDecide:@selector(cbBtnBack)];
    
    m_bNextScene = NO;
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.btnBack = nil;
    self.back = nil;
    self.interfaceLayer = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if (m_bNextScene) {
        
        // タイトル画面に戻る
        SceneManager_Change(@"TitleScene");
    }
}

@end
