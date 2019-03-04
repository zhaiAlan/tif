//
//  ViewController.m
//  tif
//
//  Created by Alan on 2019/2/25.
//  Copyright © 2019 zhaixingzhi. All rights reserved.
//

#import "ViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@end

@implementation ViewController

//public void ConvertTiff2Jpeg(string tiffFileName, string jpegFileName)
//{
//    var img = Image.FromFile(tiffFileName);
//    var count = img.GetFrameCount(FrameDimension.Page);
//    for (int i = 0; i < count; i++)
//    {
//        img.SelectActiveFrame(FrameDimension.Page, i);
//        img.Save(jpegFileName + ".part" + i + ".jpg");
//    }
//    int imageWidth = img.Width;
//    int imageHeight = img.Height * count;
//    Bitmap joinedBitmap = new Bitmap(imageWidth, imageHeight);
//    Graphics graphics = Graphics.FromImage(joinedBitmap);
//    for (int i = 0; i < count; i++)
//    {
//        var partImageFileName = jpegFileName + ".part" + i + ".jpg";
//        Image partImage = Image.FromFile(partImageFileName);
//        graphics.DrawImage(partImage, 0, partImage.Height * i, partImage.Width, partImage.Height);
//        partImage.Dispose();
//        File.Delete(partImageFileName);
//    }
//    joinedBitmap.Save(jpegFileName);
//
//    graphics.Dispose();
//    joinedBitmap.Dispose();
//    img.Dispose();
//
//    //return jpegFileName;
//}
//- (void)tifChangeJpgWith:(NSString *)tifFileName andJpgName:(NSString *)jpegFileName
//{
//    var img = Image.FromFile(tiffFileName);
//    var count = img.GetFrameCount(FrameDimension.Page);
//    for (int i = 0; i < count; i++)
//    {
//        img.SelectActiveFrame(FrameDimension.Page, i);
//        img.Save(jpegFileName + ".part" + i + ".jpg");
//    }
//    int imageWidth = img.Width;
//    int imageHeight = img.Height * count;
//    Bitmap joinedBitmap = new Bitmap(imageWidth, imageHeight);
//    Graphics graphics = Graphics.FromImage(joinedBitmap);
//    for (int i = 0; i < count; i++)
//    {
//        var partImageFileName = jpegFileName + ".part" + i + ".jpg";
//        Image partImage = Image.FromFile(partImageFileName);
//        graphics.DrawImage(partImage, 0, partImage.Height * i, partImage.Width, partImage.Height);
//        partImage.Dispose();
//        File.Delete(partImageFileName);
//    }
//    joinedBitmap.Save(jpegFileName);
//
//    graphics.Dispose();
//    joinedBitmap.Dispose();
//    img.Dispose();
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    _imageview.image = [UIImage imageNamed:@"办收-2019-26【集团】监管：中国银保监会办公厅关于加强保险公司中介渠道业务管理的通知.tif"];
    
    CGImageRef imageRef = _imageview.image.CGImage;

    NSLog(@"%@",imageRef);
    
    NSString *url = [[NSBundle mainBundle] pathForResource:@"办收-2019-26【集团】监管：中国银保监会办公厅关于加强保险公司中介渠道业务管理的通知.tif" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:url];
    
    NSMutableArray *arr = [self praseGIFDataToImageArray:data];
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    sc.pagingEnabled = YES;
    sc.contentSize = CGSizeMake(WIDTH * arr.count, HEIGHT ) ;
    [self.view addSubview:sc];
    for (int i = 0; i< arr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        imageview.image = arr[i];
        [sc addSubview:imageview];
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;

{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    CGImageSourceRef cgimagesource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    
    if (cgimagesource) {
        size_t l = CGImageSourceGetCount(cgimagesource);
        imageArray = [NSMutableArray arrayWithCapacity:l];
        
        for (size_t i = 0; i < l; i++) {
        CGImageRef img = CGImageSourceCreateImageAtIndex(cgimagesource, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(cgimagesource, i, NULL));
            
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            
            animationTime += [delayTime floatValue];
            
            if (img)
            {
                [imageArray addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
    
        CFRelease(cgimagesource);
    }
    
    return imageArray;
}


@end
