//
//  OptionScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OptionScene.h"

#import "SceneManager.h"
#import "SaveData.h"

enum ePrio {
    ePrio_Back,
};

static OptionScene* scene_ = nil;

@implementation OptionScene

@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize back;
@synthesize btnBgm;
@synthesize btnSe;
@synthesize btnEasy;
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

- (void)setBtnBgm {
    
    BOOL b = Sound_IsEnableBgm();
    
    [self.btnBgm setText:[NSString stringWithFormat:@"BGM:%s", b ? "o" : "x"]];
}

/**
 * BGM ON/OFF ボタン押したコールバック
 */
- (void)cbBtnBgm {
    
    Sound_PlaySe(@"pi.wav");
    
    if(Sound_IsEnableBgm()) {
        
        Sound_SetEnableBgm(NO);
    }
    else {
        
        Sound_SetEnableBgm(YES);
    }
    
    [self setBtnBgm];
}

- (void)setBtnSe {
    
    BOOL b = Sound_IsEnableSe();
    
    [self.btnSe setText:[NSString stringWithFormat:@"SE:%s", b ? "o" : "x"]];
}

/**
 * SE ON/OFF ボタン押したコールバック
 */
- (void)cbBtnSe {
    
    Sound_PlaySe(@"pi.wav");
    
    if (Sound_IsEnableSe()) {
        
        Sound_SetEnableSe(NO);
    }
    else {
        
        Sound_SetEnableSe(YES);
    }
    
    [self setBtnSe];
}

- (void)setBtnEasy {
    
    BOOL b = SaveData_IsEasy();
    
    [self.btnEasy setText:[NSString stringWithFormat:@"EASY:%s", b ? "o" : "x"]];
}

/**
 * EASYモード ボタン押したコールバック
 */
- (void)cbBtnEasy {
    
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsEasy()) {
        
        SaveData_SetEasy(NO);
    }
    else {
        
        SaveData_SetEasy(YES);
    }
    
    [self setBtnEasy];
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
    
    self.btnBgm = [Button node];
    [self.btnBgm initWith:self.interfaceLayer text:@"BGM" cx:BGM_BUTTON_CX cy:BGM_BUTTON_CY w:BGM_BUTTON_W h:BGM_BUTTON_H cls:self onDecide:@selector(cbBtnBgm)];
    [self setBtnBgm];
    
    self.btnSe = [Button node];
    [self.btnSe initWith:self.interfaceLayer text:@"SE" cx:SE_BUTTON_CX cy:SE_BUTTON_CY w:SE_BUTTON_W h:SE_BUTTON_H cls:self onDecide:@selector(cbBtnSe)];
    [self setBtnSe];
    
    self.btnEasy = [Button node];
    [self.btnEasy initWith:self.interfaceLayer text:@"EASY" cx:EASY_BUTTON_CX cy:EASY_BUTTON_CY w:EASY_BUTTON_W h:EASY_BUTTON_H cls:self onDecide:@selector(cbBtnEasy)];
    [self setBtnEasy];
    
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
    self.btnSe = nil;
    self.btnEasy = nil;
    self.btnBgm = nil;
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
