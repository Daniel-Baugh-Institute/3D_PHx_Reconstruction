function [Glu,Time] = Glucose_Signaling(varargin)
%% This current code has been written by Justin Melunis
%Based on and runs a simulation designed by Aalap Verma


%% Create Input Parser, this is how you can set default values for all of the signaling, and adjust from inputs
p = inputParser;

%% Glucose Features
%vx = (1 + zx * kn)vb, Z = 1 periportal, Z = -1 pericentral
%glucose uptake
addParameter(p,'V_pump',118,@(x) isnumeric(x) && (x > 0))
addParameter(p,'V_glu_diff',244,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_pump',17,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_diff',17,@(x) isnumeric(x) && (x > 0))

%glucokinase Me-lun is
addParameter(p,'V_gk',112,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_gk',-0.429,@(x) isnumeric(x))
addParameter(p,'K_m_g',7.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gkrp',15,@(x) isnumeric(x) && (x > 0))
addParameter(p,'N_free',2,@(x) isnumeric(x) && (x > 0))
addParameter(p,'N_g',1.4,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_g6p',1.4,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp',240,@(x) isnumeric(x) && (x > 0))
addParameter(p,'N_inh',240,@(x) isnumeric(x) && (x > 0))

%g6Pase
addParameter(p,'V_g6pase',370,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_g6pase',0.31,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_g6p',2.41,@(x) isnumeric(x) && (x > 0))

%Glycogen Synthase
addParameter(p,'V_syn',55,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_syn',0.5,@(x) isnumeric(x))
addParameter(p,'K_m_utp',48,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_is',13.33,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_ls',62.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_syn',2.41,@(x) isnumeric(x) && (x > 0))
addParameter(p,'N_syn',4,@(x) isnumeric(x) && (x > 0))

%Glycogen Phosphorylase
addParameter(p,'V_brk',5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gly',100,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_phos',4000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_ip',26.66,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_lp',45,@(x) isnumeric(x) && (x > 0))
addParameter(p,'N_brk',4,@(x) isnumeric(x) && (x > 0))

%Glycolysis 1 (G6P to GADP)
addParameter(p,'V_pfk',160,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_ipfk',2666.7,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_lpfk',1250,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_g6p_g1',5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_g1',42.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'B_atp',1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_alpha_adp',83.6,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_atp',2.1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'B_gadp',0.75,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_gadp',0.75,@(x) isnumeric(x) && (x > 0))

%Glycolysis 2 (GADP -> Pyruvate/Lactate)
addParameter(p,'V_pk',87,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_pk',-0.355,@(x) isnumeric(x))
addParameter(p,'K_ipk',1066.6,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_lpk',500,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gadp',250,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_adp',240,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_acoa',30,@(x) isnumeric(x) && (x > 0))
addParameter(p,'B_allos',0.8,@(x) isnumeric(x) && (x > 0))

%Gluconegenesis 1 (Pyruvate/Lactate -> GADP)
addParameter(p,'V_pepck',35,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_pepck',0.412,@(x) isnumeric(x))
addParameter(p,'K_ipepck',2266.6,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_lpepck',1062.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_lac',500,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_gn1',10,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gtp',64,@(x) isnumeric(x) && (x > 0))

%Gluconegenesis 2 (GADP -> Glucose)
addParameter(p,'V_fbp',68,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_fbp',0.273,@(x) isnumeric(x))
addParameter(p,'K_ifbp',2266.6,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_lfbp',1250,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gadp_gn2',250,@(x) isnumeric(x) && (x > 0))

%Pyruvate Oxidation
addParameter(p,'V_asyn',15,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_coa_inhib',35,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_lac_pdh',540,@(x) isnumeric(x) && (x > 0))
addParameter(p,'ins_ref_asyn',1.33,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_asyn',375,@(x) isnumeric(x) && (x > 0))

%Beta Oxidation
addParameter(p,'V_boxi',3.3,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_boxi',0.23,@(x) isnumeric(x))
addParameter(p,'K_m_fa',5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_boxi',540,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_coa_inhib_boxi',47.8,@(x) isnumeric(x) && (x > 0))
addParameter(p,'B_inh',0.4,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_boxi',666.7,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_boxi',875,@(x) isnumeric(x) && (x > 0))

%Oxidative Phosphorylation / The Citrate Cycle
addParameter(p,'V_atps',520,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_atps',0.2,@(x) isnumeric(x))
addParameter(p,'K_m_acoa',0.4,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_oxyb',28,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_phos_oxi',3830,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_adp_oxi',410,@(x) isnumeric(x) && (x > 0))

%NDKs (UDP -> UTP) (GDP -> GTP)
addParameter(p,'V_ndkg',3000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'V_ndku',30,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_ndk',290,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gdp_ndk',33.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_adp_ndk',24,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gtp_ndk',120,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_udp_ndk',175,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_utp_ndk',21.5,@(x) isnumeric(x) && (x > 0))

%Adenosine Kinase
addParameter(p,'V_ak',100,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_ak',90,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_adp_ak',110,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_amp_ak',80,@(x) isnumeric(x) && (x > 0))

%ATP Consumption
addParameter(p,'V_atpuse',173,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atpuse',250,@(x) isnumeric(x) && (x > 0))

%Phosphate Control
addParameter(p,'V_con',0.1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'reg_p',4.15,@(x) isnumeric(x) && (x > 0))

%Lipogenesis
addParameter(p,'V_igen',5.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_igen',-0.23,@(x) isnumeric(x))
addParameter(p,'K_m_acoa_igen',58,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_fa_inhib',300,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_igen',8000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_igen',875,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_igen',120,@(x) isnumeric(x) && (x > 0))

%Triglyceride Synthesis
addParameter(p,'V_tgsn',10,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gadp_tgsyn',460,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_tgsyn',500,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_tgsyn',1.066,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_fa_tgsyn',10,@(x) isnumeric(x) && (x > 0))

%Lipolysis
addParameter(p,'V_lply',0.085,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_tg',50.715,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_lply',1.067,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_lply',625,@(x) isnumeric(x) && (x > 0))

%Glycerol Kinase
addParameter(p,'V_gconv',5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gly_gk',41,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_atp_gk',15,@(x) isnumeric(x) && (x > 0))

%% Cell Input/output
    check = 'here' %see if these are all supposed to have a spatial component, if so, change above
%Lactate Update
addParameter(p,'V_lact',200,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_lac_up',1.2,@(x) isnumeric(x) && (x > 0))

%FFA Uptake
addParameter(p,'V_ffa_active',0.08,@(x) isnumeric(x) && (x > 0))
addParameter(p,'V_ffa_diff',1.2,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k_ffa',0.2,@(x) isnumeric(x))
addParameter(p,'K_m_active_fa',2,@(x) isnumeric(x))
addParameter(p,'K_m_diff_fa',200,@(x) isnumeric(x))
addParameter(p,'Ins_ref_active_fa',21.333,@(x) isnumeric(x))

%Triglyceride Uptake/Output
addParameter(p,'V_vldl',0.3,@(x) isnumeric(x) && (x > 0))
addParameter(p,'V_tg_diff',0.4,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_vldl',33.81,@(x) isnumeric(x))
addParameter(p,'K_m_diff_tg',1,@(x) isnumeric(x))
addParameter(p,'TG_ref',33.81,@(x) isnumeric(x))

%Glycerol Uptake
addParameter(p,'V_glyct',100,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_glyct',270,@(x) isnumeric(x) && (x > 0))

%% Adipose and Gut
%Adipose de nova synthesis
addParameter(p,'V_dnwat',0.22,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gb',4.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_dnwat',1.87,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_dnwat',250,@(x) isnumeric(x) && (x > 0))

%non-hepatic triglyceride synthesis
addParameter(p,'V_trisyn',8.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gb_trisyn',10,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_ffa_trisyn',645,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Ins_ref_trisyn',800,@(x) isnumeric(x) && (x > 0))
addParameter(p,'Glcgn_ref_trisyn',37.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'T_i_up',1000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'T_i_down',15000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'T_g_up',10000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'T_g_down',700,@(x) isnumeric(x) && (x > 0))

%Adipose Lipolysis
addParameter(p,'V_lipolysis',2,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_tgb',2,@(x) isnumeric(x) && (x > 0))

%Glucose Consumption Systemic
addParameter(p,'V_gbuse',4.93,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_gbuse',1,@(x) isnumeric(x) && (x > 0))

%FA Consumption Systemic
addParameter(p,'V_ffauptake',0.982,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_m_ffauptake',100,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_i_up_ffa',250,@(x) isnumeric(x) && (x > 0))
addParameter(p,'K_l_up_ffa',125,@(x) isnumeric(x) && (x > 0))

%HORMONE RELEASE BY THE PANCREAS
addParameter(p,'G_ref_pan',3/0.0005,@(x) isnumeric(x) && (x >= 0)) %gr/BloodScale
addParameter(p,'N_glgn_pan',2,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'K_m_glgn_pan',1.3,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'T_glgn_pan',0.036 * 5 * 60,@(x) isnumeric(x) && (x >= 0)) %TauL * Ref * Min

addParameter(p,'N_ins_pan',2,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'K_m_ins_pan',0.9,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'T_ins_pan',0.075 * 5 * 60,@(x) isnumeric(x) && (x >= 0)) %TauI * Ref * Min

%Hormone Degradation across the sinusoid
addParameter(p,'d_glgn',0.03858,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'d_ins',0.01389,@(x) isnumeric(x) && (x >= 0))

%% Initial Values and constants
%Oxygen
addParameter(p,'Oxy_max',65,@(x) isnumeric(x) && (x >= 0))
addParameter(p,'Oxy_min',35,@(x) isnumeric(x) && (x >= 0))

%% Parse
parse(p,varargin{:})

%% Initialize Glucose Parameters
S = p.Results.S*n_cell;
bf = p.Results.bf*n_cell;
G_input = p.Results.G_input; 

%% Glucose Rates
%vx = (1 + zx * kn)vb, Z = 1 periportal, Z = -1 pericentral
Z = linspace(1,-1,n_cell)';

% Glucose Uptake Mel-unis
V_pump = p.Results.V_pump;
V_glu_diff = p.Results.V_glu_diff;
K_m_pump = p.Results.K_m_pump;
K_m_diff = p.Results.K_m_diff;

%glucokinase (Glucose -> G6P)
V_gk = (1 + Z * p.Results.k_gk) * p.Results.V_gk;
K_m_g = p.Results.K_m_g;
K_m_gkrp = p.Results.K_m_gkrp;
N_free = p.Results.N_free;
N_g = p.Results.N_g;
K_i_g6p = p.Results.K_i_g6p;
K_m_atp = p.Results.K_m_atp;
N_inh = p.Results.N_inh;

%g6Pase (G6P -> Glucose)
V_g6pase = (1 + Z * p.Results.k_g6pase) * p.Results.V_g6pase;
K_m_g6p = p.Results.K_m_g6p;

%Glycogen Synthase (G6P -> Glycogen)
V_syn = (1 + Z * p.Results.k_syn) * p.Results.V_syn;
K_m_utp = p.Results.K_m_utp;
K_is = p.Results.K_is;
K_ls = p.Results.K_ls;
K_m_syn = p.Results.K_m_syn;
N_syn = p.Results.N_syn;

%Glycogen Phosphorylase
V_brk = p.Results.V_brk;
K_m_gly = p.Results.K_m_gly;
K_m_phos = p.Results.K_m_phos;
K_ip = p.Results.K_ip;
K_lp = p.Results.K_lp;
N_brk = p.Results.N_brk;

%Glycolysis 1 (G6P to GADP) JDM
V_pfk = p.Results.V_pfk;
K_ipfk = p.Results.K_ipfk;
K_lpfk = p.Results.K_lpfk;
K_m_g6p_g1 = p.Results.K_m_g6p_g1;
K_m_atp_g1 = p.Results.K_m_atp_g1;
B_atp = p.Results.B_atp;
K_alpha_adp = p.Results.K_alpha_adp;
K_i_atp = p.Results.K_i_atp;
B_gadp = p.Results.B_gadp;
K_i_gadp = p.Results.K_i_gadp;

%Glycolysis 2 (GADP -> Pyruvate/Lactate)
V_pk = (1 + Z * p.Results.k_pk) * p.Results.V_pk;
K_ipk = p.Results.K_ipk;
K_lpk = p.Results.K_lpk;
K_m_gadp = p.Results.K_m_gadp;
K_m_adp = p.Results.K_m_adp;
K_i_acoa = p.Results.K_i_acoa;
B_allos = p.Results.B_allos;

%Gluconegenesis 1 (Pyruvate/Lactate -> GADP)
V_pepck = (1 + Z * p.Results.k_pepck) * p.Results.V_pepck;
K_ipepck = p.Results.K_ipepck;
K_lpepck = p.Results.K_lpepck;
K_m_lac = p.Results.K_m_lac;
K_m_atp_gn1 = p.Results.K_m_atp_gn1;
K_m_gtp = p.Results.K_m_gtp;

%Gluconegenesis 2 (GADP -> Glucose)
V_fbp = (1 + Z * p.Results.k_fbp)  *p.Results.V_fbp;
K_ifbp = p.Results.K_ifbp;
K_lfbp = p.Results.K_lfbp;
K_m_gadp_gn2 = p.Results.K_m_gadp_gn2;

%Pyruvate Oxidation
V_asyn = p.Results.V_asyn;
K_i_coa_inhib = p.Results.K_i_coa_inhib;
K_m_lac_pdh = p.Results.K_m_lac_pdh;
ins_ref_asyn = p.Results.ins_ref_asyn;
Glcgn_ref_asyn = p.Results.Glcgn_ref_asyn;

%Beta Oxidation
V_boxi = (1 + Z * p.Results.k_boxi)  *p.Results.V_boxi;
K_m_atp_boxi = p.Results.K_m_atp_boxi;
K_i_coa_inhib_boxi = p.Results.K_i_coa_inhib_boxi;
B_inh = p.Results.B_inh;
Ins_ref_boxi = p.Results.Ins_ref_boxi;
Glcgn_ref_boxi = p.Results.Glcgn_ref_boxi;
K_m_fa = p.Results.K_m_fa;

%Oxidative Phosphorylation / The Citrate Cycle
V_atps = (1 + Z .* p.Results.k_atps)  .* p.Results.V_atps;
K_m_acoa = p.Results.K_m_acoa;
K_m_oxyb = p.Results.K_m_oxyb;
K_m_phos_oxi = p.Results.K_m_phos_oxi;
K_m_adp_oxi = p.Results.K_m_adp_oxi;

%NDKs (UDP -> UTP) (GDP -> GTP)
V_ndkg = p.Results.V_ndkg;
V_ndku = p.Results.V_ndku;
K_m_atp_ndk = p.Results.K_m_atp_ndk;
K_m_gdp_ndk = p.Results.K_m_gdp_ndk;
K_m_adp_ndk = p.Results.K_m_adp_ndk;
K_m_gtp_ndk = p.Results.K_m_gtp_ndk;
K_m_udp_ndk = p.Results.K_m_udp_ndk;
K_m_utp_ndk = p.Results.K_m_utp_ndk;

%Adenosine Kinase
V_ak = p.Results.V_ak;
K_m_atp_ak = p.Results.K_m_atp_ak;
K_m_adp_ak = p.Results.K_m_adp_ak;
K_m_amp_ak = p.Results.K_m_amp_ak;

%ATP Consumption
V_atpuse = p.Results.V_atpuse;
K_m_atpuse = p.Results.K_m_atpuse;

%Phosphate Control
V_con = p.Results.V_con;
reg_p = p.Results.reg_p;

%Lipogenesis
V_igen = (1 + Z .* p.Results.k_igen)  .* p.Results.V_igen;
K_m_acoa_igen = p.Results.K_m_acoa_igen;
K_m_fa_inhib = p.Results.K_m_fa_inhib;
Ins_ref_igen = p.Results.Ins_ref_igen;
Glcgn_ref_igen = p.Results.Glcgn_ref_igen;
K_m_atp_igen = p.Results.K_m_atp_igen;

%Triglyceride Synthesis
%Code written by Justin Melunis
V_tgsn = p.Results.V_tgsn;
K_m_gadp_tgsyn = p.Results.K_m_gadp_tgsyn;
Glcgn_ref_tgsyn = p.Results.Glcgn_ref_tgsyn;
Ins_ref_tgsyn = p.Results.Ins_ref_tgsyn;
K_m_fa_tgsyn = p.Results.K_m_fa_tgsyn;

%Lipolysis
V_lply = p.Results.V_lply;
K_m_tg = p.Results.K_m_tg;
Ins_ref_lply = p.Results.Ins_ref_lply;
Glcgn_ref_lply = p.Results.Glcgn_ref_lply;

%Glycerol Kinase
V_gconv = p.Results.V_gconv;
K_m_gly_gk = p.Results.K_m_gly_gk;
K_m_atp_gk = p.Results.K_m_atp_gk;

%% Membrane Transport
%Lactate Uptake
V_lact = p.Results.V_lact;
K_m_lac_up = p.Results.K_m_lac_up;

%FFA Uptake (CHECK CODE TO MAKE SURE BOTH ARE SPATIAL)
V_ffa_active = (1 + Z .* p.Results.k_ffa)  .* p.Results.V_ffa_active;
V_ffa_diff = (1 + Z .* p.Results.k_ffa)  .* p.Results.V_ffa_diff;
K_m_active_fa = p.Results.K_m_active_fa;
K_m_diff_fa = p.Results.K_m_diff_fa;
Ins_ref_active_fa = p.Results.Ins_ref_active_fa;

%Triglyceride Uptake/Output
V_vldl = p.Results.V_vldl;
V_tg_diff = p.Results.V_tg_diff;
K_m_vldl = p.Results.K_m_vldl;
K_m_diff_tg = p.Results.K_m_diff_tg;
TG_ref = p.Results.TG_ref;

%Glycerol Uptake
V_glyct = p.Results.V_glyct;
K_m_glyct = p.Results.K_m_glyct;

%% Adipose and Gut
%Adipose de nova synthesis
V_dnwat = p.Results.V_dnwat;
K_m_gb = p.Results.K_m_gb;
Ins_ref_dnwat = p.Results.Ins_ref_dnwat;
Glcgn_ref_dnwat = p.Results.Glcgn_ref_dnwat;

%non-hepatic triglyceride synthesis
V_trisyn = p.Results.V_trisyn;
K_m_gb_trisyn = p.Results.K_m_gb_trisyn;
K_m_ffa_trisyn = p.Results.K_m_ffa_trisyn;
Ins_ref_trisyn = p.Results.Ins_ref_trisyn;
Glcgn_ref_trisyn = p.Results.Glcgn_ref_trisyn;
T_i_up = p.Results.T_i_up;
T_i_down = p.Results.T_i_down;
T_g_up = p.Results.T_g_up;
T_g_down = p.Results.T_g_down;

%Adipose Lipolysis
V_lipolysis = p.Results.V_lipolysis;
K_m_tgb = p.Results.K_m_tgb;

%Glucose Consumption Systemic
V_gbuse = p.Results.V_gbuse;
K_m_gbuse = p.Results.K_m_gbuse;

%FA Consumption Systemic
V_ffauptake = p.Results.V_ffauptake;
K_m_ffauptake = p.Results.K_m_ffauptake;
K_i_up_ffa = p.Results.K_i_up_ffa;
K_l_up_ffa = p.Results.K_l_up_ffa;

%HORMONE RELEASE BY THE PANCREAS
G_ref_pan = p.Results.G_ref_pan;
N_glgn_pan = p.Results.N_glgn_pan;
K_m_glgn_pan = p.Results.K_m_glgn_pan;
T_glgn_pan = p.Results.T_glgn_pan;

N_ins_pan = p.Results.N_ins_pan;
K_m_ins_pan = p.Results.K_m_ins_pan;
T_ins_pan = p.Results.T_ins_pan;

%Hormone Degradation across the sinusoid
d_glgn = p.Results.d_glgn;
d_ins = p.Results.d_ins;

%% Initial Values and constants
%Oxygen
Oxy_max = p.Results.Oxy_max;
Oxy_min = p.Results.Oxy_min;
OXY = linspace(Oxy_max,Oxy_min,n_cell);

%% Simulate 
Ca = cal;
Time = 0:dt:t_max;

for t = dt:dt:t_max

    %% Glucose rate calculations
    % Glucose Uptake (Glucose_Blood -> Glucose)
    r_glut = (V_pump* GB)./(K_m_pump + GB) + V_glu_diff.*(GB - GC)./(K_m_diff + GB + GC);
    
    %% Cell Internel
    %Glucokinase (Glucose -> G6P)
    g1 = V_gk.*(GC^N_free)./((K_m_gkrp^N_free)+(GC^N_free));
    g2 = (GC^N_g)./((K_m_g^N_g)+(GC^N_g));
    g3 = ATP./(K_m_atp + ATP);
    g4 = 1 - ((G6P^N_inh)./((K_i_g6p^N_inh)+(G6P^N_inh)));
    r_gk = g1.*g2.*g3.*g4;
    
    %G6Pase (G6P -> Glucose)
    r_g6pase = V_g6pase*G6P./(K_m_g6p + G6P);
    
    %Glycogen Synthase (G6P -> Glycogen)
    K_syn_max = (INS + K_is)./(GLGN + K_ls);
    r_gs = (V_syn * K_syn_max * (G6P^N_syn))./((G6P^N_syn)+(K_m_syn^N_syn)) * (UTP./(K_m_utp + UTP));

    %Glycogen Phosphorylase (Glycogen -> G6P)
    K_phos_max = (GLGN + K_lp)./(INS + K_ip);
    r_gp = (V_brk * K_phos_max .* (GLY^N_brk)) ./ ((GLY^N_brk) + (K_m_gly ^ N_brk))  *  (PHOS/(PHOS + K_m_phos));
    
    %Glycolysis 1 (G6P to GADP) Phosphofructokinase
    K_pfk_max = (INS + K_ipfk)./(GLGN + K_lpfk);
    g1 = (V_pfk * K_pfk_max .* G6P) ./ (K_m_g6p_g1 + G6P);
    g2 = ATP ./ (K_m_atp_g1 + ATP);
    g3 = ADP ./ (K_alpha_adp + ADP);
    g4 = 1 - (B_atp*ATP./(K_i_atp + ATP));
    g5 = 1 - (B_gadp*GADP./(K_i_gadp + GADP));
    r_pfk = g1.*g2.*g3.*g4.*g5;
    
    %Glycolysis 2 (GADP -> Pyruvate/Lactate) Pyruvate Kinase
    K_pk_max = (INS + K_ipk) ./ (GLGN + K_lpk);
    g1 = (V_pk .* K_pk_max .* GADP) ./ (K_m_gadp + GADP);
    g2 = ADP ./ (K_m_adp + ADP);
    g3 = 1 - (B_allos * ACOA ./ (K_i_acoa + ACOA));
    r_pk = g1.* g2 .* g3;
    
    %Gluconegenesis 1 (Pyruvate/Lactate -> GADP) PEPCK
    K_pepck_max = (GLGN + K_lpepck) ./ (INS + K_ipepck);
    g1 = (V_pepck .* K_pepck_max .* LAC) ./ (K_m_lac + LAC);
    g2 = ATP ./ (K_m_atp_gn1 + ATP);
    g3 = GTP ./ (K_m_gtp + GTP);
    r_pepck = g1.*g2.*g3;

    %Gluconegenesis 2 (GADP -> Glucose) Fructose Biphosphate 
    K_fbp_max = (GLGN + K_lfbp) ./ (INS + K_ifbp);
    r_fbp = (V_fbp .* K_fbp_max .* GADP)/(K_m_gadp_gn2 + GADP);

    %Pyruvate Oxidation (Pyruvate/Lactate -> Acetyl-Coa) aCoa Synthesis
    K_pdh_max = (1 + (INS ./ ins_ref_asyn) - (GLGN ./ Glcgn_ref_asyn));
    g1 = (V_asyn .* K_pdh_max .* LAC)./(K_m_lac_pdh + LAC);
    g2 = 1 - (ACOA ./(ACOA + K_i_coa_inhib));
    r_pdh = g1 .* g2;
    
    %Beta Oxidation
    K_boxi_max = (1 - (INS ./ (Ins_ref_boxi)) + (GLGN ./ Glcgn_ref_boxi));
    g1 = (V_boxi .* K_boxi_max .* FA) ./ (K_m_fa + FA);
    g2 = ATP ./ (ATP + K_m_atp_boxi);
    g3 = 1 - (B_inh .* ACOA ./ (ACOA + K_i_coa_inhib_boxi));
    r_boxi = g1 .* g2 .* g3;

    %Oxidative Phosphorylation / The Citrate Cycle, ATP Synthesis
    g1 = (V_atps .* ACOA) ./ (K_m_acoa + ACOA);
    g2 = OXY ./ (OXY + K_m_oxyb);
    g3 = PHOS ./ (PHOS + K_m_phos_oxi);
    g4 = ADP ./ (ADP + K_m_adp_oxi);
    r_atps = g1 .* g2 .* g3 .* g4;

    %NDKs(NDKG NDKU) (UDP -> UTP) (GDP -> GTP)
    g1 = (ATP*GDP) ./ ((K_m_atp_ndk + ATP).*(K_m_gdp_ndk + GDP));
    g2 = (ADP*GTP) ./ ((K_m_adp_ndk + ADP).*(K_m_gtp_ndk + GTP));
    r_ndkg = V_ndkg .* (g1 - g2);
    
    g1 = (ATP*UDP) ./ ((K_m_atp_ndk + ATP).*(K_m_udp_ndk + UDP));
    g2 = (ADP*UTP) ./ ((K_m_adp_ndk + ADP).*(K_m_utp_ndk + uTP));
    r_ndku = V_ndku .* (g1 - g2);
   
    %Adenosine Kinase
    g1 = (ATP*AMP) ./ ((K_m_atp_ak + ATP).*(K_m_amp_ak + AMP));
    g2 = (ADP.^2) ./ ((K_m_adp_ak.^2) + (ADP^2));
    r_ak = V_ak * (g1 - g2);
    
    %Cellular ATP Consumption
    r_atpu = (V_atpuse .* ATP) ./ (K_m_atpuse + ATP);
    
    %Inorganic phosphare regulation 
    r_preg = V_con .* (PHOS - reg_p);
    
    %Lipogenesis
    K_igen_max = (1 + (INS./Ins_ref_igen) - (GLGN ./ Glcgn_ref_igen));
    g1 = (V_igen .* K_igen_max .* ACOA) ./ (K_m_acoa_igen + ACOA);
    g2 = ATP ./ (K_m_atp_igen + ATP);
    g3 = 1 - (FA ./ (FA + K_m_fa_inhib));
    r_lgen = g1 .* g2 .* g3;
    
    %Triglyceride synthesis
    K_tsyn_max = 1 + (INS ./ Ins_ref_tgsyn) - (GLGN ./ Glcgn_ref_tgsyn);
    g1 = (V_tgsn .* K_tsyn_max .* FA) ./ (K_m_fa_tgsyn + FA);
    g2 = (GADP ./ K_m_gadp_tgsyn + GADP);
    r_tsyn = g1 .* g2;
    
    %Lipolysis
    K_max_lply = 1 - (INS ./ Ins_ref_lply) + (GLGN ./ Glcgn_ref_lply);  
    r_lply = (V_lply .* K_max_lply .* TG) ./ (K_m_tg + TG);
    
    %Glycerol Kinase
    r_gconv = ((V_gconv .* GLY) ./ (K_m_gly_gk + GLY)) .* (ATP ./ (K_m_atp_gk + ATP));
    
    %% Cell Input/output
    check = 'here' %see if these are all supposed to have a spatial component, if so, change above
    %Lactate output/uptake
    r_lact = (V_lact * (LAC_B - LAC)) ./ (K_m_lac_up + LAC_B + LAC);
    
    %FFA Uptake
    g1 = (V_ffa_active * FA_B) ./ (K_m_active_fa + FA_B);
    g2 = 1 + (INS./Ins_ref_active_fa); %Check to see if this is INS or INS_B
    check = 'here';
    g3 = (V_ffa_diff * (FA_B - FA)) ./ (K_m_diff_fa + FA_B + FA);
    r_ffat = (g1 .* g2) + g3;
    
    %Triglyceride Uptake/Output
    g1 = V_vldl *TG ./ (K_m_vldl); 
    g2 = (V_tg_diff .* (TG_B - (TG./TG_ref))) ./ (K_m_diff_tg + TG_B + (TG./RG_ref));
    r_tgt = g2 - g1;
    %Glycerol Uptake
    r_glyt = (V_glyct * (GLY_B - GLY)) ./ (K_m_glyct + GLY_B + GLY);

    %% Adipose and Gut
    %Adipose de nova synthesis
    g1 = (V_dnwat * GS) ./ (K_m_gb + GS);
    g2 = 1 + (INS_S ./ Ins_ref_dnwat) + (GLGN_S ./ Glcgn_ref_dnwat);
    r_ada_dnwat = g1 * g2;

    %Non-hepatic Triglyceride Synthesis
    if (GLGN_S / Glcgn_ref_trisyn) > VG
        r_vg = ((GLGN_S / Glcgn_ref_trisyn) - VG) / T_g_up;
    else
        r_vg = ((GLGN_S / Glcgn_ref_trisyn) - VG) / T_g_down;
    end
    
    if (INS_S / Ins_ref_trisyn) > VI
        r_vi = ((INS_S / Ins_ref_trisyn) - VI) / T_i_up;
    else
        r_vi = ((INS_S / Ins_ref_trisyn) - VI) / T_i_down;
    end

    V_trisynH = V_trisyn * (1 + VI - VG);
    r_trisyn = ((V_trisynH * GS) /(K_m_gb_trisyn + GS)) * (FA_S / (K_m_ffa_trisyn + FA_S));

    %Adipose Lipolysis
    r_ada_lipoly = V_lipolysis * TG_S / (K_m_tgb + TG_S);

    %Glucose Consumption Systemic
    r_gbuse = (V_gbuse * GS) / (K_m_gbuse + GS);

    %FA Consumption Systemic
    r_ffauptake = ((V_ffauptake * FA_S) / (K_m_ffauptake + FA_S) ) * ((INS_S + K_i_up_ffa) / (GLGN_S + K_l_up_ffa));

    %HORMONE RELEASE BY THE PANCREAS
    g1 = ln(G_ref_pan ./ GS);
    if GS < G_ref_pan
        d_glu_pan = (1./T_glgn_pan) * (g1.^N_glgn_pan) ./ ((K_m_glgn_pan ^ N_glgn_pan) + (g1 .^ N_glgn_pan));
        d_ins_pan = 0;
    else
        d_glu_pan = 0;
        d_ins_pan = (1./T_ins_pan) * (g1.^N_ins_pan) ./ ((K_m_ins_pan ^ N_ins_pan) + (g1 .^ N_ins_pan));
    end

    %Hormone Degradation across the sinusoid
    r_d_glgn = d_glgn*GLGN_B;
    r_d_ins = d_ins*INS_B;

%% Systemic Blood
    %Glucose Consumption
    
    r_g_cons = 1;
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Internal Cellular Changes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Glucose
    dGC = -r_gk + r_g6pase + r_glut;
    %G6P
    dG6P = r_gk - r_g6pase + r_gp - r_gs + r_fbp - r_pfk;
    %Glycogen
    dGLGN = r_gs - r_gp;
    %GADP
    dGADP = r_pepck - (2 .* r_fbp) + (2 .* r_pfk) - r_pk + r_gconv - r_tsyn;
    %LAC
    dLAC = r_lact - r_pepck + r_pk - r_pdh;
    %ACOA
    dACOA = r_pdh - (8 .* r_lgen) + (8 .* r_boxi) - r_atps;
    %FA
    dFA = r_ffat + (3 .* r_lply) - (3 .* r_tsyn) + r_lgen - r_boxi;
    %TG
    dTG = r_tgt + r_tsyn - r_lply;
    %Glycerol
    dGLY = r_glyt - r_gconv + r_lply;
    %ATP
    dATP = (12 .* r_atps) - r_ak - (2 .* r_pepck) - r_pfk + (3.25 .* r_pk) -...
        r_gk - r_ndkg - r_ndku - r_atpu - (2 .* r_boxi) - (7 .* r_lgen) -...
        r_gconv + (2.5 .* r_pdh) - (3 .* r_tsyn);
    %ADP
    dADP = -(12 .* r_atps) + (2 .* r_ak) + (2 .* r_pepck) + r_pfk - (3.25 .* r_pk) +...
        r_gk + r_ndkg + r_ndku + r_atpu + (7 .* r_lgen) + r_gconv - (2.5 .* r_pdh);
    %AMP
    dAMP = -r_ak + r_boxi + (3 .* r_tsyn);
    %PHOS
    dPHOS = -(12 .* r_atps) - r_gp + r_g6pase + (2 .* r_gs) - (2.25 .* r_pk) +(2 .* r_pepck) + ...
        r_fbp - r_preg + r_atpu + (7 .* r_lgen) + r_boxi - (2.5 .* r_pdh) + (7 .* r_tsyn);
    %UTP
    dUTP = r_ndku - r_gs;
    %UDP
    dUDP = -r_ndku + r_gs;
    %GTP
    dGTP = r_ndkg - r_pepck;
    %GDP
    dGDP = -r_ndkg + r_pepck;
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Blood/Cell Transfer
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Loss due to going forward
    for i = 1:n_cell
        %Glucose
        dGB(i) = - bf * GB(i);
        %Lactate
        %FA
        %TG
        %GLY
    end
    
    %% Gain from previous section
    for i = 1:n_cell-1
        %Glucose
        dGB(i+1) = dGB(i+1) + bf * GB(i);
    end
    
    %% First cell gain from systemic blood
    dGB(1) = dGB + bf * GS;
    
    %% Add sinusoid transfer to cells (NEED TO ADD CELL/SINU RATIO)
    dGB = dGB - r_glut; %add glucose transfer in blood to and from the cells
    
    %% systemic blood changes
    dGS = bf * (GB(n_cell) - GS)/S; %Systemic change due to blood flow
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Apply Values Changes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Change Internal Levels
    %Glucose
    GC = GC + dGC * dt; 
    %G6P
    G6P = G6P + dG6P * dt;
    %Glycogen
    GLGN = GLGN + dGLGN * dt;
    %GADP
    GADP = GADP + dGADP * dt;
    %LAC
    LAC = LAC + dLAC * dt;
    %ACOA
    ACOA = ACOA + dACOA * dt;
    %FA
    FA = FA + dFA * dt;
    %TG
    TG = TG + dTG * dt;
    %Glycerol
    GLY = GLY + dGLY * dt;
    %ATP
    ATP = ATP + dATP * dt;
    %ADP
    ADP = ADP + dADP * dt;
    %AMP
    AMP = AMP + dAMP * dt;
    %PHOS
    PHOS = PHOS + dPHOS * dt;
    %UTP
    UTP = UTP + dUTP * dt;
    %UDP
    UDP = UDP + dUDP * dt;
    %GTP
    GTP = GTP + dGTP * dt;
    %GDP
    GDP = GDP + dGDP * dt;
    %% Change Blood Levels
    %Glucose
    GB = GB + dGB * dt;
    
    %% Change Systemic Blood Levels
    %Glucose
    GS = GS + (G_input * sin(2*pi*t/28800)^6 - r_g_cons + dGS) *dt; %Fix input to be an input capable function
    %G6P
    
end

