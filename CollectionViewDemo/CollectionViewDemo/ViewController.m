//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by zhoujinrui on 16/2/23.
//  Copyright © 2016年 Topvogues. All rights reserved.
//

#import "ViewController.h"
#import "LabelCell.h"
#import "UICollectionView+TVReordering.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <NSString *> *dataList;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    longPressGesture.delegate = self;
    [self.collectionView addGestureRecognizer:longPressGesture];
}

- (NSMutableArray<NSString *> *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray arrayWithCapacity:100];
        for (NSInteger i = 0; i < 100; ++i)
        {
            [_dataList addObject:[NSString stringWithFormat:@"%zd", i]];
        }
    }
    return _dataList;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCell" forIndexPath:indexPath];
    cell.counterLabel.text = self.dataList[indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item > 0 && indexPath.item < self.dataList.count;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    NSString *obj = self.dataList[sourceIndexPath.item];
    [self.dataList removeObjectAtIndex:sourceIndexPath.item];
    [self.dataList insertObject:obj atIndex:destinationIndexPath.item];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
            if (indexPath)
            {
                BOOL result = [self.collectionView tv_beginInteractiveMovementForItemAtIndexPath:indexPath];
                if (!result)
                {
                    indexPath = nil;
                }
            }
            
            if (!indexPath)
            {
                gesture.state = UIGestureRecognizerStateFailed;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView tv_updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView tv_endInteractiveMovement];
            break;
        }
        default:
        {
            [self.collectionView tv_cancelInteractiveMovement];
            break;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    return indexPath && [self collectionView:self.collectionView canMoveItemAtIndexPath:indexPath];
}

@end
