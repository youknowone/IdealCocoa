//
//  UITableViewCellCopyable.h
//  IdealCocoa
//
//  Created by youknowone on 11. 6. 21..
//  Copyright 2011 3rddev.org. All rights reserved.
//

@protocol ICTableViewCellCopyableDelegate;

@interface ICTableViewCellCopyable : UITableViewCell {
    id<ICTableViewCellCopyableDelegate> delegate;
}

@property(nonatomic, assign) id<ICTableViewCellCopyableDelegate> delegate;

@end

@protocol ICTableViewCellCopyableDelegate<NSObject>
@optional

- (NSString *) dataForCell:(ICTableViewCellCopyable *)cell;
- (void) selectCell:(ICTableViewCellCopyable *)cell;
- (void) deselectCell:(ICTableViewCellCopyable *)cell;

@end