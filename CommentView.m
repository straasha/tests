//
//  CommentView.m
//  mermaid_komatsu_20120821
//
//  Created by  on 12/09/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentView.h"
#import "AppDelegate.h"

@implementation CommentView

@synthesize label, dummyTextView, textFieldS, stringCountLabel;
@synthesize commentCancelButton, commentSendButton, returnToTopButton, rematchButton;
@synthesize toolBar;
@synthesize onFixedCommentEditButton;
@synthesize commentListTable;
@synthesize keybordOrigin, keybordSize;
@synthesize result, errView, queueView;
@synthesize topToolBar, topReturnButton, topSendButton;
@synthesize isDummyClicked;
//@synthesize baseView;
@synthesize commentBgView;
@synthesize commentUseButton;
@synthesize commentUseButtonImage;
@synthesize windowBgGrayImageView;
@synthesize windowBgBottomImageView;
@synthesize windowFigureMessageImageView;
@synthesize toolBarlabel;

//------------------------------------------------------------//
//メモリ解放
//------------------------------------------------------------//
-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.errView = nil;
  self.queueView = nil;
  //self.baseView = nil;
  self.commentBgView = nil;
  self.label = nil;
  self.stringCountLabel = nil;
  self.textFieldS = nil;
  self.dummyTextView = nil;
  self.commentCancelButton = nil;
  self.commentSendButton = nil;
  self.toolBar = nil;
  self.onFixedCommentEditButton = nil;
  self.commentListTable = nil;
  self.returnToTopButton = nil;
  self.rematchButton = nil;
  self.result = nil;
  self.topToolBar = nil;
  self.toolBarlabel = nil;
  self.topReturnButton = nil;
  self.topSendButton = nil;
  self.commentUseButton = nil;
  self.commentUseButtonImage = nil;
  self.windowBgGrayImageView = nil;
  self.windowBgBottomImageView = nil;
  self.windowFigureMessageImageView = nil;
  [super dealloc];
}

//------------------------------------------------------------//
//初期処理
//------------------------------------------------------------//
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.5] autorelease];
    self.isDummyClicked = NO;
  }
  return self;
}

//------------------------------------------------------------//
//初期処理
//------------------------------------------------------------//
- (id)init
{
  self = [super init];
  if (self) {
    self.backgroundColor = [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.5] autorelease];
    self.isDummyClicked = NO;
  }
  return self;
}

//------------------------------------------------------------//
//画面に表示するパーツをセットする
//------------------------------------------------------------//
-(void)setupViews
{
 //下地
  [self setupBaseWindow];
  
  //センタリグするためのスペーサー
  UIBarButtonItem *spacer = [[[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    target:nil
    action:nil
  ]autorelease];

  //ボタンをツールバーにセット
  [self.toolBar setItems:[NSArray arrayWithObjects:
    spacer,
    self.onFixedCommentEditButton,
    nil
  ]];
  
  //コメント入力欄の背景を設定する
  [self setupWindowCommentBg];
    
  //TOPツールバーセット
  [self setupTopToolBar];  
  [self setupTopReturnButton];
  [self setupTopSendButton];
  [self setupToolBarLabel :@"コメント入力"];
  
  //入力フィールド
  [self setupTextField];
    
  //文字数表示
  [self setupCountLabel];
    
  //定型文一覧ツールバー
  [self setupToolBar];

  //定型文編集ボタン
  //[self setupEditButton];
  
  //定型文の一覧をテーブルビューで表示する
  [self setupcommentListTable];

  [google viewTrack :@"対戦メッセージ"];
}

//------------------------------------------------------------//
//ユーザ名を表示
//------------------------------------------------------------//
-(void)setupToolBarLabel :(NSString *)string
{
  self.toolBarlabel = [[[UILabel alloc] init] autorelease];
  self.toolBarlabel.text = string;
  self.toolBarlabel.font =  [UIFont fontWithName:@"HiraKakuProN-W3"size:20];
  self.toolBarlabel.textColor = [UIColor whiteColor];
  self.toolBarlabel.frame = self.topToolBar.frame;
  self.toolBarlabel.backgroundColor = [UIColor clearColor];
  self.toolBarlabel.textAlignment = UITextAlignmentCenter;
  [self.topToolBar addSubview :self.toolBarlabel];
}

//------------------------------------------------------------//
//TOPツールバーのセット
//------------------------------------------------------------//
-(void)setupTopToolBar
{
  UIImage *image = [Image file2UIImage :@"bg_header.png"];
  self.topToolBar = [[[UIView alloc] init] autorelease];
  self.topToolBar.backgroundColor = [UIColor colorWithPatternImage:image];
  self.topToolBar.frame = [self rectMake:0 :0 :image.size.width :image.size.height];
  self.topToolBar.hidden = YES;
  [self addSubview :self.topToolBar];
}

//------------------------------------------------------------//
//戻るボタン
//------------------------------------------------------------//
-(void)setupTopReturnButton
{
  //画像のボタンを作成
  UIImage *image = [Image file2UIImage :@"btn_header_back.png"];
  self.topReturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.topReturnButton setBackgroundImage :image forState:UIControlStateNormal];
  [self.topReturnButton
    addTarget :self
    action :@selector( topReturnButtonPush: ) forControlEvents:UIControlEventTouchUpInside
  ];
  
  //位置調整
  CGFloat x = 5 + self.topToolBar.frame.origin.x;
  CGFloat y = (self.topToolBar.frame.size.height - image.size.height ) / 2;
  self.topReturnButton.frame = [self rectMake:x :y :image.size.width :image.size.height];
  
  //表示
  [self.topToolBar addSubview :self.topReturnButton];
}

