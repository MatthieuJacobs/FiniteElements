// Cable Geometry File

// Read the data from the cable_data.geo File
Include "cable_data.geo";

Mesh.Algorithm = 6; // Check if this is the Algorithm we want

Mesh.ElementOrder = 1; // Can also be 2

SetFactory("OpenCASCADE");



x0 = 0; y0 = 0;
x1 = d_cu+2*t_sc_in+2*t_sc_out+2*t_xlpe+2*t_poly_sheet+2*t_al+dis; y1 = 0;
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
sur_case()+=news; Plane Surface(news) = {newll-1}; //de '-1' returnt volgens mij de previous available newll ipv de next available newll

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

// most outer surface
sur_tot = {};
sur_tot(0) = news; Disk(news) = {x0,y0,0,d_tot/2};

// inner surface
sur_tot1 = {};
sur_tot1(0) = news; Disk(news) = {x0,y0,0,d_tot/2-t_steel_pipe-t_poly_cover};

// surface poly cover
sur_tot2 = {};
sur_tot2(0) = news; Disk(news) = {x0,y0,0,d_tot/2-t_poly_cover};

//Computes all the fragments resulting from the intersection of the entities
//The arguments are the surfaces with overlapping boundaries
BooleanFragments{
  Surface{:}; Delete; //Deletes the entities
}{}

// above you've defined the sur_tot1 and 2. so let's give them an unused number
//now you can correctly assign your name
sur_tot1 = 12;
sur_tot2 = 13;

sur_wire() = {1,2,3}; //rood
sur_semi_in() = {4,5,6}; //roos
sur_xlpe() = {7,8,9}; //groen
sur_semi_out() = {10,11,12}; //roos
sur_al() = {13,14,15}; //darkblue
surf_air_in() = {16,17}; //lichtblauw
sur_ps = 18; //geel
sur_steel_armour = 19; //grijs
sur_pc = 20;
sur_air = 21; //lichtblauw
sur_steelpipe = 22; //grijs

//polyethyleen sheet
sur_ps_aux() = {};
sur_ps_aux(0) = news; Disk(news) = {x0,y0,0.,R+t_poly_sheet};
sur_ps_aux(1) = news; Disk(news) = {x1,y1,0.,R+t_poly_sheet};
sur_ps_aux(2) = news; Disk(news) = {x2,y2,0.,R+t_poly_sheet};

// Group surfaces per conductor
sur_wire_0() = {sur_wire(0), sur_semi_in(0), sur_xlpe(0), sur_semi_out(0),sur_al(0)};
sur_wire_1() = {sur_wire(1), sur_semi_in(1), sur_xlpe(1), sur_semi_out(1),sur_al(1)};
sur_wire_2() = {sur_wire(2), sur_semi_in(2), sur_xlpe(2), sur_semi_out(2),sur_al(2)};

//booleandifference{object}{tool}: substracts tool from object
sur_ps2(0) = news; BooleanDifference(news) = {Surface{sur_ps_aux(0)}; Delete;}{Surface{sur_wire_0()};};
sur_ps2(1) = news; BooleanDifference(news) = {Surface{sur_ps_aux(1)}; Delete;}{Surface{sur_wire_1()};};
sur_ps2(2) = news; BooleanDifference(news) = {Surface{sur_ps_aux(2)}; Delete;}{Surface{sur_wire_2()};};

//moeten wij volgens mij niet doen, want de inner air is bij ons al gedefinieerd
//sur_air_in() = BooleanDifference{Surface{surf_air_in(1)}, Delete;} {Surface{sur_tri}};
//surf_air_in_air()-=sur_air(1);
//sur_ps_exact() = BooleanFragments{Surface{sur_ps2(),sur_ps}; Delete; }{};
  BooleanFragments{
    Surface{:}; Delete; //Deletes the entities
  }{}

// Redefine names after BooleanFragments
sur_wire = {1,2,3};
sur_semi_in = {4,5,6};

sur_semi_out = {10,11,12};
sur_al = {13,14,15};
sur_ps = {23,25,26,28,29,30,31,32,33,34,35,36};
sur_steel_armour = 19;
sur_air_in = {24,27};
sur_pc = 20;
sur_air = 21;
sur_steel_pipe = 22;

If (Flag_Defect)
  sur_defect = news; Disk(news) = {d_cu/2+t_sc_in+2*d_def, 0,0, d_def/2};
  sur_XLPE_defect() = {};
  sur_XLPE_defect(0) = news; BooleanDifference(news) = {Surface{sur_xlpe(0)}; Delete;}{Surface{sur_defect};};
  sur_xlpe = {8,9};
