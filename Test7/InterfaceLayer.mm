//
//  InterfaceLayer.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "InterfaceLayer.h"

#import "GameScene.h"

@implementation InterfaceLayer

/**
 * 開始
 */
- (void)onEnter {
    
    // スケジューラ起動
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    // タッチ座標を初期化
    m_isTouch = NO;
    m_StartX = 0;
    m_StartY = 0;
    m_X = 0;
    m_Y = 0;
}

/**
 * 終了
 */
- (void)onExit {
    
    // スケジューラ削除
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

/**
 * タッチ開始
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint locationView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
    
    // タッチ座標を設定
    m_StartX = location.x;
    m_StartY = location.y;
    m_X = location.x;
    m_Y = location.y;
    
    GameScene* scene = [GameScene sharedInstance];
    [scene.player setStartPos:location.x y:location.y];
    
    // タッチ状態を更新
    m_isTouch = YES;
    
    return YES;
}

/**
 * タッチ座標更新
 */
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint locationView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
    
    // タッチ座標を設定
    m_X = location.x;
    m_Y = location.y;
}

/**
 * タッチ終了
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // タッチ状態を更新
    m_isTouch = NO;
}

/**
 * タッチキャンセル
 */
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // タッチ状態を更新
    m_isTouch = NO;
}

// タッチしているかどうか
- (BOOL)isTouch {
    return m_isTouch;
}

// タッチ開始座標
- (float)startX {
    return m_StartX;
}

- (float)startY {
    return m_StartY;
}

// タッチ開始座標をリセットする
- (void)resetStartPos {
    m_StartX = m_X;
    m_StartY = m_Y;
}

// タッチしている座標を取得
- (float)getPosX {
    return m_X;
}

- (float)getPosY {
    return m_Y;
}

@end