//------------------------------------------------------------//
//送るボタン
//------------------------------------------------------------//
-(void)setupTopSendButton
{
  //画像のボタンを作成
  UIImage *image = [Image file2UIImage :@"btn_header_send.png"];
  self.topSendButton = [[[UIButton alloc] init] autorelease];
  [self.topSendButton setBackgroundImage :image forState:UIControlStateNormal];
  [self.topSendButton
    addTarget :self
    action :@selector( topSendButtonPush: ) forControlEvents:UIControlEventTouchUpInside
  ];
  
  //位置調整
  CGFloat x = self.topToolBar.frame.size.width - image.size.width - 2;
  CGFloat y = (self.topToolBar.frame.size.height - image.size.height ) / 2 - 1;
  self.topSendButton.frame = [self rectMake:x :y :image.size.width :image.size.height];

  //表示
  [self.topToolBar addSubview :self.topSendButton];
}

//------------------------------------------------------------//
//背景
//------------------------------------------------------------//
-(void)setupWindowCommentBg
{
    UIImage *windowCommentBgImage = [UIImage imageNamed:@"bg2.png"];
    self.commentBgView = [[[UIImageView alloc] initWithImage :windowCommentBgImage] autorelease];
    self.commentBgView.frame = [self rectMake :0 :0 :self.frame.size.width :self.frame.size.height];
    self.commentBgView.hidden = YES;
    //[self.baseView addSubview :self.commentBgView];
    [self addSubview :self.commentBgView];
}

//------------------------------------------------------------//
//入力フィールド
//------------------------------------------------------------//
-(void)setupTextField
{
  self.textFieldS = [[[UITextField alloc] init] autorelease];
  self.textFieldS.borderStyle = UITextBorderStyleBezel;
  self.textFieldS.frame = [self rectMake :20 :180 :280 :30];
  self.textFieldS.text = @"";
  self.textFieldS.tag = 1;
  self.textFieldS.delegate = self;
  self.textFieldS.hidden = YES;
  [self addSubview :self.textFieldS];
}

//------------------------------------------------------------//
//------------------------------------------------------------//
-(void)setupCountLabel{
  self.stringCountLabel = [[[UILabel alloc] init] autorelease];
  self.stringCountLabel.textAlignment = UITextAlignmentRight;
  self.stringCountLabel.numberOfLines = 0;
  self.stringCountLabel.frame = [self rectMake :10 :86 :300 :30];
  self.stringCountLabel.font = [UIFont systemFontOfSize:12];
  self.stringCountLabel.hidden = YES;
  //[self.baseView addSubview :self.stringCountLabel];
  [self addSubview :self.stringCountLabel];
}

//------------------------------------------------------------//
//------------------------------------------------------------//
-(void)setupToolBar
{
    UIImage *toolBarImage = [Image file2UIImage :@"title_fix.png"];
    self.toolBar = [[[UIToolbar alloc] init] autorelease];
    self.toolBar.frame = [self rectMake:0 :120 :toolBarImage.size.width :toolBarImage.size.height];
    self.toolBar.hidden = YES;
    [self.toolBar setBackgroundImage:toolBarImage
       forToolbarPosition:UIToolbarPositionAny
       barMetrics:UIBarMetricsDefault];
    //[self.baseView addSubview :self.toolBar];
    [self addSubview :self.toolBar];
}

//------------------------------------------------------------//
//------------------------------------------------------------//
-(void)setupEditButton
{
  //画像のボタンを作成
  UIImage *image = [Image file2UIImage :@"fix_btn_edit.png"];
  self.onFixedCommentEditButton = [[[UIButton alloc] init] autorelease];
  [self.onFixedCommentEditButton setBackgroundImage :image forState:UIControlStateNormal];
  [self.onFixedCommentEditButton
    addTarget : self
    action : @selector(onFixedCommentEditButtoPush:)
    forControlEvents : UIControlEventTouchUpInside
  ];
  //位置調整
  self.onFixedCommentEditButton.frame = [self rectMake:252 :6 :image.size.width :image.size.height];
  //表示
  [self.toolBar addSubview :self.onFixedCommentEditButton];

}

