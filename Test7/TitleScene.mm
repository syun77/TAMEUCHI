//
//  TitleScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/21.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "SceneManager.h"
#import "SaveData.h"
#import "AppDelegate.h"
#import "GameCenter.h"

// シングルトン
static TitleScene* scene_ = nil;

@implementation TitleScene

@synthesize back;
@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize asciiFont;
@synthesize fontLite;
@synthesize fontHiScore;
@synthesize fontRank;
@synthesize fontRankMax;
@synthesize fontCopyRight;

@synthesize btnStart;
@synthesize btnBgm;
@synthesize btnSe;
@synthesize btnEasy;


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

/**
 * スタートボタン押したコールバック
 */
- (void)cbBtnStart {
    
    Sound_PlaySe(@"push.wav");
    
    m_bNextScene = YES;
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

// コンストラクタ
- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.back = [BackTitle node];
    [self.baseLayer addChild:self.back];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.asciiFont = [AsciiFont node];
    [self.asciiFont createFont:self.baseLayer length:24];
    [self.asciiFont setPos:9 y:17];
    [self.asciiFont setScale:2];
    [self.asciiFont setText:@"TAMEUCHI"];
    
    self.fontLite = [AsciiFont node];
    [self.fontLite createFont:self.baseLayer length:24];
    [self.fontLite setPos:20 y:15];
    [self.fontLite setScale:1];
    [self.fontLite setColor:ccc3(0xFF, 0x80, 0x80)];
    [self.fontLite setText:@"Lite"];
#ifdef VERSION_LIMITED
#else
    [self.fontLite setVisible:NO];
#endif
    
    self.fontHiScore = [AsciiFont node];
    [self.fontHiScore createFont:self.baseLayer length:24];
    [self.fontHiScore setPos:10 y:12];
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:10 y:11];
    [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", SaveData_GetRank()]];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:10 y:10];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK  %d", SaveData_GetRankMax()]];
    
    self.fontCopyRight = [AsciiFont node];
    [self.fontCopyRight createFont:self.baseLayer length:24];
    [self.fontCopyRight setPos:17 y:1];
    [self.fontCopyRight setScale:0.75];
    [self.fontCopyRight setAlign:eFontAlign_Center];
    [self.fontCopyRight setText:@"(c) 2012 2dgames.jp"];
    
    
    self.btnStart = [Button node];
    [self.btnStart initWith:self.interfaceLayer text:@"START" cx:START_BUTTON_CX cy:START_BUTTON_CY w:START_BUTTON_W h:START_BUTTON_H cls:self onDecide:@selector(cbBtnStart)];
    
    self.btnBgm = [Button node];
    [self.btnBgm initWith:self.interfaceLayer text:@"BGM" cx:BGM_BUTTON_CX cy:BGM_BUTTON_CY w:BGM_BUTTON_W h:BGM_BUTTON_H cls:self onDecide:@selector(cbBtnBgm)];
    [self setBtnBgm];
    
    self.btnSe = [Button node];
    [self.btnSe initWith:self.interfaceLayer text:@"SE" cx:SE_BUTTON_CX cy:SE_BUTTON_CY w:SE_BUTTON_W h:SE_BUTTON_H cls:self onDecide:@selector(cbBtnSe)];
    [self setBtnSe];
    
#ifdef VERSION_LIMITED
    
    // 制限モードはEASYを選べない
#else
    
    self.btnEasy = [Button node];
    [self.btnEasy initWith:self.interfaceLayer text:@"EASY" cx:EASY_BUTTON_CX cy:EASY_BUTTON_CY w:EASY_BUTTON_W h:EASY_BUTTON_H cls:self onDecide:@selector(cbBtnEasy)];
    [self setBtnEasy];
#endif
    
    // 変数初期化
    m_bNextScene = NO;
    m_TouchStartX = 0;
    m_TouchStartY = 0;
    m_bRankSelect = NO;
//    m_bGameStart = NO;
//    m_bEasy = NO;
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    // 入力コールバック登録
    [self.interfaceLayer addCB:self];
    
    m_bInit = NO;
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    self.btnEasy = nil;
    self.btnSe = nil;
    self.btnBgm = nil;
    self.btnStart = nil;
    
//    self.fontSe = nil;
//    self.fontBgm = nil;
    self.fontCopyRight = nil;
    self.fontRankMax = nil;
    self.fontRank = nil;
    self.fontHiScore = nil;
    self.fontLite = nil;
    self.asciiFont = nil;
    self.interfaceLayer = nil;
    self.back = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

// 更新
- (void)update:(ccTime)dt {
    
    // リーダーボード表示
    if ([self.interfaceLayer isTouch]) {
//        GameCenter_ShowLeaderboard();
    }
    
    if (m_bInit == NO) {
        // 広告表示
        [AppDelegate setVisibleAdWhirlView:YES];
        
        m_bInit = YES;
    }
    
    // ランク数更新
    if (m_bRankSelect) {
        
        [self.fontRank setColor:ccc3(0xFF, 0x80, 0x80)];
        [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", SaveData_GetRank()]];
    }
    else {
        [self.fontRank setColor:ccc3(0xFF, 0xFF, 0xFF)];
        
    }
    
//    [self.fontSe setText:[NSString stringWithFormat:@"SE:%@", Sound_IsEnableSe() ? @"o" : @"x"]];
#ifdef VERSION_LIMITED
    
    // 制限モードはEASYを選べない
//    [self.fontEasy setVisible:NO];
    
#else
    [self.fontEasy setText:[NSString stringWithFormat:@"EASY:%@", SaveData_IsEasy() ? @"o" : @"x"]];
#endif
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
        
        SceneManager_Change(@"GameScene");
        
#ifdef VERSION_LIMITED
        // 広告非表示
        [AppDelegate setVisibleAdWhirlView:NO];
#endif
        
    }
}

