//Parameters

//All dimensions in mm
//Frequency is in Hz
//Assuming pressure of 2 in. H20


f = 440;
scaling_formula= 25.4*(56.5924582042675*pow(f,-0.666621066467016)); //Scaling formula for Bourdon pipes

Pressure = 2; //inches of water, pressure
Cap = 1; //1=yes, 2=no




//Intermediate variables



ID = scaling_formula;
echo(ID);


Lip_angle = 20;

IW = (3.14159*ID)/4;

Wall_thickness = 1.2;

//Formula for PL based on Liljencrants numbers
Pipe_length= Cap*((86004.4/f)-IW);

//Formula for MH based on Giangiulio's equation
openMHformula = 550/(pow(2,(ln (f))));
closedMHformula = pow((3.018-(0.233*(ln (f)))),5);

Mouth_height = (Cap-1)*(openMHformula)+(-1*(Cap-2))*(closedMHformula);

//Formula for WST based on Ising's #
WST = 25.4*(((4.8*(pow(f,2))*(pow(Mouth_height/25.4,3)))/Pressure)*1.554*pow(10,-6));

echo(WST);
echo(Mouth_height);

Foot_hole_radius = ID/9;
Foot_wall = Wall_thickness;


OD = ID+(2*Wall_thickness);
SU = OD/2;  //SU is standard arbitrary unit equal to outer radius


prism_width = OD;

windsheet_displacement = sqrt(((ID*ID)-(IW*IW))/4);

prism_thickness = SU-(WST+windsheet_displacement);

prism_height = (prism_thickness*sin(90-Lip_angle))/(sin(Lip_angle))  ;

Mouth_cylinder_height = prism_height+Mouth_height;

resonator_length = Pipe_length - Mouth_cylinder_height;


foot_vert_disp = 0;
collar_vert_disp = SU;
languid_vert_disp = SU;
mouth_vert_disp = 2*SU;
resonator_vert_disp = 2*SU + Mouth_cylinder_height;
cap_vert_disp = resonator_vert_disp + resonator_length;

languid_thickness = Wall_thickness ;







//Prism module
 module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       
       }





//foot of pipe
difference(){
    cylinder(h=SU, r1=SU, r2=SU, center=false,$fn=50);
    cylinder(h=SU,r1=SU-Wall_thickness,r2=SU-Wall_thickness, center=false,$fn=50);
}

//Hole in foot of pipe
difference(){
    cylinder(h=Wall_thickness, r1=SU, r2=SU, center = false, $fn=50);
    cylinder(h=Wall_thickness*2,r1=Foot_hole_radius, r2= Foot_hole_radius, center = false, $fn=50);
}

//wall above foot
translate ([0,0,collar_vert_disp])
    difference(){
        cylinder(h=SU,r1=SU,r2=SU, center =false,$fn=50);
        cylinder(h=SU, r1=SU-Wall_thickness, r2=SU-Wall_thickness,center=false,$fn=50);
    }

//languid
translate([0,0,languid_vert_disp]){
    difference(){
        difference(){   
            difference(){

                cylinder (h=SU,r1=SU,r2=SU,center=false,$fn=50);
                
                rotate ([270,270,0]){
                    translate ([0,windsheet_displacement,0])
                        cylinder (h=2*SU,r1=SU-languid_thickness,r2=SU-languid_thickness,center=true,$fn=50);
                }
            }
            
            translate ([windsheet_displacement,-SU,0])
                cube ([WST,2*SU,SU]);
        }
        
        rotate([270,0,90]){
            translate([-SU,-SU/2,0])
                prism(SU*2,SU/2,SU);
        }
    }
}

//Mouth
translate([0,0,mouth_vert_disp]){
    difference(){
        difference(){
            cylinder(h=Mouth_cylinder_height, r1=SU, r2=SU, center=false,$fn=50);
            cylinder(h=Mouth_cylinder_height,r1=SU-Wall_thickness,r2=SU-Wall_thickness, center=false,$fn=50);
        }
        
       translate([windsheet_displacement+WST,-SU,0])
            cube([SU,SU*2,Mouth_cylinder_height]);
    }
    intersection(){
        translate([windsheet_displacement+WST,-SU,Mouth_height])
            rotate([90,0,90])
                prism(prism_width,prism_height,prism_thickness);
        
        cylinder(h=SU*12,r1=SU,r2=SU, center = false,$fn=50);
        
        }
        
}



//Resonant length    
translate ([0,0,resonator_vert_disp])
    difference(){
        cylinder(h=resonator_length,r1=SU,r2=SU, center =false,$fn=50);
        cylinder(h=resonator_length, r1=SU-Wall_thickness, r2=SU-Wall_thickness,center=false,$fn=50);
   }
    
//Cap
if (Cap==1){
    translate([0,0,cap_vert_disp])
        cylinder(h=languid_thickness,r1=SU,r2=SU, center=false, $fn=50);
}


//ID = 24.84344;
//WST = 0.9398; //for A440
//Empirical formula for Bourdon WST = 0.4121588269*(pow(f,-0.3961763730))*25.4;

