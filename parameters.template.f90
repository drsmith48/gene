&parallelization
n_procs_s = 0
n_procs_v = 0
n_procs_w = 0
n_procs_x = 0
n_procs_y = 0
n_procs_z = 0
n_procs_sim = {{ ntasks|default('64', true) }}
/

&box
n_spec = 2
nx0 = 16
nky0 = 1
nz0 = 64
nv0 = 32
nw0 = 8

kymin = 0.05 !scanrange: 0.05,0.05,0.8
lv = 3.00
lw = 9.00
/

&in_out
diagdir = './scanfiles0000'
read_checkpoint = .F.
write_checkpoint = .F.
istep_nrg = 10
istep_field = 100
istep_mom = 100
istep_energy = 500
istep_vsp = 500
istep_schpt = 5000
/

&general
nonlinear = .F.
comp_type = 'IV'
calc_dt = .T.
ntimesteps = 100000
timelim = 86000
n_ev = 1
omega_prec = 1.0E-03
beta = 1.9285e-01
hyp_z = 0.25
hyp_v = 0.20
init_cond = 'alm'
perf_vec = 2 2 1 1 1 2 1 1 2
nblocks = 4
arakawa_zv_order = 4
hypz_opt = F
perf_tsteps = 20
/

&nonlocal_x
/

&external_contr
/

&geometry
magn_geometry = 'miller'
amhd = 72.759
trpeps = 0.69661
q0 = 4.1814
shat = 2.2577
kappa = 2.6914
s_kappa = -0.3435
delta = 0.49007
s_delta = -7.5236e-05
zeta = 0.10685
s_zeta = 0.13338
drR = -0.55304
minor_r = 1
dpdx_term = 'full_drift'
dpdx_pm = -2
/

&species
name = 'ions'
mass = 1.0
charge = 1

temp = 1.0
omt = 0.0
dens = 1.0
omn = 16.9
/

&species
name = 'electrons'
mass = 1.E-2
charge = -1

temp = 1.0
omt = 0.0
dens = 1.0
omn = 16.9
/

&units
Tref = 0.1
nref = 0.366
Bref = 0.027644
Lref = 0.2608
mref = 2
/

&scan
scan_dims = 16
par_in_dir = './scanfiles0000/in_par'
/

