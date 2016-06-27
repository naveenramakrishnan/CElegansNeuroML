TITLE Mod file for component: Component(id=k_fast type=ionChannelHH)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.4.5
         org.neuroml.model   v1.4.5
         jLEMS               v0.9.8.5

ENDCOMMENT

NEURON {
    SUFFIX k_fast
    USEION k WRITE ik VALENCE 1 ? Assuming valence = 1; TODO check this!!
    
    RANGE gion                           
    RANGE gmax                              : Will be changed when ion channel mechanism placed on cell!
    RANGE conductance                       : parameter
    
    RANGE g                                 : exposure
    
    RANGE fopen                             : exposure
    RANGE p_instances                       : parameter
    
    RANGE p_tau                             : exposure
    
    RANGE p_inf                             : exposure
    
    RANGE p_rateScale                       : exposure
    
    RANGE p_fcond                           : exposure
    RANGE p_timeCourse_tau                  : parameter
    
    RANGE p_timeCourse_t                    : exposure
    RANGE p_steadyState_rate                : parameter
    RANGE p_steadyState_midpoint            : parameter
    RANGE p_steadyState_scale               : parameter
    
    RANGE p_steadyState_x                   : exposure
    RANGE q_instances                       : parameter
    
    RANGE q_tau                             : exposure
    
    RANGE q_inf                             : exposure
    
    RANGE q_rateScale                       : exposure
    
    RANGE q_fcond                           : exposure
    RANGE q_timeCourse_tau                  : parameter
    
    RANGE q_timeCourse_t                    : exposure
    RANGE q_steadyState_rate                : parameter
    RANGE q_steadyState_midpoint            : parameter
    RANGE q_steadyState_scale               : parameter
    
    RANGE q_steadyState_x                   : exposure
    RANGE p_tauUnscaled                     : derived variable
    RANGE q_tauUnscaled                     : derived variable
    RANGE conductanceScale                  : derived variable
    RANGE fopen0                            : derived variable
    
}

UNITS {
    
    (nA) = (nanoamp)
    (uA) = (microamp)
    (mA) = (milliamp)
    (A) = (amp)
    (mV) = (millivolt)
    (mS) = (millisiemens)
    (uS) = (microsiemens)
    (molar) = (1/liter)
    (kHz) = (kilohertz)
    (mM) = (millimolar)
    (um) = (micrometer)
    (umol) = (micromole)
    (S) = (siemens)
    
}

PARAMETER {
    
    gmax = 0  (S/cm2)                       : Will be changed when ion channel mechanism placed on cell!
    
    conductance = 1.0E-5 (uS)
    p_instances = 4 
    p_timeCourse_tau = 2.25518 (ms)
    p_steadyState_rate = 1 
    p_steadyState_midpoint = -8.0523205 (mV)
    p_steadyState_scale = 7.42636 (mV)
    q_instances = 1 
    q_timeCourse_tau = 149.96301 (ms)
    q_steadyState_rate = 1 
    q_steadyState_midpoint = -15.645601 (mV)
    q_steadyState_scale = -9.97468 (mV)
}

ASSIGNED {
    
    gion   (S/cm2)                          : Transient conductance density of the channel? Standard Assigned variables with ionChannel
    v (mV)
    celsius (degC)
    temperature (K)
    ek (mV)
    ik (mA/cm2)
    
    
    p_timeCourse_t (ms)                    : derived variable
    
    p_steadyState_x                        : derived variable
    
    p_rateScale                            : derived variable
    
    p_fcond                                : derived variable
    
    p_inf                                  : derived variable
    
    p_tauUnscaled (ms)                     : derived variable
    
    p_tau (ms)                             : derived variable
    
    q_timeCourse_t (ms)                    : derived variable
    
    q_steadyState_x                        : derived variable
    
    q_rateScale                            : derived variable
    
    q_fcond                                : derived variable
    
    q_inf                                  : derived variable
    
    q_tauUnscaled (ms)                     : derived variable
    
    q_tau (ms)                             : derived variable
    
    conductanceScale                       : derived variable
    
    fopen0                                 : derived variable
    
    fopen                                  : derived variable
    
    g (uS)                                 : derived variable
    rate_p_q (/ms)
    rate_q_q (/ms)
    
}