/**
 * ランク選択の矩形にヒットしているかどうか
 */
- (BOOL)isHitRankSelect:(float)x y:(float)y {
    
#ifdef VERSION_LIMITED
    
    // 制限モードはランク選択不可
    return NO;
#endif
    
    CGRect rect = CGRectMake(RANK_SELECT_RECT_X, RANK_SELECT_RECT_Y, RANK_SELECT_RECT_W, RANK_SELECT_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        return YES;
    }
    
    return NO;
}

///**
// * ゲーム開始の矩形にヒットしているかどうか
// */
//- (BOOL)isHitSe:(float)x y:(float)y {
//    
//    CGRect rect = CGRectMake(SE_BUTTON_RECT_X, SE_BUTTON_RECT_Y, SE_BUTTON_RECT_W, SE_BUTTON_RECT_H);
//    CGPoint p = CGPointMake(x, y);
//    
//    if (Math_IsHitRect(rect, p)) {
//        return YES;
//    }
//    
//    return NO;
//}

//- (BOOL)isHitEasy:(float)x y:(float)y {
//    
//#ifdef VERSION_LIMITED
//    
//    // 制限モードはEASY選択不可
//    return NO;
//#endif
//    CGRect rect = CGRectMake(EASY_BUTTON_RECT_X, EASY_BUTTON_RECT_Y, EASY_BUTTON_RECT_W, EASY_BUTTON_RECT_H);
//    CGPoint p = CGPointMake(x, y);
//    
//    if (Math_IsHitRect(rect, p)) {
//        return YES;
//    }
//    
//    return NO;
//}

/**
 * タッチ開始
 */
- (void)cbTouchStart:(float)x y:(float)y {
    m_RankPrev = SaveData_GetRank();
    
    // ■ランク選択タッチ判定
    m_bRankSelect = NO;
    {
        
        if ([self isHitRankSelect:x y:y]) {
            
            // タッチした
            Sound_PlaySe(@"pi.wav");
            
            m_bRankSelect = YES;
        }
    }
    
//    // ■SEタッチ判定
//    {
//        
//        if ([self isHitSe:x y:y]) {
//            
//            // タッチした
//            Sound_PlaySe(@"pi.wav");
//            
//            m_bSe = YES;
//        }
//    }
    
//    // ■EASYタッチ判定
//    {
//        
//        if ([self isHitEasy:x y:y]) {
//            
//            // タッチした
//            Sound_PlaySe(@"pi.wav");
//            
//            m_bEasy = YES;
//        }
//    }
    
    // タッチ開始座標を保持
    m_TouchStartX = x;
    m_TouchStartY = y;
    
}

/**
 * タッチ移動中
 */
- (void)cbTouchMove:(float)x y:(float)y {
    
    if ([self isTouchRankSelect]) {
        
        // ランク選択有効
        int rank = m_RankPrev;
        
        float vx = x - m_TouchStartX;
        rank += 10 * (int)(vx / 10);
        
        if (rank < 1) {
            rank = 1;
            m_TouchStartX = x;
        }
        
        if (rank != m_RankPrev) {
            m_RankPrev = rank;
            m_TouchStartX = x;
        }
        
        if (SaveData_SetRank(rank)) {
            // 設定できた
            if (vx < 0) {
                
                // 左
                [self.back moveCursorL];
            }
            else {
                
                // 右
                [self.back moveCursorR];
            }
            
            Sound_PlaySe(@"pi.wav");
        }
    }
    
//    // SEタッチ判定
//    {
//        
//        if ([self isHitSe:x y:y] == NO) {
//            
//            // フォーカスが外れた
//            m_bSe = NO;
//        }
//        
//        if (m_bSe == NO) {
//            if ([self isHitSe:x y:y]) {
//                
//                // フォーカスに入った
//                Sound_PlaySe(@"pi.wav");
//                m_bSe = YES;
//            }
//        }
//    }
//    // EASYタッチ判定
//    {
//        
//        if ([self isHitEasy:x y:y] == NO) {
//            
//            // フォーカスが外れた
//            m_bEasy = NO;
//        }
//        
//        if (m_bEasy == NO) {
//            if ([self isHitEasy:x y:y]) {
//                
//                // フォーカスに入った
//                Sound_PlaySe(@"pi.wav");
//                m_bEasy = YES;
//            }
//        }
//    }
}

/**
 * タッチ終了
 */
- (void)cbTouchEnd:(float)x y:(float)y {
    
//    if (m_bSe) {
//        Sound_SetEnableSe(Sound_IsEnableSe() ? NO : YES);
//    }
//    if (m_bEasy) {
//        SaveData_SetEasy(SaveData_IsEasy() ? NO : YES);
//    }
    
    // タッチ終了
    m_bRankSelect = NO;
//    m_bSe = NO;
//    m_bEasy = NO;
}

// ランク選択タッチ中
- (BOOL)isTouchRankSelect {
    return m_bRankSelect;
}

//// SE ON/OFF タッチ中
//- (BOOL)isTouchSe {
//    return m_bSe;
//}

//// EASY ON/OFF タッチ中
//- (BOOL)isTouchEasy {
//    return m_bEasy;
//}

@end
