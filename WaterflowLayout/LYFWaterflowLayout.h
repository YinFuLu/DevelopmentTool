//
//  LYFWaterflowLayout.h
//  UICollectionViewDemo
//
//  Created by LYF on 14/11/26.
//  Copyright © 2014年 LYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYFWaterflowLayout;

@protocol LYFWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(LYFWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(LYFWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(LYFWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(LYFWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(LYFWaterflowLayout *)waterflowLayout;
@end

@interface LYFWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<LYFWaterflowLayoutDelegate> delegate;

@end