STATE {
    p_q  
    q_q  
    
}

INITIAL {
    ek = -60.0
    
    temperature = celsius + 273.15
    
    rates()
    rates() ? To ensure correct initialisation.
    
    p_q = p_inf
    
    q_q = q_inf
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    ? DerivedVariable is based on path: conductanceScaling[*]/factor, on: Component(id=k_fast type=ionChannelHH), from conductanceScaling; null
    ? Path not present in component, using factor: 1
    
    conductanceScale = 1 
    
    ? DerivedVariable is based on path: gates[*]/fcond, on: Component(id=k_fast type=ionChannelHH), from gates; Component(id=p type=gateHHtauInf)
    ? multiply applied to all instances of fcond in: <gates> ([Component(id=p type=gateHHtauInf), Component(id=q type=gateHHtauInf)]))
    fopen0 = p_fcond * q_fcond ? path based
    
    fopen = conductanceScale  *  fopen0 ? evaluable
    g = conductance  *  fopen ? evaluable
    gion = gmax * fopen 
    
    ik = gion * (v - ek)
    
}

DERIVATIVE states {
    rates()
    p_q' = rate_p_q 
    q_q' = rate_q_q 
    
}

PROCEDURE rates() {
    
    p_timeCourse_t = p_timeCourse_tau ? evaluable
    p_steadyState_x = p_steadyState_rate  / (1 + exp(0 - (v -  p_steadyState_midpoint )/ p_steadyState_scale )) ? evaluable
    ? DerivedVariable is based on path: q10Settings[*]/q10, on: Component(id=p type=gateHHtauInf), from q10Settings; null
    ? Path not present in component, using factor: 1
    
    p_rateScale = 1 
    
    p_fcond = p_q ^ p_instances ? evaluable
    ? DerivedVariable is based on path: steadyState/x, on: Component(id=p type=gateHHtauInf), from steadyState; Component(id=null type=HHSigmoidVariable)
    p_inf = p_steadyState_x ? path based
    
    ? DerivedVariable is based on path: timeCourse/t, on: Component(id=p type=gateHHtauInf), from timeCourse; Component(id=null type=fixedTimeCourse)
    p_tauUnscaled = p_timeCourse_t ? path based
    
    p_tau = p_tauUnscaled  /  p_rateScale ? evaluable
    q_timeCourse_t = q_timeCourse_tau ? evaluable
    q_steadyState_x = q_steadyState_rate  / (1 + exp(0 - (v -  q_steadyState_midpoint )/ q_steadyState_scale )) ? evaluable
    ? DerivedVariable is based on path: q10Settings[*]/q10, on: Component(id=q type=gateHHtauInf), from q10Settings; null
    ? Path not present in component, using factor: 1
    
    q_rateScale = 1 
    
    q_fcond = q_q ^ q_instances ? evaluable
    ? DerivedVariable is based on path: steadyState/x, on: Component(id=q type=gateHHtauInf), from steadyState; Component(id=null type=HHSigmoidVariable)
    q_inf = q_steadyState_x ? path based
    
    ? DerivedVariable is based on path: timeCourse/t, on: Component(id=q type=gateHHtauInf), from timeCourse; Component(id=null type=fixedTimeCourse)
    q_tauUnscaled = q_timeCourse_t ? path based
    
    q_tau = q_tauUnscaled  /  q_rateScale ? evaluable
    
     
    rate_p_q = ( p_inf  -  p_q ) /  p_tau ? Note units of all quantities used here need to be consistent!
    
     
    
     
    
     
    rate_q_q = ( q_inf  -  q_q ) /  q_tau ? Note units of all quantities used here need to be consistent!
    
     
    
     
    
     
    
}
