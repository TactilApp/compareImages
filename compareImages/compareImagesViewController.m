//
//  compareImagesViewController.m
//  compareImages
//
//  Created by Jorge Maroto García on 25/09/11.
//  Copyright 2011 http://www.tactilapp.com. All rights reserved.
//

#import "compareImagesViewController.h"

@implementation compareImagesViewController
@synthesize captcha;
@synthesize chr1, chr2, chr3, chr4, chr5, chr6;
@synthesize sliderX, sliderWidth;
@synthesize labelX, labelWidth;

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self updateValueSliders];
    [captcha setImage:[UIImage imageNamed:@"captcha.jpg"]];
}

-(UIImage *)cropImage:(UIImage *)image fromX:(float) x width:(float) width{
    CGRect cropRect = CGRectMake(x, 0, width, image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image  CGImage], cropRect);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

-(IBAction)sliderChange:(id)sender{
    [self updateValueSliders];
    UIImage *image = [self cropImage:captcha.image fromX:sliderX.value width:sliderWidth.value];
    [chr1 setImage:image];
    [chr1 setFrame:CGRectMake(chr1.frame.origin.x, chr1.frame.origin.y, image.size.width*2, image.size.height*2)];
    [image release];
}

-(void)updateValueSliders{
        labelX.text = [NSString stringWithFormat:@"%d", (int)sliderX.value];
    labelWidth.text = [NSString stringWithFormat:@"%d", (int)sliderWidth.value];
}

-(IBAction)save{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                      [NSString stringWithString: @"test.png"] ];
    NSData* data = UIImagePNGRepresentation(chr1.image);
    [data writeToFile:path atomically:YES];
}

-(IBAction)compare{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    for (int i = 0; i<22800; i++){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithString: @"test.png"] ];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:path];

        if ([self compareImage:image withImage:chr1.image]){
//            NSLog(@"Es igual");
        }else{
//            NSLog(@"NO ES IGUAL");
        }
        [image release];
    }
    
}

-(BOOL)compareImage:(UIImage *)image1 withImage:(UIImage *)image2{
    int errores = 0;
    CGImageRef cgimage1 = image1.CGImage;
    CGImageRef cgimage2 = image2.CGImage;
    
    // Info para la primera imagen
    size_t width1  = CGImageGetWidth(cgimage1);
    size_t height1 = CGImageGetHeight(cgimage1);
    
    size_t bpr1 = CGImageGetBytesPerRow(cgimage1);
    size_t bpp1 = CGImageGetBitsPerPixel(cgimage1);
    size_t bpc1 = CGImageGetBitsPerComponent(cgimage1);
    size_t bytes_per_pixel1 = bpp1 / bpc1;
    
    CGDataProviderRef provider1 = CGImageGetDataProvider(cgimage1);
    NSData* data1 = (id)CGDataProviderCopyData(provider1);
    [data1 autorelease];
    const uint8_t* bytes1 = [data1 bytes];
    
    
    // Info para la segunda imagen
    size_t width2 = CGImageGetWidth(cgimage2);
    size_t height2 = CGImageGetHeight(cgimage2);

    if (width1 != width2 || height1 != height2)
        return FALSE;
    
    size_t bpr2 = CGImageGetBytesPerRow(cgimage2);
    size_t bpp2 = CGImageGetBitsPerPixel(cgimage2);
    size_t bpc2 = CGImageGetBitsPerComponent(cgimage2);
    size_t bytes_per_pixel2 = bpp2 / bpc2;
    
    
    CGDataProviderRef provider2 = CGImageGetDataProvider(cgimage2);
    NSData* data2 = (id)CGDataProviderCopyData(provider2);
    [data2 autorelease];
    const uint8_t* bytes2 = [data2 bytes];

    //Recorrer toda la imagen comparando
    for(size_t row = 0; row < height1; row++){
        for(size_t col = 0; col < width1; col++){
            const uint8_t* pixel1 = &bytes1[row * bpr1 + col * bytes_per_pixel1];
            const uint8_t* pixel2 = &bytes2[row * bpr2 + col * bytes_per_pixel2];
            
            for(size_t x = 0; x < bytes_per_pixel1; x++){
                if (pixel1[x] != pixel2[x])
                    errores++;
            }
        }
    }
    return TRUE;
}

@end
