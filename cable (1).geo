// Cable Geometry File

// Read the data from the cable_data.geo File
Include "cable_data.geo";

Mesh.Algorithm = 6; // Check if this is the Algorithmwe want

Mesh.ElementOrder = 1; // Can also be 2

SetFactory("OpenCASCADE");

x0 = 0; y0 = 0;
x1 = d_cu+2*t_sc_in+2*t_sc_out+2*t_xlpe+t_poly_sheet*2+2*t_steel_armour+dis; y1 = 0;
x2 = -x1; y2 = 0;

sur_wire = {};
sur_wire(0) = news; Disk(news) = {x0,y0,0,d_cu/2};
sur_wire(1) = news; Disk(news) = {x1,y1,0,d_cu/2};
sur_wire(2) = news; Disk(news) = {x2,y2,0,d_cu/2};

sur_semi_in = {};
sur_semi_in(0) = news; Disk(news) = {x0,y0,0,d_cu/2+t_sc_in};
sur_semi_in(1) = news; Disk(news) = {x1,y1,0,d_cu/2+t_sc_in};
sur_semi_in(2) = news; Disk(news) = {x2,y2,0,d_cu/2+t_sc_in};

sur_xlpe = {};
sur_xlpe(0) = news; Disk(news) = {x0,y0,0,d_cu/2+t_sc_in+t_xlpe};
sur_xlpe(1) = news; Disk(news) = {x1,y1,0,d_cu/2+t_sc_in+t_xlpe};
sur_xlpe(2) = news; Disk(news) = {x2,y2,0,d_cu/2+t_sc_in+t_xlpe};

sur_semi_out = {};
sur_semi_out(0) = news; Disk(news) = {x0,y0,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out};
sur_semi_out(1) = news; Disk(news) = {x1,y1,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out};
sur_semi_out(2) = news; Disk(news) = {x2,y2,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out};

sur_al = {};
sur_al(0) = news; Disk(news) = {x0,y0,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out+t_al};
sur_al(1) = news; Disk(news) = {x1,y1,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out+t_al};
sur_al(2) = news; Disk(news) = {x2,y2,0,d_cu/2+t_sc_in+t_xlpe+t_sc_out+t_al};

R = d_cu/2+t_sc_in+t_xlpe+t_sc_out+t_al+0*t_poly_sheet;
R1 = d_cu/2+t_sc_in+t_xlpe+t_sc_out+t_al+t_poly_sheet;
R2 = R1+t_steel_armour;
arc_angle = Pi;

arc_aux0() += newl; Circle(newl) = {x1,y1,0,R,-Pi/2,-Pi/2+arc_angle};
arc_aux0() += newl; Circle(newl) = {x2,y2,0,R,Pi/2,Pi/2+arc_angle};

lin_aux() += newl; Line(newl) = {16,19};
lin_aux() += newl; Line(newl) = {17,18};
Curve Loop(newll) = {17,18,16,19};
sur_case()+=news; Plane Surface(news) = {newll-1};

arc_aux1() += newl; Circle(newl) = {x1,y1,0,R1,-Pi/2,-Pi/2+arc_angle};
arc_aux1() += newl; Circle(newl) = {x2,y2,0,R1,Pi/2,Pi/2+arc_angle};
lin_aux1() += newl; Line(newl) = {20,23};
lin_aux1() += newl; Line(newl) = {21,22};
Curve Loop(newll) = {25,23,24,22};
sur_case1()+=news; Plane Surface(news) = {newll-1};

arc_aux2() += newl; Circle(newl) = {x1,y1,0,R2,-Pi/2,-Pi/2+arc_angle};
arc_aux2() += newl; Circle(newl) = {x2,y2,0,R2,Pi/2,Pi/2+arc_angle};
lin_aux2() += newl; Line(newl) = {24,27};
lin_aux2() += newl; Line(newl) = {26,25};
Curve Loop(newll) = {31,29,30,28};
sur_case2()+=news; Plane Surface(news) = {newll-1};

sur_tot = {};
sur_tot(0) = news; Disk(news) = {x0,y0,0,d_tot/2};

sur_tot1 = {};
sur_tot1(0) = news; Disk(news) = {x0,y0,0,d_tot/2-t_steel_pipe-t_poly_cover};

sur_tot2 = {};
sur_tot2(0) = news; Disk(news) = {x0,y0,0,d_tot/2-t_poly_cover};

BooleanFragments{
  Surface{
    sur_wire(), sur_semi_in(), sur_xlpe(), sur_semi_out(), sur_al(), sur_case(), sur_case1(), sur_case2(),sur_tot1(), sur_tot2()

  }; Delete;
}{}
// above you've defined the sur_tot1 and 2. so let's give them an unused number
//now you can correctly assign your name  
sur_tot1 = 12;
sur_tot2 = 13;

sur_wire() = {1,2,3};
sur_sc_in() = {35,36,37};
sur_xlpe() = {38,39,40};
sur_semi_out() = {41,42,43};
sur_al() = {44,45,46};
surf_air_in() = {47,48};
sur_steel_armour = 49;
sur_air = 51;
sur_steelpipe = 52;
sur_polycover = 53;
