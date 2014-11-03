//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ProcedureChildViewController.h"

@interface ProcedureChildViewController ()

@end

@implementation ProcedureChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            [self.image1 removeFromSuperview];
            [self.image2 removeFromSuperview];
            self.title1.frame = CGRectMake(30, 122, 260, 21);
            self.text1.frame = CGRectMake(30, 141, 260, 128);
            
        }
        if (iOSDeviceScreenSize.height == 568)
        {
            
        }
        
    }
    switch (self.index) {
        case 0:
            self.title1.text = [NSString stringWithFormat:@"1. Registrate"];
            self.text1.text = [NSString stringWithFormat:
                                @"Completar tu registro te da acceso a todas la funciones de la app como, ver las denuncias que otros han realizado, hacer una denuncia, recibir notificaciones sobre el estátus de tus denincias, acceder al portal de obligaciones, entre otras. Aún despues de registrarte tu identidad se mantiene anónima, únicamente cuando decides lo contrario al realizar una denuncia se solicitarán tus datos personales."];
            self.title2.text = [NSString stringWithFormat:@"2. Mira las denuncias"];
            self.text2.text = [NSString stringWithFormat:
                               @"En la sección de denuncias podrás ver el feed de denuncias que otros usuarios de la app han realizado y que han marcado como públicas. Las denncias que se muestran en esta sección no han sido validadas por la SFP únicamente representan un resumen de lo que a alguien le ha sucedido."];
            break;
        case 1:
            [self.image1 setImage:[UIImage imageNamed:@"fotoIcon.png"]];
            [self.image2 setImage:[UIImage imageNamed:@"procedimientoIcon2.png"]];
            self.title1.text = [NSString stringWithFormat:@"3. ¡Denuncia!"];
            self.text1.text = [NSString stringWithFormat:
                               @"Elije el icono que más se acerque a lo que te sucedió y ¡denuncia! Si no conoces los significados accede al glosario y asegurate de elegir el que más se aproxime a lo que te sucedio. Describe tu situación, adjunta evidencia como fotos, video o audio, selecciona la fecha y el lugar donde te ocurrió. Al enviar tu denuncia recibirás un codigo QR y un numero de folio con el que se dará seguimiento a tu denuncia. Comparte en Facebook y Twitter."];
            self.title2.text = [NSString stringWithFormat:@"4. Sigue el estátus de tus denuncias."];
            self.text2.text = [NSString stringWithFormat:
                               @"Recibirás notificaciones cuando un cambio en el etátus de tu denuncia ocurra. En la sección de mis denuncias podrás verificar el estátus actual de tus denuncias y visualizar un breve resumen de las mismas."];
            break;
        case 2:
            [self.image1 setImage:[UIImage imageNamed:@"puertaIcon.png"]];
            [self.image2 setImage:[UIImage imageNamed:@"manitaIcon.png"]];
            self.title1.text = [NSString stringWithFormat:@"5. Conoce la SFP"];
            self.text1.text = [NSString stringWithFormat:
                               @"Accede a la sección de Sobre la SFP para conocer más acerca de la Secretaría de la Función Pública, la ubicación de sus oficinas y sus objetivos."];
            self.title2.text = [NSString stringWithFormat:@"6. Visita el Portal de Transparencia"];
            self.text2.text = [NSString stringWithFormat:
                               @"En la sección de Portal, tendrás acceso al Portal de Obligaciones de Transparencia(POT) en donde encontrarás (entre otra) información del gobierno federal relacionada con el directorio, contratos, informes, remuneraciones, normatividad, subsidios, servicios, concesiones y permisos que se publica conforme lo indica la Ley Federal de Transparencia y Acceso a la Información Pública Gubernamental."];
            break;

    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
