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


enum eScene {
    eScene_Main,    // メインゲーム
    eScene_Option,  // オプション画面
};

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
@synthesize btnGamemode;
@synthesize btnOption;


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
 * ランク選択の表示を切り替える
 */
- (void)setRankSelect:(BOOL)b {
    
    BackTitle* backTitle = [TitleScene sharedInstance].back;
    
    
    [backTitle setRankSelect:b];
}

/**
 * スタートボタン押したコールバック
 */
- (void)cbBtnStart {
    
    Sound_PlaySe(@"push.wav");
    
    // メインゲーム開始
    m_bNextScene = YES;
    m_NextSceneId = eScene_Main;
}


/**
 * ゲームモードの表示を切り替える
 */
- (void)setBtnGamemode {
    
    int hiScore = 0;
    int rank    = 0;
    int hiRank  = 0;
    if (SaveData_IsScoreAttack()) {
        
        // スコアアタックモード
        [self.btnGamemode setText:@"SCORE ATTACK"];
        hiScore = SaveData2_GetHiScore();
        rank    = SaveData2_GetRank();
        hiRank  = SaveData2_GetRankMax();
        [self setRankSelect:NO];
    }
    else {
        
        [self.btnGamemode setText:@"FREE PLAY"];
        hiScore = SaveData_GetHiScore();
        rank    = SaveData_GetRank();
        hiRank  = SaveData_GetRankMax();
        [self setRankSelect:YES];
    }
    
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", hiScore]];
    
    [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", rank]];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK  %d", hiRank]];
}

/**
 * ゲームモードの切り替え
 */
- (void)cbBtnGamemove {
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsScoreAttack()) {
        
        SaveData_SetScoreAttack(NO);
    }
    else {
        
        SaveData_SetScoreAttack(YES);
    }
    
    [self setBtnGamemode];
}

/**
 * Optionボタン押したコールバック
 */
- (void)cbBtnOption {
    Sound_PlaySe(@"push.wav");
    
    m_NextSceneId = eScene_Option;
    m_bNextScene = YES;
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
    [self.fontHiScore setPos:10 y:13];
//    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:10 y:12];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:10 y:11];
//    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK  %d", SaveData_GetRankMax()]];
    
    self.fontCopyRight = [AsciiFont node];
    [self.fontCopyRight createFont:self.baseLayer length:24];
    [self.fontCopyRight setPos:17 y:1];
    [self.fontCopyRight setScale:0.75];
    [self.fontCopyRight setAlign:eFontAlign_Center];
    [self.fontCopyRight setText:@"(c) 2012 2dgames.jp"];
    
    
    self.btnStart = [Button node];
    [self.btnStart initWith:self.interfaceLayer text:@"START" cx:START_BUTTON_CX cy:START_BUTTON_CY w:START_BUTTON_W h:START_BUTTON_H cls:self onDecide:@selector(cbBtnStart)];
    
    self.btnGamemode = [Button node];
    [self.btnGamemode initWith:self.interfaceLayer text:@"" cx:GAMEMODE_BUTTON_CX cy:GAMEMODE_BUTTON_CY w:GAMEMODE_BUTTON_W h:GAMEMODE_BUTTON_H cls:self onDecide:@selector(cbBtnGamemove)];
    
    self.btnOption = [Button node];
    [self.btnOption initWith:self.interfaceLayer text:@"OPTION" cx:OPTION_BUTTON_CX cy:OPTION_BUTTON_CY w:OPTION_BUTTON_W h:OPTION_BUTTON_H cls:self onDecide:@selector(cbBtnOption)];
    
    // 変数初期化
    m_NextSceneId = eScene_Main;
    m_bNextScene = NO;
    m_TouchStartX = 0;
    m_TouchStartY = 0;
    m_bRankSelect = NO;
    
    // 最初は非表示にしておく
    [self.baseLayer setVisible:NO];
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    // 入力コールバック登録
    [self.interfaceLayer addCB:self];
    
    m_bInit = NO;
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    self.btnOption = nil;
    self.btnGamemode = nil;
    self.btnStart = nil;
    
    self.fontCopyRight = nil;
    self.fontRankMax = nil;
    self.fontRank = nil;
    self.fontHiScore = nil;
    self.fontLite = nil;
    self.asciiFont = nil;
    self.interfaceLayer = nil;
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
        
        // ゲームモードの表示を更新
        [self setBtnGamemode];
        
        // 表示を有効にする
        [self.baseLayer setVisible:YES];
        
        m_bInit = YES;
    }
    
    // ランク数更新
    if (m_bRankSelect) {
        
        
        if (SaveData_IsScoreAttack()) {
            
            // スコアアタックモード
            [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", SaveData2_GetRank()]];
        }
        else {
            
            // フリープレイモード
            [self.fontRank setColor:ccc3(0xFF, 0x80, 0x80)];
            [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", SaveData_GetRank()]];
        }
        
    }
    else {
        [self.fontRank setColor:ccc3(0xFF, 0xFF, 0xFF)];
        
    }
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
       
        switch (m_NextSceneId) {
            case eScene_Main:
                
                // 次のシーンに進む
                SceneManager_Change(@"GameScene");
        
#ifdef VERSION_LIMITED
                // 広告非表示
                [AppDelegate setVisibleAdWhirlView:NO];
#endif
                break;
                
            case eScene_Option:
                
                // オプション画面に遷移する
                SceneManager_Change(@"OptionScene");
                break;
                
            default:
                break;
        }
        
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
    
}

/**
 * タッチ終了
 */
- (void)cbTouchEnd:(float)x y:(float)y {
    
    // タッチ終了
    m_bRankSelect = NO;
}

// ランク選択タッチ中
- (BOOL)isTouchRankSelect {
    
    if (SaveData_IsScoreAttack()) {
        
        // スコアアタックモードはランク選択できない
        return NO;
    }
    
    return m_bRankSelect;
}

@end
