//
//  InterfaceLayer.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"

#import "GameScene.h"

@implementation InterfaceLayer

- (void)onEnter {
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    // タッチ座標を初期化
    Vec2D_Init(&m_Pos);
    m_isTouch = NO;
}

- (void)onExit {
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    GameScene* scene = [GameScene sharedInstance];
    
    CGPoint locationView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
    
    // タッチ座標を設定
    Vec2D_Set(&m_Pos, location.x, location.y);
    
    // タッチ状態を更新
    m_isTouch = YES;
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint locationView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
    
    // タッチ座標を設定
    Vec2D_Set(&m_Pos, location.x, location.y);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // タッチ状態を更新
    m_isTouch = NO;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // タッチ状態を更新
    m_isTouch = NO;
}

// タッチしているかどうか
- (BOOL)isTouch {
    return m_isTouch;
}

// タッチしている座標を取得
- (Vec2D)getPos {
    return m_Pos;
}

@end
