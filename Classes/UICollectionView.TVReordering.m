//
//  UICollectionView+TVReordering.m
//  Sword
//
//  Created by zhoujinrui on 16/1/6.
//  Copyright © 2016年 Topvogues. All rights reserved.
//

#import "UICollectionView+TVReordering.h"
#import "AssociativeStorage.h"

static const char kTVSelectedIndexPath = 0;
static const char kTVScreenShotView = 0;

@implementation UICollectionView (TVReordering)

- (NSIndexPath *)tv_selectedIndexPath
{
    return [AssociativeStorage objectForKey:&kTVSelectedIndexPath withTarget:self];
}

- (void)setTv_selectedIndexPath:(NSIndexPath *)indexPath
{
    [AssociativeStorage setObject:indexPath forKey:&kTVSelectedIndexPath withTarget:self];
}

- (UIView *)tv_screenShotView
{
    return [AssociativeStorage objectForKey:&kTVScreenShotView withTarget:self];
}

- (void)setTv_screenShotView:(UIView *)view
{
    [AssociativeStorage setObject:view forKey:&kTVScreenShotView withTarget:self];
}

- (UICollectionViewCell *)tv_selectedCell
{
    return [self cellForItemAtIndexPath:self.tv_selectedIndexPath];
}

- (BOOL)tv_beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self respondsToSelector:@selector(beginInteractiveMovementForItemAtIndexPath:)])
    {
        return [self beginInteractiveMovementForItemAtIndexPath:indexPath];
    }
    else
    {
        self.tv_selectedIndexPath = nil;
        
        if (indexPath
            && [self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]
            && [self.dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)])
        {
            if ([self.dataSource collectionView:self canMoveItemAtIndexPath:indexPath])
            {
                self.tv_selectedIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self tv_selectedCell];
                UIView *screenShotView = [cell snapshotViewAfterScreenUpdates:NO];
                screenShotView.frame = cell.frame;
                [cell.superview addSubview:screenShotView];
                
                cell.hidden = YES;
                self.tv_screenShotView = screenShotView;
            }
        }
        
        NSAssert([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)], @"Expect collectionView:canMoveItemAtIndexPath:");
        NSAssert([self.dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)], @"Expect collectionView:moveItemAtIndexPath:toIndexPath:");
        
        return self.tv_selectedIndexPath != nil;
    }
}

- (void)tv_updateInteractiveMovementTargetPosition:(CGPoint)targetPosition
{
    if ([self respondsToSelector:@selector(updateInteractiveMovementTargetPosition:)])
    {
        [self updateInteractiveMovementTargetPosition:targetPosition];
    }
    else
    {
        UIView *screenShotView = self.tv_screenShotView;
        screenShotView.center = targetPosition;
        
        NSIndexPath *selectedIndexPath = [self tv_selectedIndexPath];
        NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:targetPosition];
        if (targetIndexPath
            && ![targetIndexPath isEqual:selectedIndexPath])
        {
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]
                && [self.dataSource collectionView:self canMoveItemAtIndexPath:targetIndexPath])
            {
                [self moveItemAtIndexPath:selectedIndexPath toIndexPath:targetIndexPath];
                [self.dataSource collectionView:self moveItemAtIndexPath:selectedIndexPath toIndexPath:targetIndexPath];
                self.tv_selectedIndexPath = targetIndexPath;
            }
        }
    }
}

- (void)tv_endInteractiveMovement
{
    if ([self respondsToSelector:@selector(endInteractiveMovement)])
    {
        [self endInteractiveMovement];
    }
    else
    {
        [self didEndInteractiveMovement];
    }
}

- (void)tv_cancelInteractiveMovement
{
    if ([self respondsToSelector:@selector(cancelInteractiveMovement)])
    {
        [self cancelInteractiveMovement];
    }
    else
    {
        [self didEndInteractiveMovement];
    }
}

- (void)didEndInteractiveMovement
{
    UICollectionViewCell *cell = [self tv_selectedCell];
    NSAssert(cell, @"");
    
    UIView *screenShotView = self.tv_screenShotView;
    
    [UIView animateWithDuration:0.25 animations:^{
        screenShotView.center = cell.center;
    } completion:^(BOOL finished) {
        [screenShotView removeFromSuperview];
        self.tv_screenShotView = nil;
        self.tv_selectedIndexPath = nil;
        cell.hidden = NO;
    }];
}

@end
