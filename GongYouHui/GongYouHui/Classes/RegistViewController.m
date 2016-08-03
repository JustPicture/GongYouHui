#import "RegistViewController.h"
#import "RegistTableViewCell.h"
#import "RemberPasswordViewController.h"
#import "LoginViewController.h"
@interface RegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *datasouceArray;
@property (nonatomic,strong)NSMutableArray *placeholdArray;
@property (nonatomic,strong)NSMutableDictionary * dataDict;
@property (nonatomic)UITableView *myTableView;
@property (nonatomic,assign)BOOL isChangeViewFrameByKeyBoard;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

    self.dataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self loadDatasouce];
    [self creatUI];
}
- (void)creatUI{
    UIView *NavView = [[UIView alloc]init];
    NavView.frame = CGRectMake(0, 0, GYHScreenWidth, 64);
    NavView.backgroundColor = [UIColor colorWithHexString:@"#39beee"];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 10, 50, 50);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:leftBtn];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];

    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"RegistTableViewCell" bundle:nil] forCellReuseIdentifier:@"RegistTableViewCell"];
    
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(30, GYHScreenHeight-49, GYHScreenWidth - 60, 40);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:@"#39beee"];
    
    [self.view addSubview:NavView];
    [self.view addSubview:button];
    [self.view addSubview:_myTableView];
}
- (void)leftBtnClick{
    LoginViewController *loginView = [[LoginViewController alloc]init];
    [self presentViewController:loginView animated:YES completion:nil];
}
- (void)next{
    if ([_dataDict[@"年龄"] isEqualToString:@""]) {
        NSString * contentString = [[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(self.datasouceArray[0], @"BaseStrings", nil)];
        if (![self checkContentNotEmptyByContentString:contentString contentType:NSLocalizedStringFromTable(self.datasouceArray[0], @"BaseStrings", nil)]) {
            return;
        }
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:NSLocalizedStringFromTable(@"信息注册后不可更改", @"BaseStrings", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"取消", @"BaseStrings", nil) otherButtonTitles:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil), nil];
        
        [alertView show];
        RemberPasswordViewController *remember = [[RemberPasswordViewController alloc]init];
        [self presentViewController:remember animated:YES completion:nil];
    }
}
//检查输入框的信息;
- (BOOL)checkContentNotEmptyByContentString:(NSString *)contentString contentType:(NSString *)contentType{
    if ([contentString isEqualToString:@""] ||![contentString isKindOfClass:[NSString class]]) {
        [self showAlertViewContentNotEmptyByTitleString:contentType];
        return NO;
    }
    return YES;
}

//展示提示框
- (void)showAlertViewContentNotEmptyByTitleString:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"提示",@"BaseStrings", nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable([string stringByReplacingOccurrencesOfString:@":" withString:@""],@"BaseStrings",nil),NSLocalizedStringFromTable(@"不能为空", @"BaseStrings", nil)] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确定", @"BaseStrings", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - TableView Method
//加载数据
- (void)loadDatasouce{
    
    self.datasouceArray = [NSMutableArray arrayWithObjects:@"姓名 ",@"性别 ",@"血型 ",@"年龄 ",@"过敏药物 ",@"疾病史 ",@"紧急联系人 ",@"紧急联系人电话 ",@"紧急联系人关系 ", nil];
    self.placeholdArray = [NSMutableArray arrayWithObjects:@"请填写真实姓名",@"请填写真实信息",@"请选择血型",@"请选择年龄",@"请填写真实信息",@"请填写真实信息",@"请填写真实信息",@"请填写真实信息",@"请填写真实信息",nil ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasouceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RegistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegistTableViewCell"];
    
    cell.labelName.text = [_datasouceArray objectAtIndex:indexPath.row];
    cell.placeholder.placeholder = _placeholdArray[indexPath.row];
    cell.placeholder.delegate = self;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/*
 
 键盘收回事件，UITextField协议方法
 
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return NO;
    
}
@end

