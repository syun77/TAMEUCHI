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
    [self.asciiFont setPos:8 y:12];
    [self.asciiFont setText:@"TITLE"];
    
    self.fontHiScore = [AsciiFont node];
    [self.fontHiScore createFont:self.baseLayer length:24];
    [self.fontHiScore setPos:8 y:11];
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:8 y:10];
    [self.fontRank setText:@"RANK"];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:8 y:9];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK %d", SaveData_GetRankMax()]];
    
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
    
    [self.fontRank setText:[NSString stringWithFormat:@"RANK %3d", SaveData_GetRank()]];
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
        
        SceneManager_Change(@"GameScene");
        
    }
}

- (void)cbTouchStart:(float)x y:(float)y {
    m_RankPrev = SaveData_GetRank();
    
}

- (void)cbTouchMove:(float)x y:(float)y {
    
    int rank = m_RankPrev;
    
    float vx = [self.interfaceLayer getPosX] - [self.interfaceLayer startX];
    rank += 10 * (int)(vx / 30);
    if (rank < 1) {
        rank = 1;
    }
    
    SaveData_SetRank(rank);
}

- (void)cbTouchEnd:(float)x y:(float)y {
    
    float len = [self.interfaceLayer getMoveLength];
    if (len < 30) {
        
        // 移動距離が少なければタッチしたものとする
        m_bNextScene = YES;
    }
}

@end
