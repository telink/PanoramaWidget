//
//  H264ViewController.m
//  PanoramaWidget
//
//  Created by 周勇 on 2018/3/28.
//  Copyright © 2018年 张乐昌. All rights reserved.
//

#import "H264ViewController.h"
#import "HardDecoder.h"
#import "LayerPixer.h"
#import "PanoramaVC.h"

@interface H264ViewController ()<PackSortDelegate>
{
    HardDecoder *_decoder;
    LayerPixer  *_layerPixer;
    PanoramaVC  *_panoramaVC;
}

@end

@implementation H264ViewController

-(void)dealloc
{
    _layerPixer.closeFileParser = true;
}

- (void)viewDidLoad {

    _decoder                    = [[HardDecoder alloc] init];
    _layerPixer                 = [[LayerPixer alloc]init];
    _layerPixer.delegate        = self;
    _layerPixer.closeFileParser = false;
   [_layerPixer decodeFile:LOCALFILE(@"panorama", @"h264")];
    //
    

    
    // SurfaceView
    _panoramaVC = [[PanoramaVC alloc] initWithSrcType:ZLCPanoSRCTypeStream orientation:UIDeviceOrientationPortrait];
    _panoramaVC.view.frame = self.view.bounds;
    [_panoramaVC setPerspectiveMode:ZLCPanoPerspectModeNormal];
    [self.view addSubview:_panoramaVC.view];
    [self addChildViewController:_panoramaVC];
    [_panoramaVC didMoveToParentViewController:self];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)sortPackData:(VideoPacket *)pack
{

    dispatch_sync(dispatch_get_main_queue(), ^{
        CVPixelBufferRef curPixelRef = [_decoder decode2Surface:pack];
        [_panoramaVC refreshTexture:curPixelRef];
    });
}


@end