//------------------------------------------------------------//
//テーブルリストを設定する
//------------------------------------------------------------//
-(void)setupcommentListTable
{
  if( self.commentListTable == nil ){
    self.commentListTable = [[[UITableView alloc]
      initWithFrame :[self rectMake
        :0
        :self.toolBar.frame.origin.y + self.toolBar.frame.size.height
        :self.frame.size.width
        :self.frame.size.height - (self.toolBar.frame.origin.y + self.toolBar.frame.size.height)
      ]
      style :UITableViewStylePlain
    ]autorelease];
    [self addSubview :self.commentListTable];
  }
  else{
    [self.commentListTable reloadData];
  }

  self.commentListTable.backgroundColor = [UIColor clearColor];
  self.commentListTable.bounces = NO;
  self.commentListTable.delegate = self;
  self.commentListTable.dataSource = self;
  self.commentListTable.hidden = YES;
  //self.commentListTable.allowsSelection = NO;
  self.commentListTable.rowHeight = 36;
  self.commentListTable.separatorStyle = UITableViewCellSelectionStyleNone;

  //「使う」ボタンの画像を設定する
  commentUseButtonImage = [Image file2UIImage:@"fix_btn_use.png"];
}

//------------------------------------------------------------//
//下地
//------------------------------------------------------------//
-(void)setupBaseWindow
{
  //メッセージタイトル
  UIImage *image = [UIImage imageNamed:@"window_title_message.png"];
  UIView *windowTitleView = [[[UIView alloc] init] autorelease];
  windowTitleView.backgroundColor = [UIColor colorWithPatternImage :image];
  windowTitleView.frame = [self rectMake
    :(app.width - image.size.width)/2
    :100
    :image.size.width
    :image.size.height
  ];
  //[self.baseView addSubview :windowTitleView];
  [self addSubview :windowTitleView];
  
  //星の背景
  image = [UIImage imageNamed:@"window_bg_star.png"];
  UIView *windowBgStarView = [[[UIView alloc] init] autorelease];
  windowBgStarView.backgroundColor = [UIColor colorWithPatternImage :image];
  windowBgStarView.frame = [self rectMake
    :(app.width - image.size.width)/2
    :windowTitleView.frame.origin.y + windowTitleView.frame.size.height
    :image.size.width
    :image.size.height
  ];
  //[self.baseView addSubview :windowBgStarView];
  [self addSubview :windowBgStarView];
  
  //メッセージ説明
  self.label = [[[UILabel alloc] init] autorelease];
  self.label.frame = [self rectMake
    :windowTitleView.frame.origin.x
    :windowTitleView.frame.origin.y + windowTitleView.frame.size.height
    :windowTitleView.frame.size.width
    :30
  ];
  self.label.text = [NSString stringWithFormat:@"%@%@",
    [app.utaate.enemyInfo.data objectForKey:@"user_name"],@"さんにメッセージを送ろう！"
  ];
  self.label.textAlignment = UITextAlignmentCenter;
  self.label.numberOfLines = 0;
  self.label.backgroundColor = [UIColor clearColor];
  self.label.font = [UIFont systemFontOfSize:12];
  //[self.baseView addSubview :self.label];
  [self addSubview :self.label];
    
  //window_figure_line
  image = [UIImage imageNamed:@"window_figure_line.png"];
  UIImageView *windowFigureLineImageView = [[[UIImageView alloc] initWithImage :image] autorelease];
  windowFigureLineImageView.frame = [self rectMake
    :(app.width - image.size.width) / 2
    :self.label.frame.origin.y + self.label.frame.size.height + 5
    :image.size.width
    :image.size.height
  ];
  //[self.baseView addSubview :windowFigureLineImageView];
  [self addSubview :windowFigureLineImageView];
  
  //「メッセージは１００文字まで入力できます」
  image = [UIImage imageNamed:@"window_figure_message.png"];
  self.windowFigureMessageImageView = [[[UIImageView alloc] initWithImage :image] autorelease];
  self.windowFigureMessageImageView.frame = [self rectMake
    :(app.width - image.size.width) / 2
    :windowFigureLineImageView.frame.origin.y + windowFigureLineImageView.frame.size.height + 5
    :image.size.width
    :image.size.height
  ];
  //[self.baseView addSubview :self.windowFigureMessageImageView];
  [self addSubview :self.windowFigureMessageImageView];

  //白い背景(可変背景)
  image = [UIImage imageNamed:@"window_bg_gray.png"];
  self.windowBgGrayImageView = [[[UIImageView alloc] initWithImage :image] autorelease];
  //[self.baseView addSubview :self.windowBgGrayImageView];
  [self addSubview :self.windowBgGrayImageView];

  //ダミー入力フィールド
  [self setupDummyText];

  //背景の底
  image = [UIImage imageNamed:@"window_bg_bottom.png"];
  self.windowBgBottomImageView = [[[UIImageView alloc] initWithImage :image] autorelease];
  //[self.baseView addSubview :self.windowBgBottomImageView];
  [self addSubview :self.windowBgBottomImageView];
  
  //送るボタン
  UIImage *sendButtonImage = [Image file2UIImage :@"window_btn_send.png"];
  self.commentSendButton = [[[UIButton alloc] init] autorelease];
  self.commentSendButton.frame = [self rectMake
    :60
    :230
    :sendButtonImage.size.width
    :sendButtonImage.size.height
  ];
  [self.commentSendButton setBackgroundImage :sendButtonImage forState:UIControlStateNormal];
  [self.commentSendButton
    addTarget:self
    action:@selector(commentSendButtonPush:) forControlEvents:UIControlEventTouchUpInside
  ];
  [self addSubview :self.commentSendButton];
  
  //閉じるボタン
  UIImage *cancelButtonImage = [Image file2UIImage :@"window_btn_cancel.png"];
  self.commentCancelButton = [[[UIButton alloc] init] autorelease];
  self.commentCancelButton.frame = [self rectMake
    :180
    :228
    :cancelButtonImage.size.width
    :cancelButtonImage.size.height
  ];
  [self.commentCancelButton setBackgroundImage :cancelButtonImage forState:UIControlStateNormal];
  [self.commentCancelButton
   addTarget:self
   action:@selector(commentCancelButtonPush:) forControlEvents:UIControlEventTouchUpInside
   ];
  [self addSubview :self.commentCancelButton];

  //白い背景(可変背景)のサイズを調整する
  self.windowBgGrayImageView.frame = [self rectMake
    :(app.width - image.size.width) / 2
    :windowBgStarView.frame.origin.y + windowBgStarView.frame.size.height
    :image.size.width
    :self.dummyTextView.frame.size.height + 5 + self.commentSendButton.frame.size.height + 5
  ];

  //背景の底のサイズを調整する
  self.windowBgBottomImageView.frame = [self rectMake
    :(app.width - image.size.width) / 2
    :self.windowBgGrayImageView.frame.origin.y + self.windowBgGrayImageView.frame.size.height
    :image.size.width
    :image.size.height
  ];
}

