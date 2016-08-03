//
//  ChatViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "ChatViewController.h"
#import "DetailViewController.h"
#import "FirstAidViewController.h"
#import "MyShoesViewController.h"
#import "ReaderManagerVC.h"
#import "BluetoothViewController.h"

#import "MyWebViewController.h"

#import "NewsTableViewCell.h"
#import "NewsTextCell.h"
#import "NewsModel.h"
@interface ChatViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UIScrollView *mYScrolleView;
    UITableView *MyTableView;
    BOOL isDeceleration;
    UISearchBar *searchBar;
    UIView *btnView;
}
@property (nonatomic, strong)NSMutableArray * imageArray;
@property (nonatomic, strong) NSTimer * time;
@property (nonatomic, strong) UIPageControl * myPageControl;

@property (nonatomic, strong)NSMutableArray * btnArray;
@property (nonatomic, strong)NSMutableArray * btnArray1;
@property (nonatomic, strong)NSMutableArray * labelArray;
@property (nonatomic, strong)NSMutableArray * labelArray1;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic) NSInteger pageNum;

@end

@implementation ChatViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(226, 226, 226, 1);
    self.pageNum = 1;
    _imageArray = [NSMutableArray array];
//    _dataSource = [NSArray array];
//    _dataSource = @[@"hello",@"hello",@"good",@"well",@"hello",@"hello",@"good",@"well",@"hello",@"hello",@"good",@"well"];
    [self creatUIView];
}
- (void)creatUIView{
    
    [self loaddata];//消息列表
//    [self loadScrolldata];//滚动图片
    [self creatSearchBar];
    [self creatScrolleView];
    [self creatButton];
    [self creatTableView];
}
- (void)creatSearchBar{
    //顶部搜索栏－－加到navigationItem.titleView
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(40,0, KWIDTH-40*2,50)];
    searchBar.placeholder=@"商品名称关键字";
    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    searchBar.delegate=self;
    self.navigationItem.titleView =searchBar;
    //顶部搜索按钮－－加到rightBarButtonItem
    UIButton *btnSearch=[[UIButton alloc]initWithFrame:CGRectMake(282,5, 30,30)];
    [btnSearch setTitle:@"搜索"forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSearch setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor orangeColor]forState:UIControlStateHighlighted];
    [btnSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigth = [[UIBarButtonItem alloc]initWithCustomView:btnSearch];
    self.navigationItem.rightBarButtonItem = rigth;
}
- (void)toSearch{
    NSLog(@"点击开始搜索");
//    self.searchDisplayController.active = false;
}
- (void)creatScrolleView{
//    _dataArray.count;
    self.imageArray = [[NSMutableArray alloc]initWithObjects:@"index1.jpg",@"index5.jpg",@"index3.jpg",@"index1.jpg",@"index5.jpg", nil];
    mYScrolleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, KWIDTH , 198)];
    mYScrolleView.contentSize = CGSizeMake(mYScrolleView.frame.size.width * ([self.imageArray count] + 2), mYScrolleView.frame.size.height);
    mYScrolleView.delegate = self;
    mYScrolleView.bounces = YES;
    mYScrolleView.pagingEnabled = YES;
    mYScrolleView.userInteractionEnabled = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImageView * imgView =[[UIImageView alloc]initWithFrame:CGRectMake(mYScrolleView.frame.size.width *0, mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height)];
    imgView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:[self.imageArray count]-1]];
    
    [mYScrolleView addSubview:imgView];
    for (int i = 0; i < [self.imageArray count]; i++) {
        UIImageView * imgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(mYScrolleView.frame.size.width *(i+1), mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height)];
        
        imgView1.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
        
        [mYScrolleView addSubview:imgView1];
    }
    //把第一张图片放到最后的位置
    UIImageView * imgView0 =[[UIImageView alloc]initWithFrame:CGRectMake(mYScrolleView.frame.size.width * ([self.imageArray count]+1), mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height)];
    imgView0.image = [UIImage imageNamed:[self.imageArray objectAtIndex:0]];
    [mYScrolleView addSubview:imgView0];
    [mYScrolleView setContentOffset:CGPointMake(0, 0)];
    [mYScrolleView scrollRectToVisible:CGRectMake(mYScrolleView.frame.size.width, mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height) animated:NO];
//    [self.view addSubview:mYScrolleView];
    //与pagecontrol结合使用
    self.myPageControl =[[UIPageControl alloc]initWithFrame:CGRectMake(50, 170, KWIDTH - 100,30 )];
    _myPageControl.currentPage = 0;
    _myPageControl.numberOfPages = [self.imageArray count];
//    [self.view addSubview:_myPageControl];
    //加入定时器
    self.time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pageChange) userInfo:nil repeats:YES];
    
}
- (void)creatTableView{
    MyTableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, KWIDTH, KHEIGHT-64-15) style:UITableViewStyleGrouped];
    MyTableView.backgroundColor = RGBACOLOR(226, 226, 226, 1);
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    [MyTableView registerNib:[UINib nibWithNibName:@"NewsTextCell" bundle:nil] forCellReuseIdentifier:@"NewsTextCell"];
    [self.view addSubview:MyTableView];
}

