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
float SYstem_CenterY()
{
    return System_Height() / 2.0f;
}