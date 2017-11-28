//Prism module
 module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       }





SU =5 ;
windsheet_displacement = 3.5 ;
WST = 0.3 ;
Wall_thickness = 0.4 ;
languid_thickness = Wall_thickness ; 


//



translate([0,0,0]){//this was added
    difference(){
        difference(){   
            difference(){
                
                
                
                
                translate ([0,0,0]){
                    cylinder (h=SU,r1=SU,r2=SU,center=false,$fn=50);
                }
                
                
                
                
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