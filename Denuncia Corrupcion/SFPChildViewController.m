//
//  SFPChildViewController.m
//  PageSFP
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 SFPcoda. All rights reserved.
//

#import "SFPChildViewController.h"
#import <MapKit/MapKit.h>

@interface SFPChildViewController (){
    
    IBOutlet MKMapView *mapView;
    IBOutlet UIImageView *mapBg;
    CLLocationManager *locationManager;

}

@end

@implementation SFPChildViewController

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
    
    switch (self.index) {
        case 0:
            self.screenNumber.text = [NSString stringWithFormat:
                                      @"La Secretaría de la Función Pública, dependencia del Poder Ejecutivo Federal, vigila que los servidores públicos federales se apeguen a la legalidad durante el ejercicio de sus funciones, sanciona a los que no lo hacen así; promueve el cumplimiento de los procesos de control y fiscalización del gobierno federal, de disposiciones legales en diversas materias, dirige y determina la política de compras públicas de la Federación, coordina y realiza auditorías sobre el gasto de recursos federales, coordina procesos de desarrollo administrativo, gobierno digital, opera y encabeza el Servicio Profesional de Carrera, coordina la labor de los órganos internos de control en cada dependencia del gobierno federal y evalúa la gestión de las entidades, también a nivel federal."];
            break;
        case 1:
            self.screenNumber.text = [NSString stringWithFormat:
                                      @"La Secretaría de la Función Pública tiene a su cargo el desempeño de las atribuciones y facultades que le encomiendan:\n\nLa Ley Orgánica de la Administración Pública Federal.\n\nLa Ley Federal de Responsabilidades Administrativas de los Servidores Públicos y demás ordenamientos legales aplicables en la materia.\n\nLa Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público\n\nLa Ley de Obras Públicas y Servicios Relacionados con las Mismas\n\nLa Ley General de Bienes Nacionales\n\nLa Ley del Servicio Profesional de Carrera en la Administración Pública Federal\n\nLa Ley Federal de Presupuesto y Responsabilidad Hacendaria\n\nOtras leyes, reglamentos, decretos, acuerdos y órdenes del Presidente de la República."];
            break;
            
        case 2:
            mapView.hidden = NO;
            mapBg.hidden = NO;
            [self addPin];
            break;
            
        case 3:
            
            self.screenNumber.text = [NSString stringWithFormat:
                                      @"Misión:\nConsolidar un Gobierno honesto, eficiente y transparente.\n\nVisión 2020:\nLa ciudadanía participa y confía en la Función Pública.\n\nAcciones gubernamentales prioritarias\n\nPromover la cultura de la legalidad y el aprecio por la rendición de cuentas.\nAmpliar la cobertura, impacto y efecto preventivo de la fiscalización a la gestión pública.\nInhibir y sancionar las prácticas corruptas.\nArticular estructuras profesionales, eficientes y eficaces del gobierno.\nMejorar la regulación, la gestión y los procesos de la APF.\nOptimizar el uso y aprovechamiento de los inmuebles federales."];
            
            break;
            
        default:
            break;
    }
    
    
    
}



- (void)addPin
{
    MKCoordinateRegion region;
    CLLocationCoordinate2D coord = {(19.3854914),(-99.1863399)};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = @"Secretaría de la Función Pública";
    point.subtitle = @"Av Revolucion 642, San Pedro de Los Pinos";
    
    [mapView addAnnotation:point];
    
    CLLocationCoordinate2D coord2 = {(19.399594),(-99.119728)};
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord2;
    point.title = @"Secretaría de la Función Pública";
    point.subtitle = @"Aeropuerto Internacional del la Ciudad de México";
    
    [mapView addAnnotation:point];
    
    CLLocationCoordinate2D coord3 = {(19.3504952),(-99.1867283)};
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord3;
    point.title = @"Secretaría de la Función Pública";
    point.subtitle = @"Insurgentes Sur 1735, Guadalupe Inn";
    
    [mapView addAnnotation:point];
    region.center = coord;
    region.span = MKCoordinateSpanMake(0.08, 0.08);
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
    
    MKAnnotationView *view = nil;
    
    if(annotation !=mapView.userLocation){
        view = (MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        if(nil == view) {
            view = [[MKAnnotationView alloc]
                     initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }
        
        view.image = [UIImage imageNamed:@"pin.png"];
        if([[annotation subtitle] isEqualToString:@"Av Revolucion 642, San Pedro de Los Pinos"])
            [view setTag:0];
        else if([[annotation subtitle] isEqualToString:@"Aeropuerto Internacional del la Ciudad de México"])
            [view setTag:1];
        else if([[annotation subtitle] isEqualToString:@"Insurgentes Sur 1735, Guadalupe Inn"])
            [view setTag:2];
        
        UIButton *btnViewVenue = [UIButton buttonWithType:UIButtonTypeInfoDark];
        view.rightCalloutAccessoryView=btnViewVenue;
        view.enabled = YES;
        view.canShowCallout = YES;
        view.multipleTouchEnabled = NO;
        
    }       
    return view;
}

- (void)mapView:(MKMapView *)mMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    #endif
    [locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;

    NSURL *URL = nil;
    
    if([view tag] == 0)
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude, 19.3854914,-99.1863399]];
    else if([view tag] == 1)
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude, 19.399594,-99.119728]];
    else if([view tag] == 2)
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude, 19.3504952,-99.1867283]];
    [[UIApplication sharedApplication] openURL:URL];
    
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
