wall_thickness=9.51443150487179; //[0: 0.001 :10]
  cap_height=80.7342210117856; //[0: 0.001 :100]
  bottom_thickness=25.4; //[0: 0.01 :50]
  windsheet_thickness=1.143; //[0: 0.001 :5]
  mouth_height=38.6288075005913; //[0: 0.001 :50]
  pipe_size=25.4;  //[0: 0.001 :20]
  internal_width=69.9994008891596; //[0: 0.001 :100]
  internal_depth=88.0073018034369; //[0: 0.001 :100]
  internal_height=1218.16520083027; //[0: 0.001 :1000]
  mouth_angle=10;  //[0: 0.1 :90]
  windsheet_angle=20;  //[0: 0.1 :50]
  capped=1; //[1, 0]
  
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
  }
