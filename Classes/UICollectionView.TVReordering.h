//
//  UICollectionView+TVReordering.h
//  Sword
//
//  Created by zhoujinrui on 16/1/6.
//  Copyright © 2016年 Topvogues. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 拖动排序
 * @note 实现以下代理方法
 * @code
 * - (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
 * - (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
 * @endcode
 */
@interface UICollectionView (TVReordering)

- (BOOL)tv_beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)tv_updateInteractiveMovementTargetPosition:(CGPoint)targetPosition;
- (void)tv_endInteractiveMovement;
- (void)tv_cancelInteractiveMovement;

@end
