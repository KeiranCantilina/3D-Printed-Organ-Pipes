# Clear workspace
rm(list=ls())


#Load libraries if just starting
library(reshape2)
library(plyr)


#Set working R directory
#Keiran: "C:\Users\canti021\Documents\Code\R Code"
dir <- "C://Users//canti021//Documents//Code//R Code//"
setwd(dir)

#Manual Parameters
capped <- 1
windsheet_angle <- 20
mouth_angle <- 10


#Parameter generation
i=1
while (i<50){
  pitch <- 246.941644251769*(exp(0.0577622770970408*i))

  wall_thickness <- 1.6165493487*(pitch^(-0.3497646829))*25.4
  
  cap_height <- 13.3868907382*(pitch^(-0.3439352351))*25.4
  
  if(pitch>523.25){
    bottom_thickness <- 0.75*25.4
  }
  if(pitch<523.25){
    bottom_thickness <- 25.4
  }
  if(pitch>2093.00){
    bottom_thickness <- 15
  }
  
  
  if(pitch>261.63){
    windsheet_thickness <- 0.4121588269*(pitch^(-0.3961763730))*25.4
  }
  if(pitch<261.63){
    windsheet_thickness <- 0.045*25.4
  }
  
  
  mouth_height <- 34.3870164358*(pitch^(-0.7459252090))*25.4
  
  if(pitch > 2093.00){
    mouth_height <- 2.20934486421783
  }
  
  if(pitch<92.5){
    pipe_size <- 1*25.4
  }
  if(pitch>92.5&&pitch<261.63){
    pipe_size <- 0.75*25.4
  }
  if(pitch>246.94&&pitch<493.880){
    pipe_size <- 0.5*25.4
  }
  if(pitch>466.160&&pitch<523.25){
    pipe_size <- 0.375*25.4
  }
  if(pitch>493.88){
    pipe_size <- 0.250*25.4
  }
  
  
  internal_width <- 44.7315507802*(pitch^(-0.6666335381))*25.4
  
  internal_depth <- 56.2332326807*(pitch^(-0.6666085948))*25.4
  
  internal_height <- 4109.2976660014*(pitch^(-1.0645921874))*25.4
  
  mouth_angle <- mouth_angle
  
  windsheet_angle <- windsheet_angle
  
  capped <- capped
  
  
  
  


  
  scad <- paste("wall_thickness=",wall_thickness,"; //[0: 0.001 :10]
  cap_height=",cap_height,"; //[0: 0.001 :100]
  bottom_thickness=",bottom_thickness,"; //[0: 0.01 :50]
  windsheet_thickness=",windsheet_thickness,"; //[0: 0.001 :5]
  mouth_height=",mouth_height,"; //[0: 0.001 :50]
  pipe_size=",pipe_size,";  //[0: 0.001 :20]
  internal_width=",internal_width,"; //[0: 0.001 :100]
  internal_depth=",internal_depth,"; //[0: 0.001 :100]
  internal_height=",internal_height,"; //[0: 0.001 :1000]
  mouth_angle=",mouth_angle,";  //[0: 0.1 :90]
  windsheet_angle=", windsheet_angle,";  //[0: 0.1 :50]
  capped=",capped,"; //[1, 0]
  
  module pipe(wall_thickness, cap_height, bottom_thickness, windsheet_thickness, mouth_height, pipe_size, internal_width, internal_depth, internal_height, mouth_angle, windsheet_angle,capped);
  
  difference(){
  cube([(internal_depth+(2*wall_thickness)), (internal_width+(2*wall_thickness)), (internal_height+cap_height)]);
  translate([wall_thickness, wall_thickness, bottom_thickness]){
  cube([internal_depth, internal_width, (internal_height+cap_height-bottom_thickness+1)]);
  }
  translate([wall_thickness, wall_thickness, cap_height]){
  cube([(internal_depth+wall_thickness+1), internal_width, mouth_height]);
  }
  translate([((internal_depth+(2*wall_thickness))/2), ((internal_width+(2*wall_thickness))/2), -1]){
  cylinder(h=bottom_thickness+2, d=pipe_size, $fn=30);
  }
  translate([(internal_depth+wall_thickness), wall_thickness, (cap_height+mouth_height)]){
  rotate([0, mouth_angle, 0]){
  cube([wall_thickness, internal_width, internal_height]);
  }
  }
  }
  
  difference(){
  union(){
  translate([wall_thickness, wall_thickness, bottom_thickness]){
  cube([(internal_depth-windsheet_thickness-wall_thickness), internal_width, (cap_height-bottom_thickness)]);
  }
  translate([(internal_depth-windsheet_thickness), wall_thickness, cap_height]){
  rotate(a=-90, v=[1, 0, 0]){
  cylinder(h=internal_width, r=wall_thickness, $fn=30);
  }
  }
  }
  translate([(internal_depth-wall_thickness-windsheet_thickness), wall_thickness-1, cap_height]){
  cube([(2*wall_thickness), internal_width+2, mouth_height]);
  }
  translate([(internal_depth-windsheet_thickness), wall_thickness-1, (cap_height-wall_thickness)]){
  rotate(a=-windsheet_angle-180, v=[0, 1, 0]){
  cube([internal_depth, internal_width+2, cap_height]);
  }
  }
  }
  
  if(capped==1){
  translate([0, 0, (internal_height+cap_height)]){
  cube([(internal_depth+(2*wall_thickness)), (internal_width+(2*wall_thickness)), wall_thickness]);
  }
  }",sep="")
  
  
  fileConn<-file(paste(dir,pitch,"_Hz_Bourdon.scad",sep=""))
  writeLines(scad, fileConn)
  close(fileConn)
  
  i <- i+1
}

