#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  3 16:50:00 2016

@author: drsmith
"""
import os, shutil, subprocess
from jinja2 import Environment, FileSystemLoader

context_template = {'jobname':None, # begin SBATCH variables
                    'queue':None,
                    'nodes':None,
                    'exepath':None,
                    'nout':None, # begin BOUT.inp variables
                    'timestep':None,
                    'walltime':None,
                    'gridfile':None, # required
                    'parallel':None,
                    'solver':None,
                    'mz':None,
                    'zperiod':None,
                    'bandpass':None,
                    'zmin_bp':None,
                    'zmax_bp':None,
                    'filter_z':None,
                    'filter_z_mode':None,
                    'low_pass_z':None,
                    'lund':None,
                    'hyperresist':None,
                    'zs_opt':None,
                    'zs_mode':None}
nolabel=['jobname',
         'queue',
         'nodes',
         'exepath',
         'nout',
         'walltime',
         'gridfile']
gridfile_def = os.path.join(os.getenv('BOUT_HOME'),
                            'grids',
                            '138543/varyped',
                            'g138543.00052.nc')

def yes_or_no(question):
    reply = [None]
    while reply[0] not in ['y','n']:
        reply = str(raw_input(question+' (y/n): ')).lower().strip()
    if reply[0] == 'y':
        return True
    elif reply[0] == 'n':
        return False
    else:
        raise ValueError('invalid y/n reply')


def rendertemplate(context, sbatchfilename='sbatch.sh'):
    """
    """
    # ensure gridfile and jobname are defined in context
    if 'gridfile' not in context or \
    not context['gridfile'] or \
    not os.path.exists(context['gridfile']):
        raise KeyError('gridfile must be defined in context '+\
                      'and exist')
    if 'jobname' not in context or not context['jobname']:
        raise KeyError('jobname must be defined in context '+\
                      'and exist')

    loader = FileSystemLoader('/u/drsmith/python')
    env = Environment(loader=loader)

    sbatchtemplate = env.get_template('sbatch.template.sh')
    with open(sbatchfilename, 'w') as sbatchfile:
        sbatchfile.write(sbatchtemplate.render(context))

    bouttemplate = env.get_template('BOUT.template.ini')
    with open('data/BOUT.inp', 'w') as boutfile:
        boutfile.write(bouttemplate.render(context))


def batchlist(gridfile=gridfile_def,
              nosubmit=False,
              **kwargs):
    submitdir = os.getcwd()
    # ensure submitdir is sub-dir of /p/bout/drsmith/runs/
    if os.path.dirname(submitdir) != '/p/bout/drsmith/runs':
        raise ValueError('boutbatch() must be run from '+
                         '/p/bout/drsmith/runs/*/:'+
                         '\n{}'.format(submitdir))
    # ensure submitdir corresponds to gridfile
    if os.path.basename(submitdir)[0:6] not in gridfile:
        raise ValueError('gridfile and submitdir must correspond:'+
                         '\n{}\n{}'.format(gridfile,submitdir))
    # remove jobname kwarg
    if 'jobname' in kwargs:
        kwargs.pop('jobname')
    # check keys
    for key in kwargs.iterkeys():
        # ensure keys are in context_template
        if key not in context_template:
            raise KeyError('kwargs must be valid context keys: {}'.format(key))
        # ensure values are lists
        value = kwargs[key]
        if not isinstance(value, list):
            kwargs[key] = [value]
    # ensure all kwargs are keyword in context_template
    njobs = 0
    jobname_pre = ''
    for key, value in kwargs.iteritems():
        if len(value)==1:
            # single-elements keys
            if key not in nolabel:
                if len(key)<=4:
                    jobname_pre = jobname_pre + \
                        '{}{}_'.format(key,value[0])
                else:
                    jobname_pre = jobname_pre + \
                        '{}{}_'.format(key[0:4],value[0])
        else:
            # multiple-element keys
            if not njobs:
                njobs = len(value)
            else:
                if len(value) != njobs:
                    raise ValueError('kwargs must have same length')
    if not njobs:
        njobs = 1
    # loop over kwargs
    context_pre = context_template
    context_pre['gridfile'] = gridfile
    for i in range(njobs):
        context=context_pre
        jobname = jobname_pre
        for key in kwargs:
            value = kwargs[key]
            if len(value)==1:
                # keys with single values
                context[key] = value[0]
            else:
                # keys with multiple values
                context[key] = value[i]
                if len(key)<=4:
                    jobname = '{}{}_'.format(key,value[i])+\
                               jobname
                else:
                    jobname = '{}{}_'.format(key[0:4],value[i]) +\
                               jobname
        if not jobname:
            raise RuntimeError('Empty jobname')
        jobname = jobname[0:len(jobname)-1]
        print(jobname)
        context['jobname'] = jobname
        # make directory structure and render templates
        if os.path.exists(jobname):
            if yes_or_no('delete dir {}?'.format(jobname)):
                shutil.rmtree(jobname)
            else:
                print('skipping job {}'.format(jobname))
                continue
        os.makedirs(os.path.join(jobname,'data'))
        os.chdir(jobname)
        rendertemplate(context)
        if not nosubmit:
            subprocess.call(['sbatch','sbatch.sh'])
        os.chdir(submitdir)


if __name__=='__main__':
    batchlist(zmax_bp=[4,6,10,12,16,24], solver=['petsc'], queue=['dawson'])
#    batchlist(zmin_bp=2,
#              nout=3000,
#              zs_opt=5,
#              lund=5,
#              hyperresist=-3)
#    batchlist(zmin_bp=[1,2,4,
#                       1,2,4,
#                       1,2,4],
#              zs_mode=[1,1,1,
#                       2,2,2,
#                       4,4,4])
#    batchlist(gridfile=gridfile_def,
#          zmin_bp=[2,4,8,12,
#                   2,2,2,2],
#          zmax_bp=[24,24,24,24,
#                   4,8,12,18])
#    batchlist(zs_opt=5,
#              lund=[6,7,8,9,10],
#              hyperresist=[-2,-2,-2,-2,-2])
#    batchlist(gridfile=gridfile_def,
#          zmin_bp=[1,2,4,
#                   1,2,4,
#                   1,2,4],
#          zmax_bp=[16,16,16,
#                   24,24,24,
#                   32,32,32])
