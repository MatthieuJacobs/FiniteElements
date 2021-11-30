/*
  EleSta_v
    Electrostatics - Electric scalar potential v formulation,
    with floating potential
*/

/* I N P U T
   ---------

  GlobalGroup :  (Extension '_Ele' is for Electric problem)
  -----------
    Domain_Ele               Whole electric domain
    DomainCC_Ele             Nonconducting regions
    DomainC_Ele              Conducting regions (not used)
    SkinDomainC_Ele          Skin of conducting regions (surfaces)

  Function :
  --------
    epsr[]                   Relative permittivity

  Constraint :
  ----------
    ElectricScalarPotential  Fixed electric scalar potential
                             (classical boundary condition)
    GlobalElectricPotential  Fixed global electric scalar potential
                             (for perfect conductors)
    GlobalElectricCharge     Fixed global electric charge

  Constants :
  ---------
    Length                   Length (in z-direction) for 2D structure (default: 1.)

  Physical constants :
  ------------------
*/

   eps0 = 8.854187818e-12 ;

/* O U T P U T
   -----------

  PostQuantities :
  --------------
   v : Electric scalar potential
   e : Electric field
   d : Electric flux density
   V : Voltage
   Q : Electric charge
   C : Capacitance
*/

/* --------------------------------------------------------------------------*/

Group {
  DefineGroup[ Domain_Ele, DomainCC_Ele, DomainC_Ele, SkinDomainC_Ele ] ;
}

Function {
  DefineFunction[ epsr ] ;
  DefineConstant[ Length = 1. ] ;
}


/* --------------------------------------------------------------------------*/

FunctionSpace {
  { Name Hgrad_vf_Ele ; Type Form0 ;
    BasisFunction {
      // v = v  s  + v    s
      //      n  n    c,k  c,k
      { Name sn ; NameOfCoef vn ; Function BF_Node ;
        Support DomainCC_Ele ; Entity NodesOf[ All, Not SkinDomainC_Ele ] ; }
      { Name sck ; NameOfCoef vck ; Function BF_GroupOfNodes ;
        Support DomainCC_Ele ; Entity GroupsOfNodesOf[ SkinDomainC_Ele ] ; }
    }
    SubSpace { // only for a PostOperation
      { Name vf ; NameOfBasisFunction sck ; }
    }
    GlobalQuantity {
      { Name GlobalElectricPotential ; Type AliasOf        ; NameOfCoef vck ; }
      { Name GlobalElectricCharge    ; Type AssociatedWith ; NameOfCoef vck ; }
    }
    Constraint {
      { NameOfCoef vn ;
        EntityType NodesOf ; NameOfConstraint ElectricScalarPotential ; }

      { NameOfCoef GlobalElectricPotential ;
        EntityType GroupsOfNodesOf ; NameOfConstraint GlobalElectricPotential ; }
      { NameOfCoef GlobalElectricCharge ;
        EntityType GroupsOfNodesOf ; NameOfConstraint GlobalElectricCharge ; }
    }
  }
}


Formulation {
  { Name Electrostatics_vf ; Type FemEquation ;
    Quantity {
      { Name v ; Type Local  ; NameOfSpace Hgrad_vf_Ele ; }
      { Name Q ; Type Global ;
        NameOfSpace Hgrad_vf_Ele [GlobalElectricCharge] ; }
      { Name V ; Type Global ;
        NameOfSpace Hgrad_vf_Ele [GlobalElectricPotential] ; }

      // only for a PostOperation
      { Name vf ; Type Local ; NameOfSpace Hgrad_vf_Ele [vf] ; }
    }
    Equation {
      Galerkin { [ - eps0 * epsr[] * Dof{Grad v} , {Grad v} ] ;
                 In DomainCC_Ele ; Jacobian Vol ; Integration GradGrad ; }

      GlobalTerm { [ Dof{Q} / Length , {V} ] ; In SkinDomainC_Ele ; }
    }
  }
}


Resolution {
  { Name EleSta_v ;
    System {
      { Name Sys_Ele ; NameOfFormulation Electrostatics_vf ; }
    }
    Operation { Generate Sys_Ele ; Solve Sys_Ele ; SaveSolution Sys_Ele ; }
  }
}


PostProcessing {
  { Name EleSta_v ; NameOfFormulation Electrostatics_vf ;
    PostQuantity {
      { Name v ; Value { Term { [ {v} ]                  ; In DomainCC_Ele ; Jacobian Vol ;} } }
      { Name e ; Value { Term { [ -{Grad v} ]               ; In DomainCC_Ele ; Jacobian Vol ;} } }
      { Name d ; Value { Term { [ -eps0*epsr[] * {Grad v} ] ; In DomainCC_Ele ; Jacobian Vol ;} } }

      { Name Q ; Value { Term { [ {Q} ] ; In SkinDomainC_Ele ; } } }
      { Name V ; Value { Term { [ {V} ] ; In SkinDomainC_Ele ; } } }
      { Name C ; Value { Term { [ {Q}/{V} ] ; In SkinDomainC_Ele ; } } }

      { Name vf ; Value { Term { [ {vf} ]                  ; In DomainCC_Ele ; } } }

      { Name force ;
        Value {
	  Integral {
	    Type Global ;
	    [ eps0*epsr[] / 2. * VirtualWork[{Grad v}] ] ;
	    //In DomainCC_Ele ; // restrict support to speed-up search
            In ElementsOf[DomainCC_Ele, OnOneSideOf SkinDomainC_Ele];
            Jacobian Vol ; Integration GradGrad ;
	  }
	}
      }

      { Name energy ;
        Value {
	  Integral {
	    Type Global ;
	    [ eps0*epsr[] / 2. * SquNorm[{Grad v}] ] ;
	    In DomainCC_Ele ; Jacobian Vol ; Integration GradGrad ;
	  }
	}
      }

    }
  }
}


/* --------------------------------------------------------------------------*/
/* --------------------------------------------------------------------------*/
