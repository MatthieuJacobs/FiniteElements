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

  For k In {1:NbWires}
    Ind = Region[{(WIRE+k-1)}];
    Inds  += Region[{(WIRE+k-1)}];
  EndFor

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
  Vol_Thermal      = Region[{Domain_Mag, AirTH, SoilTH}];

}
