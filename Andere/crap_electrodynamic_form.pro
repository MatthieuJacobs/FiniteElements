//electrodynamic formulation

//http://getdp.info/
FunctionSpace {
  { Name Hgrad_v_ele; Type Form0; //form 0 means scalar field (electric scalar potential)
    BasisFunction {
      { Name sn; NameOfCoef vn; Function BF_Node; Support Domain_Ele; Entity NodesOf[All]; } //vn: nodal values, sn nodal basis functions. ectric scalar potential = op niveau v. nodes, uitgeoefend op elektrisch domein waarvan we alle nodes gebruiken
    }
    Constraint {
      { NameOfCoef vn; EntityType NodesOf; NameOfConstraint ElectricScalarPotential; } //constraint op electric scalar potential gedefinieerd in cable.pro file (Dirichlet bc conditions)
    }
  }
}

//electrodynamic strong formulation: -div(sigma*grad(v) + epsilon*grad(d/dt*v)) = 0
Formulation{
  { Name Form_Electrodynamic_v; Type FemEquation;
    Quantity {
      { Name v; Type Local; NameOfSpace Hgrad_v_ele; } //electric scalar potential in de space die we eerder aangemaakt hebben
    }
    Equation {
      Galerkin { [ sigma[] * Dof{Grad v} , {Grad v} ]; In Domain_Ele; Jacobian Vol ; Integration GradGrad ; } //lees dit als int(epsilon*gradv . gradv); the quantity between {} belongs to a function space; dv is synonym for grad (for a scalar function); de {dv} na de comma zijn de testfuncties sn (zelfde voor Galerkin); Jacobian Vol equals the Jacobian for volume element
      Galerkin { DtDof[ epsilon[] * Dof{Grad v} , {Grad v} ]; In Domain_Ele; Jacobian Vol; Integration I1; } //DtDof is time derivative of only the Dof term between the []
    }
  }
}

Resolution {
  { Name Res_Electrodynamic_v;
    System {
      { Name Sys_Ele; NameOfFormulation Form_Electrodynamic_v;
        Frequency Freq; }
    }
    Operation {
      CreateDir["Electrodynamic_results"]; //creates a diractory names "Electrodynamic_results"
      Generate[Sys_Ele]; Solve[Sys_Ele]; SaveSolution[Sys_Ele];
      PostOperation{Ele_Maps}
    }
  }
}

PostProcessing {

  { Name PostrPr_Electrodynamic_v; NameOfFormulation Form_Electrodynamics_v;
    Quantity {
      { Name v; Value { Term { [ {v} ]; In Domain_Ele; Jacobian Vol; } } } //electric scalar potential
      { Name e; Value { Term { [ -{Grad v} ]; In Domain_Ele; Jacobian Vol; } } } //Electric field e = -Grad(v)
      { Name e_nor; Value { Term { [ Norm[-{Grad v}] ]; In Domain_Ele; Jacobian Vol; } } } //norm of electric field

      { Name dcd; Value { Term { [ -epsilon[] * {Grad v} ]; In Domain_Ele; Jacobian Vol; } } } // Displacement current density dcd = epsilon*e = epsilon* -Grad(v)
      { Name dcd_nor; Value { Term { [ Norm[-epsilon[] * {Grad v}] ]; In Domain_Ele; Jacobian Vol; } } } //norm of displacement current density

      { Name j ; Value { Term { [ -sigma[] * {Grad v} ] ; In Domain_Ele ; Jacobian Vol; } } } //current density j = sigma*e = sigma* -Grad(v)
      { Name j_nor ; Value { Term { [ Norm[-sigma[] * {Grad v}] ] ; In Domain_Ele ; Jacobian Vol; } } }//norm of current density

      //ik ben niet zeker of dit suk, Gr. Rutger
      /* { Name jtot ; Value {
          Term { [ -sigma[] * {Grad v} ] ;       In Domain_Ele ; Jacobian Vol; }
          Term { [ -epsilon[] * Dt[{Grad v}] ] ; In Domain_Ele ; Jacobian Vol; }
        } } */

      { Name ElectricEnergy; Value {
          Integral {
            [ 0.5 * epsilon[] * SquNorm[{Grad v}] ]; //electrical energy U = int(0.5*epsilon*|e|²) = = int(0.5*epsilon*|grad(v)|²)
            In Domain_Ele; Jacobian Vol; Integration GradGrad;
          }
	       }
      }

      { Name V0 ; Value {
          // For recovering the imposed voltage in post-pro
          // Most likely you will need to adapt for your cable
          // The default hereafter is for a three-phase cable
          Term { Type Global ; [ V0 * F_Cos_wt_p[]{2*Pi*Freq, Phase_angle1}] ; In Conductor1 ; }
          Term { Type Global ; [ V0 * F_Cos_wt_p[]{2*Pi*Freq, Phase_angle2}] ; In Conductor2 ; }
          Term { Type Global ; [ V0 * F_Cos_wt_p[]{2*Pi*Freq, Phase_angle3}] ; In Conductor3 ; }
        } }

      { Name C_from_Energy ; Value { Term { Type Global; [ 2*$We/SquNorm[$voltage] ] ; In DomainDummy ; } } }
    }
  }

}
