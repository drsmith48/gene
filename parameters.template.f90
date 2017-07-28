&parallelization
n_procs_s = 0
n_procs_v = 0
n_procs_w = 0
n_procs_x = 0
n_procs_y = 0
n_procs_z = 0
n_procs_sim = {{ tasks|default('64', true) }}
/

&box
n_spec = 2
nx0 = 16
nky0 = 1
nz0 = 64
nv0 = 32
nw0 = 8

kymin = {{ kymin|default('0.05 !scanrange: 0.05,0.05,0.8', true) }}
lv = 3.00
lw = 9.00
/

&in_out
diagdir = './'
read_checkpoint = .F.
write_checkpoint = .F.
istep_nrg = 10
istep_field = 100
istep_energy = 500
istep_mom = {{ istep_mom|default('0', true) }}
istep_vsp = {{ istep_vsp|default('0', true) }}
/

&general
nonlinear = .F.
comp_type = 'IV'
calc_dt = .T.
ntimesteps = {{ ntimesteps|default('1E5', true) }}
timelim = {{ timelim|default('43E3', true) }}
simtimelim = {{ simtimelim|default('5E2', true) }}
n_ev = 1
omega_prec = {{ omega_prec|default('1.E-3', true) }}
beta = {{ beta|default('1.E-3', true) }}
hyp_z = 0.25
hyp_v = 0.20
init_cond = 'alm'
arakawa_zv_order = 4
hypz_opt = F
perf_tsteps = 20
/

&nonlocal_x
/

&external_contr
/

&geometry
magn_geometry = {{ magn_geometry|default("'s_alpha'", true) }}
trpeps = 0.18
q0 = 1.4
shat = 0.8
major_R = 1.0
norm_flux_projection = F
/

&species
name = 'ions'
mass = 1.0
charge = 1

temp = {{ ion_temp|default('1.', true) }}
omt = {{ ion_omt|default('6.92', true) }}
dens = {{ ion_dens|default('1.0', true) }}
omn = {{ ion_omn|default('2.22', true) }}
/

&species
name = 'electrons'
mass = {{ ele_mass|default('1.E-2', true) }}
charge = -1

temp = {{ ele_temp|default('1.', true) }}
omt = {{ ele_omt|default('6.92', true) }}
dens = {{ ele_dens|default('1.0', true) }}
omn = {{ ele_omn|default('2.22', true) }}
/

&units
Tref = {{ Tref|default('0.0', true) }}
nref = {{ nref|default('0.0', true) }}
Bref = {{ Bref|default('0.0', true) }}
Lref = {{ Lref|default('0.0', true) }}
mref = {{ mref|default('-1', true) }}
/

&scan
/

