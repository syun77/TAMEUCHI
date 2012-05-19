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

// シングルトン
static TitleScene* scene_ = nil;

@implementation TitleScene

@synthesize back;
@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize asciiFont;
@synthesize fontHiScore;
@synthesize fontRank;
@synthesize fontRankMax;
@synthesize fontCopyRight;

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
    
    self.back = [BackTitle node];
    [self.baseLayer addChild:self.back];
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.asciiFont = [AsciiFont node];
    [self.asciiFont createFont:self.baseLayer length:24];
    [self.asciiFont setPos:9 y:17];
    [self.asciiFont setScale:2];
    [self.asciiFont setText:@"TAMEUCHI"];
    
    self.fontHiScore = [AsciiFont node];
    [self.fontHiScore createFont:self.baseLayer length:24];
    [self.fontHiScore setPos:10 y:12];
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:10 y:11];
    [self.fontRank setText:[NSString stringWithFormat:@"RANK     %3d", SaveData_GetRank()]];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:10 y:10];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK  %d", SaveData_GetRankMax()]];
    
    self.fontCopyRight = [AsciiFont node];
    [self.fontCopyRight createFont:self.baseLayer length:24];
    [self.fontCopyRight setPos:16 y:1];
    [self.fontCopyRight setScale:0.75];
    [self.fontCopyRight setAlign:eFontAlign_Center];
    [self.fontCopyRight setText:[NSString stringWithFormat:@"(c) 2dgames.jp 2012"]];
    
    // 変数初期化
    m_bNextScene = NO;
    m_TouchStartX = 0;
    m_TouchStartY = 0;
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    // 入力コールバック登録
    [self.interfaceLayer addCB:self];
    
    return self;
}

// デストラクタ
- (void)dealloc {
    
    self.fontCopyRight = nil;
    self.fontRankMax = nil;
    self.fontRank = nil;
    self.fontHiScore = nil;
    self.asciiFont = nil;
    self.interfaceLayer = nil;
    self.back = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

// 更新
- (void)update:(ccTime)dt {
    
    // ランク数更新
    if (m_bRankSelect) {
        
        [self.fontRank setColor:ccc3(0xFF, 0x80, 0x80)];
        [self.fontRank setText:[NSString stringWithFormat:@"RANK     %3d", SaveData_GetRank()]];
    }
    else {
        [self.fontRank setColor:ccc3(0xFF, 0xFF, 0xFF)];
        
    }
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
        
        SceneManager_Change(@"GameScene");
        
    }
}

- (void)cbTouchStart:(float)x y:(float)y {
    m_RankPrev = SaveData_GetRank();
    
    
    CGRect rect = CGRectMake(RANK_SELECT_RECT_X, RANK_SELECT_RECT_Y, RANK_SELECT_RECT_W, RANK_SELECT_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        
        Sound_PlaySe(@"pi.wav");
        
        m_bRankSelect = YES;
    }
    else {
        m_bRankSelect = NO;
    }
    
    // タッチ開始座標を保持
    m_TouchStartX = x;
    m_TouchStartY = y;
    
}

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

- (void)cbTouchEnd:(float)x y:(float)y {
    
    float len = [self.interfaceLayer getMoveLength];
    if (len < 10) {
        
        // 移動距離が少なければタッチしたものとする
        Sound_PlaySe(@"push.wav");
        m_bNextScene = YES;
    }
    
    // タッチ終了
    m_bRankSelect = NO;
}

// ランク選択タッチ中
- (BOOL)isTouchRankSelect {
    return m_bRankSelect;
}

@end
