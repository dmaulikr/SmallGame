//
//  ViewController.m
//  HitMouse
//
//  Created by lanou3g on 15/9/14.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

#define temp arc4random()%18+1

@interface ViewController ()

@property (nonatomic,retain)UIButton *mouseBtn;
@property (nonatomic,retain)NSTimer *myTimer;
@property (nonatomic,retain)NSTimer *myTimer1;
@property (nonatomic,retain)UISlider *mySlider;
@property (nonatomic,retain)NSMutableArray *arrBtn;
@property int indexCount;
@property (nonatomic,retain)AVAudioPlayer *myPlayer;
@property (nonatomic,retain)AVAudioPlayer *myPlayerHit;
@property (nonatomic,retain)UIButton *btnStart;
@property (nonatomic,retain)UILabel *showLabel;
@property (nonatomic,retain)UILabel *showTime;
@property (nonatomic,retain)UIButton *staOrStop;
@property (nonatomic,assign)NSInteger a;
@property int score;


@end

@implementation ViewController

-(void)loadView{
    
    [super loadView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDate];//数据
    [self loadMouseView];//界面
    [self loadTimer];//操作
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)loadDate{
    //加载数据：背景音乐和打击老鼠的音乐
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *strFile=[bundle pathForResource:@"mymisic.mp3" ofType:nil];
    NSURL *musicName=[NSURL fileURLWithPath:strFile];
    self.myPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:musicName error:nil];
    [self.myPlayer play];
    
    NSBundle *bundl2=[NSBundle mainBundle];
    NSString *strFile1=[bundl2 pathForResource:@"539034e1a52cf.wav" ofType:nil];
    NSURL *musicName1=[NSURL fileURLWithPath:strFile1];
    self.myPlayerHit=[[AVAudioPlayer alloc] initWithContentsOfURL:musicName1 error:nil];
}
-(void)loadMouseView
{//加载界面
    //地鼠布局
    _indexCount = 1;
    for (int i=0; i<6; i++) {
        for (int j=0; j<3; j++) {
            self.mouseBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (90 + 30) * j, 50 + (60 + 20) * i + 20 , 90, 60)];
            self.mouseBtn.backgroundColor = [UIColor grayColor];
            [self.mouseBtn setBackgroundImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
            [self.mouseBtn setBackgroundImage:[UIImage imageNamed:@"image2"] forState:UIControlStateSelected];//selected是一种状态，可以给这个状态进行设置
            [self.mouseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];//初始化的适合给控件添加action
            self.mouseBtn.tag = _indexCount++;//1到18
            [self.arrBtn addObject:self.mouseBtn];
            [self.view addSubview:self.mouseBtn];
        }
    }
 //分数
    self.score = 0;
    self.showLabel=[[UILabel alloc] init];
    self.showLabel.text=@"0";
    self.showLabel.frame=CGRectMake(self.view.frame.size.width-100, 20, 40, 40);
    self.showLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.showLabel];
    
    UILabel *labelSc=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 40, 40)];
    labelSc.text=@"分数";
    labelSc.backgroundColor=[UIColor redColor];
    [self.view addSubview:labelSc];
    
    //时间
    UILabel *labelSc1=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 50, 40)];
    labelSc1.text=@" 时间";
    labelSc1.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:labelSc1];
    
    //开始，暂停  各自控制的功能，有什么用
    self.staOrStop=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3+10, self.view.frame.size.height-110, 100, 100)];
    [self.staOrStop setTitle:@"开始" forState:UIControlStateNormal];
    self.staOrStop.backgroundColor=[UIColor blackColor];
    [self.staOrStop addTarget:self action:@selector(getState:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:self.staOrStop];

    //slider时间控制
    self.mySlider=[[UISlider alloc] initWithFrame:CGRectMake(60, 30, 210, 20)];
    [self.view addSubview:self.mySlider];
    self.mySlider.minimumValue = 0;
    self.mySlider.maximumValue = 30;
    
}

-(void)loadTimer{ //加载时间
    //控制地鼠的出现
    self.myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mouseApprea:) userInfo:nil repeats:YES];
    //控制时间
    self.myTimer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
}

-(void)getState:(UIButton *)sender{
    
    if(!sender.selected){ // 属性取反，实现循环 第一次点击前没有selected  ！selected 没有选
        sender.selected=YES;

        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
        [self.myTimer invalidate];
        [self.myTimer1 invalidate];
        [self.myPlayer stop];
        
    }else{
        sender.selected=NO;
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        [self loadTimer];
        [self.myPlayer play];
    }
}

-(void)changeTime:(NSTimer *)sender{
    
    self.mySlider.value += 5;
     [self judgeScore];
}

-(void)mouseApprea:(NSTimer *)sender{ //逻辑上只能一个出现，在下去，另一个出现
    
    NSLog(@"%ld",_a); //每个一段时间走一次这个方法  在时间里不要添加控件的Action,
    if (_a != 0) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:_a];
        btn.selected = NO; //两个地鼠不会同时出现
    }
    
    UIButton *button=(UIButton *)[self.view viewWithTag:temp]; //必须要对应
    _a =button.tag;
    button.selected = YES; //用btn的状态区改变
}

-(void)btnClick:(UIButton *)sender
{
    if (sender.selected == YES) {//只有当selected是yes时，状态取反 状态类的尽量只写一个判断
        
        sender.selected = !sender.selected;
        [self.myPlayerHit play];
         self.score += 10;
         self.showLabel.text=[NSString stringWithFormat:@"%d",self.score];
    }
}

-(void)judgeScore{
    
        NSString *strScore=[NSString stringWithFormat:@"%@",self.showLabel.text];
        int LastScore=[strScore intValue];
        if (LastScore <500 && self.mySlider.value==30) {
    
      UIAlertView *altView=[[UIAlertView alloc] initWithTitle:@"游戏结束" message:@"30秒内分数小于500" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [altView show];
            NSLog(@"游戏结束");
        }
   
    if (self.mySlider.value==30) {
        [self.myTimer invalidate];
        [self.myTimer1 invalidate];
        [self.myPlayer stop];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
