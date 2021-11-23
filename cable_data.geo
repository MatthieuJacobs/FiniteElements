// File containing the cable data

// Material properties

// Relative permittivity
e_cu = 1;
e_st = 1;
e_poly = 2.25;
e_sc = 2.25;
e_xlpe = 2.25;
e_soil = 1;

// Relative permeabilities
mu_cu = 1;
mu_st = 4;
mu_poly = 1;
mu_sc = 1;
mu_xlpe = 1;
mu_soil = 1;

// Conductivity
sig_cu = 5.99e7;
sig_st = 4.7e6;
sig_poly = 1.0e-18;
sig_sc = 2;
sig_xlpe = 1.0e-18;
sig_soil = 28;

// Thermal Conductivity

kappa_cu = 400;
kappa_st = 50.2;
kappa_poly = 0.46;
kappa_sc = 10;
kappa_xlpe = 0.46;
kappa_soil = 0.4;

// Geometrical Data

mm = 1e-3;

d_cu = mm*62; //diameter conductor
t_sc_in = mm*2.5; //thickness inner semi-conductor
t_sc_out = 2.5*mm; //thickness outer semi-conductor
t_xlpe = mm*31; //thickness XLPE insulation
t_poly_sheet = mm*2; //thickness polyethyleen sheet
t_poly_cover = 2*mm; //thickness polyethyleen cover
t_al = 5.7*mm; //thickness APL sheet
t_steel_armour = 6*mm; //thickness steel wire armour
t_steel_pipe = 6*mm; //thickness steel pipe
dis = 70*mm; //distance between center of conductors
//t_ag = 6*mm; ??
d_tot = 628.2*mm; //total diameter
dinf = 5*d_tot; //electromagnetic domain
depth_cable = 1.5; //[m] laying depth of the cable
dinf_th = 12; //thermal analysis
dinf_th_air = 12 - depth_cable;