Else
  sur_xlpe = {7,8,9};
EndIf
//-- Around the cable --
all_sur_cable = Surface{:};


//electromagnetic analysis domain
sur_EMdom = news; Disk(news) = {0, 0, 0., dinf/2};
BooleanDifference(news) = { Surface{sur_EMdom}; Delete; }{ Surface{all_sur_cable()};};
sur_EMdom = news - 1;

//thermal analysis domain
//Rectangle: the 3 first expressions define the lower-left corner; the next 2 define the width and height.
sur_soil = news; Rectangle(news) = {-dinf_th, -dinf_th, 0, 2*dinf_th, dinf_th + depth_cable};
BooleanDifference(news) = {Surface{sur_soil}; Delete;}{Surface{all_sur_cable()};};
sur_soil = news - 1;

sur_airout = news; Rectangle(news) = {-dinf_th, depth_cable, 0, 2*dinf_th, dinf_th_air};

all_sur() = Surface{:};
all_sur_after_frag()=BooleanFragments{Surface{all_sur()}; Delete;}{ };
//Returns the boundary of the elementary entities, combined as if a single entity, in transform-list
bnd() = CombinedBoundary{Surface{all_sur_after_frag()};};
Printf("",bnd());

//sur_EMdom = {68,69};

bnd_EMdom() = CombinedBoundary{Surface{sur_EMdom};};
Printf("",bnd_EMdom());

// Set some characteristic lengths
c1 = d_tot/s;
// characteristic length
Characteristic Length { PointsOf{Surface{sur_pc,sur_steel_pipe};}} = c1/16;
Characteristic Length { PointsOf{Surface{sur_ps(),sur_steel_armour};}} = c1/32;

Characteristic Length { PointsOf{Line{bnd_EMdom(1)};}} = 2*c1;
Characteristic Length { PointsOf{Surface{sur_airout()};Line{bnd(0)};}} = 5*c1;
Characteristic Length { PointsOf{Surface{sur_wire(),sur_semi_in(),sur_semi_out(),sur_xlpe(), sur_al()};}} = c1/64;

If(Flag_Defect)
  Characteristic Length{PointsOf{Surface{sur_defect};}} = c1/128;
  Characteristic Length{PointsOf{Surface{sur_XLPE_defect};}} = c1/32;
EndIf

////////////////////////////////////////////////////
// Physical regions => Link to pro file and FE
/////////////////////////////////////////////////
Physical Surface("wire1", WIRE+0) = sur_wire(0);
Physical Surface("wire2", WIRE+1) = sur_wire(1);
Physical Surface("wire3", WIRE+2) = sur_wire(2);

Physical Surface("inner semiconductor", SEMI_IN) = sur_semi_in();
Physical Surface("outer semiconductor", SEMI_OUT) = sur_semi_out();
Physical Surface("Aluminium tape", APL) = sur_al();
Physical Surface("Air in cable", AIR_IN) = {sur_air(), sur_air_in()};
Physical Surface("POLYETHYLENE_SHEATH", POLYETHYLENE_SHEATH) = sur_ps();
Physical Surface("Steel Armour",STEEL_ARMOUR) = sur_steel_armour();

Physical Surface("Steel pipe", STEEL_PIPE) = sur_steel_pipe();
Physical Surface("POLYETHYLENE_COVER", POLYETHYLENE_COVER) = sur_pc();

Physical Surface("SOIL (EM)", SOIL_EM) = sur_EMdom();
Physical Surface("SOIL_TH", SOIL_TH) = sur_soil();
Physical Surface("Air above soil", AIR_OUT) = sur_airout();


If(Flag_Defect)
  Physical Surface("Defect in XLPE", DEFECT) = sur_defect();
  Physical Surface("XLPE with defect", XLPE_DEFECT) = sur_XLPE_defect();
  Physical Surface("XLPE without defect", XLPE) =  sur_xlpe();
Else
  Physical Surface("XLPE", XLPE) = sur_xlpe();
EndIf

Physical Line("Outer boundary (EM)", OUTBND_EM) = bnd_EMdom(1);
Physical Line("Outer boundary (TH)", OUTBND_TH) = bnd();
Physical Line("Air/Soil interface", INTERFACE_AIR_SOIL) = 159;
