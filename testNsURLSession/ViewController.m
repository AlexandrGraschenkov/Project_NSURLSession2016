//
//  ViewController.m
//  testNsURLSession
//
//  Created by Alexander on 09.03.16.
//  Copyright © 2016 RoadAR. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController ()
{
    MPMoviePlayerController *player;
    NSURLSession *session;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"device" : @"iOS"}];
    session = [NSURLSession sessionWithConfiguration:config];
    [self startLoad];
    return;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imgView];
    imgView.backgroundColor = [UIColor redColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"img.jpg"];
    
    NSURL *url = [NSURL URLWithString:@"https://static.pexels.com/photos/20974/pexels-photo.jpg"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *resp;
        resp.
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
    
    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *moviePath = [bundle pathForResource:@"result3" ofType:@"mp4"];
//    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
//    
//    [self playVideoWithURL:movieURL];
}

- (void)startLoad {
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/Cat%20Jump%20Fail%20-%20Supercat.mp4"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *newFilePath = [docDir stringByAppendingPathComponent:@"video.mp4"];
        NSURL *newFilePathURL = [NSURL fileURLWithPath:newFilePath];
        
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:newFilePathURL error:nil];
        
        
        NSLog(@"%@", @"loaded");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideoWithURL:newFilePathURL];
        });
    }];
    [task resume];
    
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
    }];
}

- (void)stopLoad {
    
}

- (void)playVideoWithURL:(NSURL *)url {
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.controlStyle = MPMovieControlStyleEmbedded;
    player.view.frame = self.view.bounds;
    [self.view addSubview:player.view];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
