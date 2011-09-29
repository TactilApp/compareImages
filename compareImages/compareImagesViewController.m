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
@synthesize block1, block2, block3;
@synthesize imageCompose;

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self cargarImagen];
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
    
    if (block1.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                      [NSString stringWithFormat:@"block1/1%@.png", block1.text]];
        NSData *data = UIImagePNGRepresentation(chr1.image);
        [data writeToFile:path atomically:YES];
    } 
    if (block2.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat:@"block2/2%@.png", block2.text]];
        NSData *data = UIImagePNGRepresentation(chr2.image);
        [data writeToFile:path atomically:YES];
    } 
    if (block3.text != @""){
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat:@"block3/3%@.png", block3.text]];
        NSData *data = UIImagePNGRepresentation(chr3.image);
        [data writeToFile:path atomically:YES];
    }
    
    [self cargarImagen];
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
    if (image1 == nil || image2 == nil){
        NSLog(@"NILLLL");
        return FALSE;
    }
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
    return (errores < 10);
}
#define CHR1_X  6
#define CHR2_X  50
#define CHR3_X  85
#define CHR4_X  65
#define CHR5_X  4
#define CHR6_X  4

#define CHR1_WIDTH  35
#define CHR2_WIDTH  35
#define CHR3_WIDTH  35
#define CHR4_WIDTH  15
#define CHR5_WIDTH  15
#define CHR6_WIDTH  15
-(IBAction)splitImages{
    [chr1 setImage:[self cropImage:captcha.image fromX:CHR1_X width:CHR1_WIDTH]];
    [chr2 setImage:[self cropImage:captcha.image fromX:CHR2_X width:CHR2_WIDTH]];
    [chr3 setImage:[self cropImage:captcha.image fromX:CHR3_X width:CHR3_WIDTH]];
    
    for (int i=1; i<=3; i++){
        UIImageView *imageViewAux = [self valueForKey:[NSString stringWithFormat:@"chr%d", i ]];
        [imageViewAux setFrame:CGRectMake(imageViewAux.frame.origin.x, imageViewAux.frame.origin.y, imageViewAux.image.size.width*2, imageViewAux.image.size.height*2)];
    }
    
    int incompletos = 0;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingString:@"/block1"];
    NSArray *dirContents = [[NSFileManager defaultManager] directoryContentsAtPath:documentsDirectory];
    for (NSString *tString in dirContents) {
        UIImage *imgTmp = [[UIImage alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:tString]];
        if ([self compareImage:imgTmp withImage:chr1.image]){
            block1.text = [tString substringWithRange:NSMakeRange(1, 2)];
            [imgTmp release];
            incompletos++;
            break;
        }
        [imgTmp release];
    }






    NSString *documentsDirectory2 = [[paths objectAtIndex:0] stringByAppendingString:@"/block2"];
    NSArray *dirContents2 = [[NSFileManager defaultManager] directoryContentsAtPath:documentsDirectory2];
    for (NSString *tString in dirContents2) {
        UIImage *imgTmp = [[UIImage alloc] initWithContentsOfFile:[documentsDirectory2 stringByAppendingPathComponent:tString]];
        if ([self compareImage:imgTmp withImage:chr2.image]){
            block2.text = [tString substringWithRange:NSMakeRange(1, 2)];
            [imgTmp release];
            incompletos++;
            break;
        }
        [imgTmp release];
    }


    
    
    
    NSString *documentsDirectory3 = [[paths objectAtIndex:0] stringByAppendingString:@"/block3"];
    NSArray *dirContents3 = [[NSFileManager defaultManager] directoryContentsAtPath:documentsDirectory3];
    for (NSString *tString in dirContents3) {
        UIImage *imgTmp = [[UIImage alloc] initWithContentsOfFile:[documentsDirectory3 stringByAppendingPathComponent:tString]];
        if ([self compareImage:imgTmp withImage:chr3.image]){
            block3.text = [tString substringWithRange:NSMakeRange(1, 2)];
            [imgTmp release];
            incompletos++;
            break;
        }
        [imgTmp release];
    }
    
    if (incompletos > 1){
        NSLog(@"Completos: %d", incompletos);
        [self cargarImagen];
    }

}

#define CAPTCHA_URL @"http://www.cmt.es/cmt_ptl_ext/Captcha.jpg"

-(IBAction)cargarImagen{
    block1.text = @"";
    block2.text = @"";
    block3.text = @"";
    
    NSURL *url = [NSURL URLWithString:CAPTCHA_URL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request startSynchronous];
    [captcha setImage:[UIImage imageWithData:[request responseData]]];
    [request release];
    
    [self splitImages];
}

-(IBAction)autoguardado:(id)sender{
    if ([block3.text length] == 2){
        [self save];
    }
}


-(IBAction)composeImage{
    //Joins 3 UIImages together, stitching them vertically
    CGSize size = CGSizeMake(35, 120);
    UIGraphicsBeginImageContext(size);
    
    CGPoint image1Point = CGPointMake(0, 0);
    [chr1.image drawAtPoint:image1Point];
    
    CGPoint image2Point = CGPointMake(0, chr1.image.size.height);
    [chr2.image drawAtPoint:image2Point];
    
    CGPoint image3Point = CGPointMake(0, chr1.image.size.height +chr2.image.size.height);
    [chr3.image drawAtPoint:image3Point];
    
    UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageCompose setBackgroundColor:[UIColor redColor]];
    [imageCompose setImage:finalImage];
}

@end
