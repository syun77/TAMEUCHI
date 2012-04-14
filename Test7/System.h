//
//  System.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/08.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Retinaディスプレイかどうか
BOOL System_IsRetina();

// ウィンドウサイズを取得する
CGSize System_Size();

// ウィンドウの幅を取得する
float System_Width();

// ウィンドウの高さを取得する
float System_Height();

// 中心座標(X)を取得する
float System_CenterX();

// 中心座標(Y)を取得する
float System_CenterY();

// 当たり判定を描画するかどうか
bool System_IsDispCollision();
