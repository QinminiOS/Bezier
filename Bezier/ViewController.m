//
//  ViewController.m
//  UIkit
//
//  Created by qinmin on 2017/1/14.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "DotView.h"
#import "FormulaView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BallView *view = [[BallView alloc] initWithFrame:self.view.frame];
    //DotView *view = [[DotView alloc] initWithFrame:self.view.frame];
    //FormulaView *view = [[FormulaView alloc] initWithFrame:self.view.frame];
    
    self.view = view;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
