//
//  ViewController.m
//  testNsURLSession
//
//  Created by Alexander on 09.03.16.
//  Copyright © 2016 RoadAR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"device" : @"iOS"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imgView];
    imgView.backgroundColor = [UIColor redColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"img.jpg"];
    
    NSURL *url = [NSURL URLWithString:@"https://static.pexels.com/photos/20974/pexels-photo.jpg"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = img;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
        NSLog(@"%@", @"loaded");
    }];
    [task resume];
    
    
    NSURL *loginURL = [NSURL URLWithString:@"http://mobilestudent.ru/api/v2/sessions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginURL];
    request.HTTPMethod = @"POST";
    NSString *str = @"user[email]=ee&user[password]=dd";
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    id loginTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }];
    [loginTask cancel];
    [loginTask resume];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