//------------------------------------------------------------//
//メッセージを表示する
//------------------------------------------------------------//
-(void)setupDummyText
{
  //メッセージ表示用のラベルを置く
  self.dummyTextView = [[[UILabel alloc] init] autorelease];
  self.dummyTextView.numberOfLines = 0;
  self.dummyTextView.textColor = [UIColor blackColor];
  self.dummyTextView.frame =[self rectMake:20 :200 :280 :20];
  //[self.baseView addSubview :self.dummyTextView];
  [self addSubview :self.dummyTextView];

  //ラベルの上にボタンを置く
  self.editStartButton = [UIButton buttonWithType :UIButtonTypeCustom];
  self.editStartButton.frame = self.dummyTextView.frame;
  [self.editStartButton
    addTarget:self
    action:@selector(editStartButtonPush:)
    forControlEvents:UIControlEventTouchUpInside
  ];
  //[self.baseView addSubview :self.editStartButton];
  [self addSubview :self.editStartButton];
}

//------------------------------------------------------------//
//メッセージを押したときの処理
//------------------------------------------------------------//
-(void)editStartButtonPush :(id)sender
{
  [google viewTrack :@"対戦メッセージ:メッセージ入力"];
  self.textFieldS.hidden = NO;
  self.textFieldS.text = self.dummyTextView.text;
  if( [self.textFieldS.text isEqualToString:@" "] ) {
    self.textFieldS.text = @"";
  }
  [self.textFieldS becomeFirstResponder];
}

//------------------------------------------------------------//
//定型文の編集ボタンを押したときの処理
//------------------------------------------------------------//
-(void)onFixedCommentEditButtoPush :(id)sender
{
  CommentEditViewController *vc = [[[CommentEditViewController alloc] init] autorelease];
  vc.delegate = self;
  [app.director presentModalViewController:vc animated:NO];
}

