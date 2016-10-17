//
//  SearchTableViewController.m
//  PersonDreaw
//
//  Created by QAING CHEN on 16/10/16.
//  Copyright © 2016年 QAING CHEN. All rights reserved.
//

#import "SearchTableViewController.h"


#define inputW          30
#define imgSearchW      15

@interface SearchTableViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView    *Datatable;
@property (nonatomic ,strong)UIView         *BacView;
@property (nonatomic ,strong)NSMutableArray *DataArray;
@property (nonatomic ,strong)UITextField    *SearchText;
@property (nonatomic ,strong)UIImageView    *ImageView;
@property (nonatomic ,strong)UIView         *InputView;

@end
@implementation SearchTableViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _SearchText.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _SearchText.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _DataArray = [NSMutableArray array];
    [self setText];
    [self notificationCenterAction];
    [self hiddenSearchAnimation];
}

#pragma mark - 监听键盘的事件
-(void) notificationCenterAction
{
    //监听键盘的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.view.window];
}




#pragma mark - 屏幕的伸缩
//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif
{
    //动态提起整个屏幕
    [UIView animateWithDuration:2 animations:^{
        
        [self animationViewShow];
        
    } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif
{
    [UIView animateWithDuration:2 animations:^{
        [self HidenView];
    } completion:nil];
}

- (void)HidenView
{
    self.InputView = [[UIView alloc] init];
    CGSize size = [_SearchText.placeholder sizeWithAttributes:@{NSFontAttributeName:_SearchText.font}];
    CGFloat textFieldW = (_SearchText.frame.size.width-size.width)/2;
    self.InputView.frame= CGRectMake(0, 0 ,textFieldW , inputW);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.InputView addGestureRecognizer:tap];
    
    self.ImageView = [[UIImageView alloc] init];
    self.ImageView.image = [UIImage imageNamed:@"SearchImg.png"];
    CGRect rx = CGRectMake( textFieldW -12 , (inputW - imgSearchW)/2 , imgSearchW, imgSearchW);
    self.ImageView.frame = rx;
    
    [self.InputView addSubview:self.ImageView];
    // 把leftVw设置给文本框
    _SearchText.leftView = self.InputView;
    _SearchText.leftViewMode = UITextFieldViewModeAlways;
}

- (void)inputViewTapped {
    [_SearchText becomeFirstResponder];
}

- (void)animationViewShow
{
    self.InputView = [[UIView alloc] init];
    self.InputView.frame= CGRectMake(0, 0 ,inputW , inputW);
    
    self.ImageView = [[UIImageView alloc] init];
    self.ImageView.image = [UIImage imageNamed:@"SearchImg.png"];
    CGRect rx = CGRectMake( 12,(inputW - imgSearchW)/2 , imgSearchW, imgSearchW);
    self.ImageView.frame = rx;
    
    [self.InputView addSubview:self.ImageView];
    // 把leftVw设置给文本框
    _SearchText.leftView = self.InputView;
    _SearchText.leftViewMode = UITextFieldViewModeAlways;
}


- (void)setText{
    //添加手势，单击收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    _SearchText = [[UITextField alloc]initWithFrame:CGRectMake(15,12,self.view.frame.size.width - 30, 20)];
    _SearchText.delegate = self;
    _SearchText.borderStyle = UITextBorderStyleRoundedRect;
    _SearchText.font = [UIFont systemFontOfSize:14];
    _SearchText.placeholder = @"输入";
    _SearchText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    _SearchText.backgroundColor = [UIColor cyanColor];
    [self.navigationController.navigationBar addSubview:_SearchText];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
        backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.BacView = backView;
        [self.view addSubview:backView];
        
        UITableView *searchTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        searchTableView.alpha = 0;
        searchTableView.delegate = self;
        searchTableView.dataSource = self;
        [searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.Datatable = searchTableView;
        [self.view addSubview:searchTableView];
    }
}

- (void)TextFieldTextDidChange
{
    if (_SearchText.text.length == 0) {
        self.Datatable.alpha = 0;
        return;
    }
    if (_SearchText.text.length > 0) {
        self.Datatable.alpha = 1;
    }
    [self getSearchResult:_SearchText.text];
}

- (void)getSearchResult:(NSString *)text
{
        //textFiled 改变，执行数据请求
        [self.DataArray removeAllObjects];
        NSArray *array = @[@"12345",@"12346",@"1245",@"1246",@"111",@"123",@"100",@"1"];
        for (NSString *arrText in array) {
            if ([arrText hasPrefix:text]) {
                [self.DataArray addObject:arrText];
            }
        }
        [self.Datatable reloadData];
}
- (void)hiddenSearchAnimation
{
    self.InputView = [[UIView alloc] init];
    CGSize size = [_SearchText.placeholder sizeWithAttributes:@{NSFontAttributeName:_SearchText.font}];
    CGFloat textFieldW = (_SearchText.frame.size.width-size.width)/2;
    self.InputView.frame= CGRectMake(0, 0 ,textFieldW , inputW);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.InputView addGestureRecognizer:tap];
    
    self.ImageView = [[UIImageView alloc] init];
    self.ImageView.image = [UIImage imageNamed:@"SearchImg.png"];
    CGRect rx = CGRectMake( textFieldW -12 , (inputW - imgSearchW)/2 , imgSearchW, imgSearchW);
    self.ImageView.frame = rx;
    
    [self.InputView addSubview:self.ImageView];
    // 把leftVw设置给文本框
    _SearchText.leftView = self.InputView;
    _SearchText.leftViewMode = UITextFieldViewModeAlways;
    
}


- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    [_SearchText resignFirstResponder];
}

- (void)inputViewTapped:(UITapGestureRecognizer *)tap
{
     [_SearchText resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_DataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    MkNextViewController *mkNext = [MkNextViewController new];
//    [self.navigationController pushViewController:mkNext animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
