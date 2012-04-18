//
//  System.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/08.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "System.h"

/**
 * Retinaディスプレイかどうか
 */
BOOL System_IsRetina()
{
    return NO;
}

/**
 * ウィンドウサイズを取得する
 */
CGSize System_Size()
{
    return  [CCDirector sharedDirector].winSize;
}

/**
 * ウィンドウの幅を取得する
 */
float System_Width()
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    return winSize.width;
}

/**
 * ウィンドウの高さを取得する
 */
float System_Height()
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    return winSize.height;
}

/**
 * 中心座標(X)を取得する
 */
float System_CenterX()
{
    return System_Width() / 2.0f;
}

/**
 * 中心座標(Y)を取得する
 */
float System_CenterY()
{
    return System_Height() / 2.0f;
}

/**
 * 当たり判定を描画するかどうか
 */
bool System_IsDispCollision()
{
//    return YES;
    return NO;
}

// ブレンドモードの設定
void System_SetBlend(eBlend mode) {
    switch (mode) {
        case eBlend_Add:
            glBlendFunc(GL_SRC_ALPHA, GL_ONE);
            break;
            
        case eBlend_Normal:
            glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
            break;
            
        default:
            break;
    }
}