//------------------------------------------------------------//
//送信ボタンの画面に戻る
//------------------------------------------------------------//
- (void)returnSendView
{
  //下地をもとに戻して、文言を表示する
  //self.baseView.frame = [self rectMake:0 :0 :self.frame.size.width :self.frame.size.height];
  self.label.hidden = NO;

  //入力エリアを消す
  self.textFieldS.hidden = YES;

  //ダミーの入力エリアに入力エリアの内容を流し込んでを表示
  //未入力の場合は表示のためのダミースペースをセット
  self.dummyTextView.text = self.textFieldS.text;
  if( [self.dummyTextView.text isEqualToString:@""] ) {
    self.dummyTextView.text = @" ";
  }

  //dummyTextViewを縦に延ばす処理
  CGSize newSize = [self.dummyTextView.text
    sizeWithFont: self.dummyTextView.font
    constrainedToSize :CGSizeMake( self.dummyTextView.frame.size.width, self.dummyTextView.frame.size.height * 10 )
    lineBreakMode: UILineBreakModeCharacterWrap
  ];
  self.dummyTextView.frame = [self rectMake
    :self.dummyTextView.frame.origin.x
    :self.dummyTextView.frame.origin.y
    :self.dummyTextView.frame.size.width
    :newSize.height
  ];
  self.editStartButton.frame = self.dummyTextView.frame;

  //dummyTextViewの背景画像を延ばす
  self.windowBgGrayImageView.frame = [self rectMake
    :self.windowBgGrayImageView.frame.origin.x
    :self.windowBgGrayImageView.frame.origin.y
    :self.windowBgGrayImageView.frame.size.width
    :self.dummyTextView.frame.size.height + 5 + self.commentSendButton.frame.size.height + 5
  ];

  //送信ボタンの位置を調整
  self.commentSendButton.frame = [self rectMake
    :self.commentSendButton.frame.origin.x
    :5 + self.dummyTextView.frame.origin.y + self.dummyTextView.frame.size.height
    :self.commentSendButton.frame.size.width
    :self.commentSendButton.frame.size.height
  ];

  //キャンセルボタンの位置を調整
  self.commentCancelButton.frame = [self rectMake
    :self.commentCancelButton.frame.origin.x
    :5 + self.dummyTextView.frame.origin.y + self.dummyTextView.frame.size.height
    :self.commentCancelButton.frame.size.width
    :self.commentCancelButton.frame.size.height
  ];

  //ボトム画像の位置を調整
  self.windowBgBottomImageView.frame = [self rectMake
    :self.windowBgBottomImageView.frame.origin.x
    :self.windowBgGrayImageView.frame.origin.y + self.windowBgGrayImageView.frame.size.height
    :self.windowBgBottomImageView.frame.size.width
    :self.windowBgBottomImageView.frame.size.height
  ];

  self.dummyTextView.hidden = NO;

  //トップのツールバーを消す
  self.topToolBar.hidden = YES;
  
  //センターのツールバーを消す
  self.toolBar.hidden = YES;

  //フォーカスをはずす
  [self.textFieldS resignFirstResponder];
  [self.dummyTextView resignFirstResponder];

  //定型文一覧を消す
  self.commentListTable.hidden = YES;
    
  //背景を消す
  self.commentBgView.hidden = YES;
    
  //文字数を消す
  self.stringCountLabel.hidden = YES;
}

//------------------------------------------------------------//
//topツールバーの戻るボタン押下
//------------------------------------------------------------//
-(void)topReturnButtonPush :(id)sender
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [google eventTrack :@"対戦メッセージ:メッセージ:トップの戻るボタン押下" :nil :nil];
  [self returnSendView];
}

//------------------------------------------------------------//
//topツールバーの送るボタン押下
//------------------------------------------------------------//
-(void)topSendButtonPush :(id)sender
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [google eventTrack :@"対戦メッセージ:メッセージ:トップのメッセージ送信ボタン押下" :nil :nil];
  [self returnSendView];
  [self setupQueueView];
}

//------------------------------------------------------------//
//拡大した入力エリアから戻ってきたときの処理
//------------------------------------------------------------//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  NSString *str = textField.text;
  if( [str length] > 100 ) {
    textField.text = [str substringToIndex :100];
  }

  [self returnSendView];
  return YES;
}

//------------------------------------------------------------//
//キーボードが表示されたときの処理
//------------------------------------------------------------//
- (void)keyboardShow:(NSNotification *)notificatioin
{
  //現在を字数を表示する
  self.stringCountLabel.hidden = NO;
  self.stringCountLabel.text = [NSString stringWithFormat:@"%d%@", [self.textFieldS.text length], @"/100"];
  self.stringCountLabel.backgroundColor = [UIColor clearColor];
  
  //コメント入力欄の背景を設定する
  self.commentBgView.hidden = NO;
    
  //キーボードの大きさを取得
  CGRect keyboardRect = [[[notificatioin userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  self.keybordOrigin = keyboardRect.origin;
  self.keybordSize   = keyboardRect.size;

  //キーボードの大きさにあわせて背景の位置を調整、文言は消す
  self.label.hidden = YES;

  //入力フィールドの位置を調整
  self.textFieldS.frame = [self rectMake :10 :60 :300 :30];
  self.textFieldS.backgroundColor = [UIColor whiteColor];

  //TOPのツールバーを表示
  self.topToolBar.hidden = NO;

  //センターのツールバーを表示
  self.toolBar.hidden = NO;

  //コメントリストの位置を調整
  self.commentListTable.hidden = NO;
 
  //キーボードON通知イベントを削除
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//------------------------------------------------------------//
//テキストフィールドが編集開始になったときに呼ばれるメソッド
//------------------------------------------------------------//
-(BOOL)textFieldShouldBeginEditing :(UITextView*)textView
{
  NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
  [notification
    addObserver:self
    selector:@selector( keyboardShow: )
    name: UIKeyboardWillShowNotification
    object:nil
  ];
  
  //キーボード表示イベントを受けれるようにする
  //NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
	//[notification
  //  addObserver:self
  //  selector:@selector( keyboardHide: )
  //  name: UIKeyboardWillHideNotification
  //  object:nil
  //];

  //キーボードのタイプの設定
  //textView.keyboardType = UIKeyboardTypeASCIICapable;
  textView.keyboardType = UIKeyboardTypeDefault;
  //キーボードリタンーボタンのタイプの設定
  textView.returnKeyType = UIReturnKeyDone;
  //自動大文字の入力を禁止
  textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
  //自動補完を切る
  textView.autocorrectionType = UITextAutocorrectionTypeNo;
  
  return YES;
}

//------------------------------------------------------------//
//キーボードが隠れたときの処理
//------------------------------------------------------------//
- (void)keyboardHide:(NSNotification *)notificatioin
{
}

//------------------------------------------------------------//
//テキストフィールドの編集が終了したときに呼ばれるメソッド
//------------------------------------------------------------//
-(BOOL)textFieldShouldEndEditing :(UITextField*)textField
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  return YES;
}

//------------------------------------------------------------//
//テーブルのセルをクリックした時の処理
//キーボードを片付けて、キーボードイベント監視を取り消す
//------------------------------------------------------------//
-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.textFieldS resignFirstResponder];
}

//------------------------------------------------------------//
//タッチイベント開始
//------------------------------------------------------------//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.textFieldS resignFirstResponder];
}

