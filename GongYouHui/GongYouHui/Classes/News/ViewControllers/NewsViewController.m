//
//  NewsViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "AFNetworking.h"
#import "NewsTableViewCell.h"
#import "MyWebViewController.h"
#import "MBProgressHUD.h"

@interface NewsViewController ()<UITableViewDataSource,MBProgressHUDDelegate,UITableViewDelegate>

@property (strong, nonatomic)MBProgressHUD *HUD;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong)UISegmentedControl *newsSegmentedControl;

@end

@implementation NewsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    [self createUI];
    
    //刷新
    [self createRefreshView];
    self.pageNum = 1;
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    
    NSInteger Index = _newsSegmentedControl.selectedSegmentIndex;
    if (Index == 1) {
        NSString *url1 = nil;
        NSString *url = nil;
        url1 = [REST_SERVICE_URL stringByAppendingString:GYHNOTICEURL];
        url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
        [self loadCompanyNewData:NO withUrlStrings:url];
    }else{
        NSString *url1 = nil;
        NSString *url = nil;
        url1 = [REST_SERVICE_URL stringByAppendingString:GYHNewListURL];
        url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
        [self loadCompanyNewData:NO withUrlStrings:url];
    }
}

- (void)createUI{
    [self creatSegmentedControl];
    [self creatTableView];
}
- (void)creatTableView{
    _mTableView = [[UITableView alloc]init];
    _mTableView.frame = CGRectMake(0, 0, GYHScreenWidth, GYHScreenHeight-44);
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    [_mTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    [_mTableView registerNib:[UINib nibWithNibName:@"NewsTextCell" bundle:nil] forCellReuseIdentifier:@"NewsTextCell"];
    [self.view addSubview:_mTableView];
}
- (void)creatSegmentedControl{
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(30.0, 10, GYHScreenWidth-60, 30.0)];
    [segmentedControl insertSegmentWithTitle:@"公告" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"新闻" atIndex:1 animated:YES];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(segmentedControl:)forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];  //自定义UIBarButtonItem，封装定义好的UIsegmented。
    self.navigationItem.rightBarButtonItem = segButton;  //添加到导航栏中
}
- (void)segmentedControl:(UISegmentedControl *)segementedControl{
    NSInteger Index = segementedControl.selectedSegmentIndex;
    if (Index == 1) {
        NSString *url1 = nil;
        NSString *url = nil;
        url1 = [REST_SERVICE_URL stringByAppendingString:GYHNOTICEURL];
        NSString *userId = [BNContainer instance].userInfo.userId;
        url = [NSString stringWithFormat:url1,@"2225",self.pageNum,NEWLISTNUM];
        [self loadCompanyNewData:NO withUrlStrings:url];
    }else{
        NSString *url1 = nil;
        NSString *url = nil;
        url1 = [REST_SERVICE_URL stringByAppendingString:GYHNewListURL];
        url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
        [self loadCompanyNewData:NO withUrlStrings:url];
    }
}

//记载公司新闻
- (void)loadCompanyNewData:(BOOL)isHeader withUrlStrings:(NSString *)url{
    //数据是从第1页开始的
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        NewsModel *vo = [[NewsModel alloc] initWithDic:resp];
        if (vo.isSuccess) {
            //赋值并刷新本地数
            if (_isRefreshing) {
                [_dataArray removeAllObjects];
            }
            if (1 == self.pageNum){
                _dataArray = vo.newsArray;
                NSLog(@"%@",_dataArray);
            }else{
                [_dataArray addObjectsFromArray:vo.newsArray];
            }
            if (vo.newsArray.count < 15) {
                //没有下一页
            }else{
                //有下一页
                self.pageNum ++;
            }
        
            [self.mTableView reloadData];
            //结束刷新
            [self endRefreshing];
        }else{

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}

-(void)endRefreshing{

    if (self.isRefreshing) {
        self.isRefreshing = NO;
        //正在刷新
        [self.mTableView endHeaderRefresh];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.mTableView endFooterRefresh];
    }
}

//刷新试图
-(void)createRefreshView{
//    [MMProgressHUD showWithStatus:NSLocalizedStringFromTable(@"努力加载中...", @"BaseStrings", nil)];
    __weak typeof(self) weakSelf = self;//弱引用
    //下拉刷新
    [self.mTableView addHeaderRefresh:^{
        
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标记正在刷新
        weakSelf.pageNum = 1;
        
        NSInteger Index = weakSelf.newsSegmentedControl.selectedSegmentIndex;
        if (Index == 1) {
            NSString *url1 = nil;
            NSString *url = nil;
            url1 = [REST_SERVICE_URL stringByAppendingString:GYHNOTICEURL];
            url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
            [weakSelf loadCompanyNewData:NO withUrlStrings:url];
        }else{
            NSString *url1 = nil;
            NSString *url = nil;
            url1 = [REST_SERVICE_URL stringByAppendingString:GYHNewListURL];
            url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
            [weakSelf loadCompanyNewData:NO withUrlStrings:url];
        }
    }];

    //上拉加载
    [self.mTableView addFooterRefresh:^{
        //重新下载数据
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;//标记正在刷新
        weakSelf.pageNum ++;//页码加1
        
        NSInteger Index = weakSelf.newsSegmentedControl.selectedSegmentIndex;
        if (Index == 1) {
            NSString *url1 = nil;
            NSString *url = nil;
            url1 = [REST_SERVICE_URL stringByAppendingString:GYHNOTICEURL];
            url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
            [weakSelf loadCompanyNewData:NO withUrlStrings:url];
        }else{
            NSString *url1 = nil;
            NSString *url = nil;
            url1 = [REST_SERVICE_URL stringByAppendingString:GYHNewListURL];
            url = [NSString stringWithFormat:url1,self.pageNum,NEWLISTNUM];
            [weakSelf loadCompanyNewData:NO withUrlStrings:url];
        }
        
    }];
}


#pragma UITableView datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *news = [_dataArray objectAtIndex:indexPath.row];
    if (news.imageUrl.length <= 0) {
        static NSString *CellTableIdentifer = @"NewsTableViewCell";
        NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifer];
        NewsModel *news = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = news.newsTitle;
        cell.dateLabel.text = news.newsTime;
        cell.introLabel.text = news.newsIntro;
        //去掉分割线
        tableView.separatorStyle = NO;
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *CellTableIdentifer = @"NewsTextCell";
        NewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifer];
        NewsModel *news = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = news.newsTitle;
        cell.dateLabel.text = news.newsTime;
        cell.introLabel.text = news.newsIntro;
        //去掉分割线
        tableView.separatorStyle = NO;
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:news.imageUrl] placeholderImage:[UIImage imageNamed:@"默认"]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWebViewController *vc = [[MyWebViewController alloc]init];
    NewsModel *news = [self.dataArray objectAtIndex:indexPath.row];
    NSString * url =[NSString stringWithFormat:@"%@/api/news/%@",REST_SERVICE_URL,news.Id];
    vc.urlString = url;
    vc.mTitle = news.newsTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [_newsSegmentedControl removeFromSuperview];
}

@end