- (void)creatButton{
    btnView = [[UIView alloc]initWithFrame:CGRectMake(1, 205, KWIDTH-2, 170)];
    btnView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    _btnArray = [[NSMutableArray alloc]initWithObjects:@"qiping.jpg",@"shoes.jpg",@"suo",@"巡检",@"fangwei", nil];
    _labelArray = [[NSMutableArray alloc]initWithObjects:@"急救查询",@"鞋子",@"锁具",@"巡检",@"NFC", nil];

    for (int i = 0; i < [_btnArray count]; i ++) {
//        200
        CGFloat x = (KWIDTH - (KWIDTH/5 - 20)*5)/6;
        CGFloat width = KWIDTH/5 - 20;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x +( width + x)* i, 10, width, width)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = width/2;
        btn.tag = 20 + i;
        [btn addTarget:self action:@selector(tiaozhuan:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:_btnArray[i]] forState:UIControlStateNormal];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(x +( width + x)* i, 13 + width, width,20 )];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = _labelArray[i];

        [btnView addSubview:lbl];
        [btnView addSubview:btn];
    }
    _btnArray1 = [[NSMutableArray alloc]initWithObjects:@"小知识",@"记事本",@"直尺",@"2.jpg",@"3.jpg", nil];
    _labelArray1 = [[NSMutableArray alloc]initWithObjects:@"实用工具",@"记事本",@"刻度尺",@"手电筒",@"其他", nil];
    
    for (int i = 0; i < [_btnArray1 count]; i ++) {
        //        200
        CGFloat x = (KWIDTH - (KWIDTH/5 - 20)*5)/6;
        CGFloat width = KWIDTH/5 - 20;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x +( width + x)* i, 35 + width, width, width)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = width/2;
        btn.tag = 25 + i;
        [btn addTarget:self action:@selector(tiaozhuan:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:_btnArray1[i]] forState:UIControlStateNormal];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(x +( width + x)* i, 38 + 2*width, width,20 )];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.text = _labelArray1[i];
        
        [btnView addSubview:lbl];
        [btnView addSubview:btn];
    }
//    [self.view addSubview:btnView];
}
- (void)tiaozhuan:(UIButton *)btn {
    if (btn.tag == 20) {
        FirstAidViewController *first = [[FirstAidViewController alloc]init];
        [self.navigationController pushViewController:first animated:YES];
    }else if (btn.tag == 21) {
        MyShoesViewController *myshoes = [[MyShoesViewController alloc]init];
        
        [self.navigationController pushViewController:myshoes animated:YES];
    }else if (btn.tag == 24) {
        ReaderManagerVC *readMVC = [[ReaderManagerVC alloc]init];
        [self.navigationController pushViewController:readMVC animated:YES];
    }else{
        DetailViewController *detail = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
- (void)loaddata{
    //数据是从第1页开始的
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url1 = nil;
    NSString *url = nil;
    url1 = [REST_SERVICE_URL stringByAppendingString:GYHNOTICEURL];
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:UserID];
    url = [NSString stringWithFormat:url1,userId,self.pageNum,NEWLISTNUM];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        NewsModel *vo = [[NewsModel alloc] initWithDic:resp];
        _dataArray = vo.newsArray;
        NSLog(@"%@",_dataArray);
        [MyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (void)loadScrolldata{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url1 = nil;
    NSString *url = nil;
    url1 = [REST_SERVICE_URL stringByAppendingString:GYHNewListURL];
    url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        for (NSInteger i = 0; i<[resp[@"data"] count]; i++) {
            [_imageArray addObject:resp[@"data"][i][@"imgUrl"]];
            NSLog(@"%@-------------u",_imageArray);
        }
        [MyTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIdentifer = @"NewsTextCell";
    NewsTextCell * cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifer];
    NewsModel *news = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = news.newsTitle;
    cell.dateLabel.text = news.newsTime;
    cell.introLabel.text = news.newsIntro;
    //去掉分割线
    tableView.separatorStyle = NO;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:news.imageUrl] placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 376;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(1, 0, KWIDTH - 2, 42)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 380, KWIDTH-30, 40)];
    lb.tintColor = [UIColor blackColor];
    lb.text = @"消息列表";
    [view addSubview:lb];
    [view addSubview:mYScrolleView];
    [view addSubview:btnView];
    [view addSubview:_myPageControl];
    MyTableView.tableHeaderView = view;
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MyWebViewController *vc = [[MyWebViewController alloc]init];
    NewsModel *news = [self.dataArray objectAtIndex:indexPath.row];
    NSString * url =[NSString stringWithFormat:@"%@/api/news/%@",REST_SERVICE_URL,news.Id];
    vc.urlString = url;
    vc.mTitle = news.newsTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ScrollView Delegate

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    isDeceleration = YES;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:mYScrolleView];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDeceleration = NO;
    int currentPage = floor((mYScrolleView.contentOffset.x-mYScrolleView.frame.size.width/([self.imageArray count]+2))/mYScrolleView.frame.size.width)+1;
    if (currentPage==0) {
        
        [mYScrolleView scrollRectToVisible:CGRectMake(mYScrolleView.frame.size.width*[_imageArray count], mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height) animated:NO];
    }else if(currentPage==([_imageArray count]+1)){//如果最后加一，也就是开始循环的第一个
        [mYScrolleView scrollRectToVisible:CGRectMake(mYScrolleView.frame.size.width, mYScrolleView.frame.origin.y, mYScrolleView.frame.size.width, mYScrolleView.frame.size.height) animated:NO];
    }
}
-(void)pageChange
{
    if (isDeceleration==NO) {
        [mYScrolleView setContentOffset:CGPointMake(mYScrolleView.contentOffset.x+KWIDTH, mYScrolleView.contentOffset.y) animated:YES];
        CGFloat pageWidth = mYScrolleView.frame.size.width;
        int page = floor((mYScrolleView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _myPageControl.currentPage = page;
        if (page==[_imageArray count]) {//如果到最后一页，设置currentPage=0；重新开始
            _myPageControl.currentPage = 0;
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [searchBar resignFirstResponder];
    }
}


@end