//------------------------------------------------------------//
//タッチイベント終了
//------------------------------------------------------------//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

//------------------------------------------------------------//
// テキストフィールドの入力値変更イベント
//------------------------------------------------------------//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if( range.length >= 1 ) return YES;

  NSInteger count = [textField.text length];
  if ( [string isEqual:@""] ) {
    count--;
  }
  else{
    count++;
  }
  if( count > 100 ) {
    return NO;
  }
  self.stringCountLabel.text = [NSString stringWithFormat:@"%d%@",count, @"/100"];
  return YES;
}

//------------------------------------------------------------//
//セクションのタイトルを設定
//------------------------------------------------------------//
- (NSString *)tableView :(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return nil;
}

//------------------------------------------------------------//
//セクション数を返す（今回は提携コメント文だけを管理するので１つ）
//------------------------------------------------------------//
-(NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
  return 1;
}

//------------------------------------------------------------//
//セクション内のセルの数（登録してあるコメント数）を返す
//------------------------------------------------------------//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return app.utaate.commentData.data.count;
}

//------------------------------------------------------------//
//テーブルビューに表示するセルを生成する
//------------------------------------------------------------//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //表示するセルを生成
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [self.commentListTable dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[
      [UITableViewCell alloc] 
        initWithStyle:UITableViewCellStyleDefault 
        reuseIdentifier:CellIdentifier
      ]autorelease
    ];
  }
  for (UIView *subview in [cell.contentView subviews]) {
    [subview removeFromSuperview];
  }

  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  UIImage *windowBgBottomImage;
  if(indexPath.row % 2){
    windowBgBottomImage = [UIImage imageNamed:@"fix_bg_gray.png"];
  }
  else{
    windowBgBottomImage = [UIImage imageNamed:@"fix_bg_white.png"];
  }    
  UIImageView *imageView = [[[UIImageView alloc] initWithImage :windowBgBottomImage] autorelease];
    
  [cell setBackgroundView: imageView];
  //定型文が直接cellにではなく、cellの上で追加する
  UILabel *label_comment = [[UILabel alloc] initWithFrame :[self rectMake :60 :6 :250 :20]];
  label_comment.text = [[app.utaate.commentData.data objectAtIndex:indexPath.row] objectForKey:@"comment"];

  //label_comment.text = @"abcdeefnonognoang";
  label_comment.backgroundColor = [UIColor clearColor];
  label_comment.font = [UIFont systemFontOfSize:20];
  [cell.contentView addSubview:label_comment];
  [label_comment release];
  [self setupUseButton :indexPath :cell];
    
  return cell;
}

//------------------------------------------------------------//
//定型文を使うボタンのセット
//------------------------------------------------------------//
-(void)setupUseButton :(NSIndexPath *)indexPath :(UITableViewCell *)cell
{
  self.commentUseButton = [[[UIButton alloc] init] autorelease];
  self.commentUseButton.tag = indexPath.row;
  [self.commentUseButton setBackgroundImage :commentUseButtonImage forState:UIControlStateNormal];
  [self.commentUseButton
    addTarget :self
    action :@selector(useButtonPush:)
    forControlEvents :UIControlEventTouchUpInside
  ];
  //位置調整
  self.commentUseButton.frame = [self rectMake:2 :3 :commentUseButtonImage.size.width :commentUseButtonImage.size.height];
  [cell.contentView addSubview :self.commentUseButton];
}

