Include "cable_data.geo";

Group{
  AirInCable = Region[{AIR_IN}];
  AirAboveSoil = Region[{AIR_OUT}];
  DefectInXLPE = Region[{DEFECT}];
  AirEM = Region[{AirInCable,DefectInXLPE}];
  AirTH = Region[{AirAboveSoil}];
  Air = Region[{AirEM,AirTH}];

  SemiconductorIn = Region[{SEMI_IN}];
  XLPE = Region[{XLPE}];
  SemiconductorOut = Region[{SEMI_OUT}];
  APLSheath = Region[{APL}];
  Polyethylene = Region[{POLYETHYLENE_SHEATH,POLYETHYLENE_COVER}];
  SteelA = Region[{STEEL_ARMOUR}];
  SteelP = Region[{STEEL_PIPE}];
  Steel = Region[{SteelA, SteelP}];

  SoilEM = Region[{SOIL_EM}];
  SoilTH = Region[{SOIL_TH}];
  Soil = Region[{SoilEM, SoilTH}];

  Ind_1 = Region[{(WIRE+0)}];
  Ind_2 = Region[{(WIRE+1)}];
  Ind_3 = Region[{(WIRE+2)}];
  Inds  = Region[{(WIRE+0), (WIRE+1), (WIRE+2)}];

  /* For k In {1:NbWires}
    Ind = Region[{(WIRE+k-1)}];
    Inds  += Region[{(WIRE+k-1)}];
  EndFor */

  Cable = Region[{Inds, SemiconductorIn, SemiconductorOut, APLSheath, XLPE, Polyethylene}];
  Cable += Region[{DefectInXLPE}];

  // Magnetodynamics
  SurfaceGe0 = Region[{OUTBND_EM}];
  DomainCC_Mag = Region[{AirEM, Inds}];
  DomainCC_Mag += Region[{SemiconductorIn,SemiconductorOut, XLPE, Polyethylene}];
  DomainC_Mag = Region[{Steel,APLSheath}];

  DomainS0_Mag = Region[{}];  // If imposing source with js0[]
  DomainS_Mag = Region[{Inds}]; // If using Current_2D, it allows accouting ...

  DomainCWithI_Mag = Region[{}];
  Domain_Mag = Region[{DomainCC_Mag, DomainC_Mag}];

  // Electrodynamics
  Domain_Ele = Region[{Domain_Mag}];

  //Thermal Domain
  Vol_Thermal = Region[{Domain_Mag, AirTH, SoilTH}];

}

Function {
  mu0 = 4.e-7 * Pi;
  eps0 = 8.854187818e-12;

  nu[Region[{Air, Inds}]] = 1./mu0;
  nu[Region[{SemiconductorIn,SemiconductorOut,XLPE,APLSheath,Polyethylene,Soil}]] = 1./mu0;
  nu[Region[{Steel}]] = 1./(mu0*mu_st);

  sigma[Steel] = sig_st;
  sigma[Polyethylene] = sig_poly;
  sigma[Region[{SemiconductorIn,SemiconductorOut}]] = sig_sc;
  sigma[XLPE] = sig_xlpe;
  sigma[Soil] = sig_soil;
  sigma[Air] = 0.;

  fT_cu[] = (1+alpha_cu*($1-Tref)); //$1 is current temperature in [K], alpha in [1/K]
  fT_al[] = (1+alpha_al*($1-Tref));

  /* If(!Flag_sigma_funcT)
    sigma[Inds]      = sig_cu;
    sigma[APLSheath] = sig_al;
  Else
    sigma[Inds]      = sig_cu/fT_cu[$1];
    sigma[APLSheath] = sig_al/fT_al[$1];
  EndIf */

  epsilon[Region[{Air, Inds, APLSheath, Soil, Steel}]] = eps0;
  epsilon[Region[{Polyethylene}]] = eps0*e_poly;
  epsilon[Region[{SemiconductorIn, SemiconductorOut}]] = eps0*e_sc;
  epsilon[Region[{XLPE}]] = eps0*e_xlpe;

  Freq = 50;
  Pa = 0.; Pb = -120./180.*Pi; Pc = -240./180.*Pi; // fases in cable
  I = 1540; // maximum value current in data sheet
  V0 = 550000;
  js0[Ind_1] = Vector [0,0,1] * I / SurfaceArea[] * F_Cos_wt_p[]{2*Pi*Freq, Pa}; //current densities
  js0[Ind_2] = Vector [0,0,1] * I / SurfaceArea[] * F_Cos_wt_p[]{2*Pi*Freq, Pb};
  js0[Ind_3] = Vector [0,0,1] * I / SurfaceArea[] * F_Cos_wt_p[]{2*Pi*Freq, Pc};

  Ns[] = 1;
  Sc[] = SurfaceArea[];

  //second order calculation
  //Flag_Degree_a = deg2_hierarchical ? 2:1;
  //Flag_Degree_v = deg2_hierarchical ? 2:1;

  //thermal Parameters
  Tambient[] = Tamb; // [K]

  //thermal conductivities [W/(mK)]
  k[Steel] = kappa_st;
  k[APLSheath] = kappa_al;
  k[Polyethylene] = kappa_poly;
  k[Region[{SemiconductorIn,SemiconductorOut}]] = kappa_sc;
  k[XLPE] = kappa_xlpe;
  k[Soil] = kappa_soil;
  k[Inds] = kappa_cu;
  k[Air] = kappa_air;
  //* heat conduction mechanism is the main heat transfer mechanism for an undergorund cable system
  //* all materials have constant thermal properties, including the thermal resistivity of the soil
  //* radiation and convection are not considered

  //* force convection on ground surface due to wind: h = 7.371 + 6.43*v^0.75
  //*Not used here
  //h[] = 7.371 + 6.43*v_wind^0.75; // 1, 10...Convection coefficient [W/(m^2K)]
}

Constraint{
  //Electric Constraint
  {Name ElectricScalarPotential;
    Case{
      {Region Ind_1; Value V0; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pa};}
      {Region Ind_2; Value V0; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pb};}
      {Region Ind_3; Value V0; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pc};}
      {Region SurfaceGe0; Value 0;}
    }
  }
  {Name ZeroElectricalScalarPotential;
  Case {
    For k In {1:3}
      {Region Ind~{k}; Value 0; }
      EndFor
      {Region SurfaceGe0; Value 0;}
    }
  }

  // Magnetic constraints
  {Name MagneticVectorPotential_2D;
    Case{
      {Region SurfaceGe0; Value 0.;}
    }
  }
  {Name Voltage_2D;
   Case {

   }
  }
  {Name Current_2D;
   Case{
     // Constraint used if Inds in DomainS_Mag
     {Region Ind_1; Value I; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pa};}
     {Region Ind_2; Value I; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pb};}
     {Region Ind_3; Value I; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, Pc};}

     //Useful in DomainCWithI_Mag
     // {Region Steel ; Value 0.;}
     // {Region APLSheat ; Value 0.;}
   }
 }

 //Thermal constraints
  /* {Name DirichletTemp ;
    Case{
      { Type Assign; Region Sur_Dirichlet_Thermal; Value Tambient[];}
    }
  } */

}
