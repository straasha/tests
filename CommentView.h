//
//  CommentView.h
//  mermaid_komatsu_20120821
//
//  Created by  on 12/09/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "CommentEditViewController.h"
#import "LoadingView.h"
#import "Image.h"
#import "ErrorView.h"
#import "QueueView.h"

@class AppController;

@interface CommentView : BaseView
<
  UITextFieldDelegate,
  UITextViewDelegate,
  UITableViewDelegate,
  UITableViewDataSource,
  CommentEditViewDelegate,
  ErrorViewDelegate,
  QueueViewDelegate
>

@property( nonatomic, retain ) ErrorView *errView;
@property( nonatomic, retain ) QueueView *queueView;
@property( nonatomic, retain ) UIImageView *commentBgView;
@property( nonatomic, retain ) UILabel *label;
@property( nonatomic, retain ) UILabel *toolBarlabel;
@property( nonatomic, retain ) UILabel *stringCountLabel;
@property( nonatomic, retain ) UITextField *textFieldS;
@property( nonatomic, retain ) UILabel *dummyTextView;
@property( nonatomic, retain ) UIButton *editStartButton;
@property( nonatomic, retain ) UIButton *commentCancelButton;
@property( nonatomic, retain ) UIButton *commentSendButton;
@property( nonatomic, retain ) UIToolbar *toolBar;
@property( nonatomic, retain ) UIButton *onFixedCommentEditButton;
@property( nonatomic, retain ) UITableView *commentListTable;
@property( nonatomic, retain ) UIButton *returnToTopButton;
@property( nonatomic, retain ) UIButton *rematchButton;
@property( nonatomic, retain ) NSDictionary *result;
@property( nonatomic, retain ) UIView *topToolBar;
@property( nonatomic, retain ) UIButton *topReturnButton;
@property( nonatomic, retain ) UIButton *topSendButton;
@property( nonatomic, retain ) UIButton *commentUseButton;
@property( nonatomic, retain ) UIImage *commentUseButtonImage;
@property( nonatomic, retain ) UIImageView *windowBgGrayImageView;
@property( nonatomic, retain ) UIImageView *windowBgBottomImageView;
@property( nonatomic, retain ) UIImageView *windowFigureMessageImageView;

@property( nonatomic, assign ) CGPoint keybordOrigin;
@property( nonatomic, assign ) CGSize  keybordSize;
@property( nonatomic, assign ) BOOL isDummyClicked;

-(id)initWithFrame:(CGRect)frame;
-(void)setupBaseWindow;
-(void)setupViews;
-(void)setupRematch;

@end