//------------------------------------------------------------//
//「使う」ボタンを押した時の処理
//------------------------------------------------------------//
-(void)useButtonPush:(UIButton *)sender
{
  NSString *str = [[app.utaate.commentData.data objectAtIndex:sender.tag] objectForKey:@"comment"];
  [google eventTrack :@"対戦メッセージ:メッセージ入力:定型文ボタン押下" :nil :str];
  NSInteger nowStrCount = [self.textFieldS.text length];
  NSInteger addStrCount = [str length];
  if( (nowStrCount + addStrCount ) > 100 ) {
    return;
  }
  self.textFieldS.text = [NSString stringWithFormat:@"%@%@", self.textFieldS.text, str];
  self.stringCountLabel.text = [NSString stringWithFormat:@"%d%@", (nowStrCount + addStrCount), @"/100" ];
}

//------------------------------------------------------------//i
//編集画面で削除された時に呼ばれるデリゲートメソッド
//------------------------------------------------------------//
-(void)updateTableView
{
  [self.commentListTable reloadData];
}

//------------------------------------------------------------//
//コメントキャンセルボタン押下
//------------------------------------------------------------//
-(void)commentCancelButtonPush :(id)sender
{
  [google eventTrack :@"対戦メッセージ:メッセージ:メッセージキャンセルボタン押下" :nil :nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.textFieldS.text = @"";
  [self setupQueueView];
}

//------------------------------------------------------------//
//コメント送信ボタン押下
//------------------------------------------------------------//
-(void)commentSendButtonPush :(id)sender
{
  [google eventTrack :@"対戦メッセージ:メッセージ:メッセージ送信ボタン押下" :nil :nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self setupQueueView];
}

//------------------------------------------------------------//
//非同期処理画面の初期化
//------------------------------------------------------------//
-(void)setupQueueView
{
  self.queueView = [[[QueueView alloc] init] autorelease];
  self.queueView.delegate = self;
  [self addSubview :self.queueView];
  [self.queueView execQueue];
}

//------------------------------------------------------------//
//非同期処理
//------------------------------------------------------------//
-(void)execSubQueue
{
  //コメント送信
  [self sendCommentData];
  if ( [[self.result objectForKey:@"result"]intValue] != UTAATE_API_TRUE ) {
    return;
  }

  //友達情報を取得のため、最新のマイインフォを取得する
  [self setupMyInfo];
  if ( [[self.result objectForKey:@"result"]intValue] != UTAATE_API_TRUE ) {
    return;
  }

  //戦闘データを削除
  NSFileManager *mng = [NSFileManager defaultManager];
  [mng removeItemAtPath:app.utaate.file error:nil];
}

//------------------------------------------------------------//
//非同期処理が完了した時の処理
//------------------------------------------------------------//
-(void)execReturnSubQueue
{
  //失敗していたらエラー画面へ遷移
  if ( [[self.result objectForKey:@"result"]intValue] != UTAATE_API_TRUE ) {
    self.errView = [[[ErrorView alloc] init :[result objectForKey:@"message"] ] autorelease];
    self.errView.delegate = self;
    [self addSubview :self.errView];
    return;
  }
  
  //成功していたら次の画面へ
  [self success];
}

//------------------------------------------------------------//
//コメント送信
//------------------------------------------------------------//
-(void)sendCommentData
{
 self.result = [app.utaate.commentData sendCommentData
   :app.utaate
   :[[app.utaate.fightData.data objectForKey:@"fight_list_id"]intValue]
   :self.textFieldS.text
 ];
}

//------------------------------------------------------------//
//コメント送信
//------------------------------------------------------------//
-(void)setupMyInfo
{
  self.result = [app.utaate.myInfo setupMyInfo :app.utaate];
}

//------------------------------------------------------------//
//非同期処理が正常に完了してたらときに行う処理
//------------------------------------------------------------//
-(void)success
{
  //自分が後攻かつ敵と戦闘可能だったら再戦する
  NSInteger enemyId = [[app.utaate.enemyInfo.data objectForKey:@"id"] intValue];
  if( app.utaate.isAccept && [app.utaate.myInfo targetEnableBattleConfirm :enemyId] ) {
    //[self setupRematchView];
    [self setupRematch];
  }
  
  //自分が先攻だったらトップ画面へ遷移
  else{
    [self removeFromSuperview];
    [app.navController popToRootViewControllerAnimated:NO];
  }
}

//------------------------------------------------------------//
//エラービューにさせる処理
//------------------------------------------------------------//

//リトライ処理（コメント送信）
-(id)retry
{
  [self sendCommentData];
  return self.result;
}

//リトライ成功時の処理
-(void)retrySuccess
{
  [self success];
}

//------------------------------------------------------------//
//再戦
//------------------------------------------------------------//
-(void)setupRematch
{
  [self removeFromSuperview];
  app.utaate.isRematch = YES;
  [app.navController popToRootViewControllerAnimated:NO];
}

//------------------------------------------------------------//
//再戦確認
//------------------------------------------------------------//
//-(void)setupRematchView
//{
//  [self setupBaseView :YES];
//  [self setupReturnTopButton];
//  [self setupRematchButton];
//}

//------------------------------------------------------------//
//再戦確認(別画面から呼び出し)
//------------------------------------------------------------//
//-(void)setupRematchViewNoEnemyName
//{
//  [self setupBaseView :NO];
//  [self setupReturnTopButton];
//  [self setupRematchButton];
//}

//------------------------------------------------------------//
//下地塗り直し
//------------------------------------------------------------//
-(void)setupBaseView :(BOOL)isShowEnemyName
{
  //いらないものを削除処理
  //[self.textFieldS removeFromSuperview];
  //[self.commentSendButton removeFromSuperview];
  //[self.windowFigureMessageImageView removeFromSuperview];
  //[self.commentListTable removeFromSuperview];
  //[self.dummyTextView removeFromSuperview];
  //[self.commentCancelButton removeFromSuperview];

  self.textFieldS.hidden = YES;
  self.commentSendButton.hidden = YES;
  self.windowFigureMessageImageView.hidden = YES;
  self.commentListTable.hidden = YES;
  self.dummyTextView.hidden = YES;
  self.commentCancelButton.hidden = YES;

  //XXXさんへ送信しました。
  if( isShowEnemyName ) {
    self.label.hidden = NO;
    self.label.text = [NSString stringWithFormat:@"%@%@",
      [app.utaate.enemyInfo.data objectForKey:@"user_name"],@"さんに送信しました！"
    ];
  }
  else {
    self.label.hidden = YES;
  }
  
  //「もう一度対戦しますか？」
  UIImage *windowFigureAgainImage = [UIImage imageNamed:@"window_figure_again.png"];
  UIImageView *windowFigureAgainImageView = [[[UIImageView alloc] initWithImage :windowFigureAgainImage] autorelease];
  windowFigureAgainImageView.frame = [self rectMake
    :(320 - windowFigureAgainImage.size.width)/2
    :170
    :windowFigureAgainImage.size.width
    :windowFigureAgainImage.size.height
  ];
  [self addSubview :windowFigureAgainImageView];
  
  //白い背景と底部の位置調整(長さは星の背景と同じサイズ)
  UIImage *windowBgStarImage = [UIImage imageNamed:@"window_bg_star.png"];  

  self.windowBgGrayImageView.frame = [self rectMake
    :(320 - windowBgStarImage.size.width)/2
    :194
    :windowBgStarImage.size.width
    :70
  ];

  self.windowBgBottomImageView.frame = [self rectMake
    :(320 - windowBgStarImage.size.width)/2
    :264
    :windowBgStarImage.size.width
    :11
  ];
}

//------------------------------------------------------------//
//トップへ戻るボタンのセットアップ
//------------------------------------------------------------//
-(void)setupReturnTopButton
{    
  UIImage *windowBtnTopImage = [Image file2UIImage :@"window_btn_top.png"];
  self.returnToTopButton = [[[UIButton alloc] init] autorelease];
  self.returnToTopButton.frame = [self rectMake
    :76
    :228
    :windowBtnTopImage.size.width
    :windowBtnTopImage.size.height
  ];
  [self.returnToTopButton setBackgroundImage :windowBtnTopImage forState:UIControlStateNormal];
  [self.returnToTopButton
    addTarget :self
    action :@selector(returnToTopButtonPush:) forControlEvents:UIControlEventTouchUpInside
  ];
  //[self.baseView addSubview :self.returnToTopButton];
  [self addSubview :self.returnToTopButton];
}

//トップへ戻るボタン押下時の処理
-(void) returnToTopButtonPush :(UIButton *)sender
{
  [self removeFromSuperview];
  [app.navController popToRootViewControllerAnimated:NO];
}

//------------------------------------------------------------//
//もう一度遊ぶボタンのセットアップ
//------------------------------------------------------------//
//-(void)setupRematchButton
//{
//  UIImage *windowBtnPlayImage = [Image file2UIImage :@"window_btn_play.png"];
//  self.rematchButton = [[[UIButton alloc] init] autorelease];
//  self.rematchButton.frame = [self rectMake:170
//                                           :228
//                                           :windowBtnPlayImage.size.width
//                                           :windowBtnPlayImage.size.height
//                             ];
//  [self.rematchButton setBackgroundImage :windowBtnPlayImage forState:UIControlStateNormal];
//  [self.rematchButton addTarget:self
//                             action:@selector(rematchButtonPush:) forControlEvents:UIControlEventTouchUpInside
//  ];
//  //[self.baseView addSubview :self.rematchButton];
//  [self addSubview :self.rematchButton];
//}

//もう一度遊ぶボタン押下時の処理
//-(void) rematchButtonPush :(UIButton *)sender
//{
//  [self removeFromSuperview];
//  app.utaate.isRematch = YES;
//  [app.navController popToRootViewControllerAnimated:NO];
//}

@end
