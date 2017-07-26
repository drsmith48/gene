#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 25 17:31:13 2017

@author: drsmith
"""

import os
import subprocess as sp
from jinja2 import Environment, FileSystemLoader
import miller

genehome = os.environ['GENEHOME']
initdir = os.path.abspath(os.curdir)

def genesubmit(miller=None, subparam=None, subvalue=None):
    """
    Prepare and submit a single GENE problem.
    """
    # run newprob in GENE home directory
    os.chdir(genehome)
    print('Creating new problem')
    ret = sp.run(['./newprob'], timeout=10)
    probdir = 'prob{:d}'.format(ret.returncode)

    # change to probdir and replace parameters and launcher.cmd
    os.chdir(probdir)
    env = Environment(loader=FileSystemLoader(initdir))

    template = env.get_template('launcher.template.sh')
    os.remove('launcher.cmd')
    with open('launcher.cmd', 'w') as f:
#        f.write(template.render(context))
        f.write('asdf')

    template = env.get_template('parameters.template.f90')
    os.remove('parameters')
    with open('parameters', 'w') as f:
#        f.write(template.render(context))
        f.write('qwerty')
    
    print(os.listdir('.'))
    
    # return to original directory
    os.chdir(initdir)


def genebatch(scanparam=None, scanvalues=None, 
              gfile=None, psinorm=None, rova=None, omt_factor=None):
    """
    Prepare and submit multiple GENE problems.

    * Loads a single Geqdsk file using miller.py
    * Prepares scan parameter, and calls eq.miller() as needed
    * Runs newprob in /p/gene/drsmith/genetools
    * Replace launcher.cmd and parameters
    * Submit jobs to cluster
    """
    
    geqdsk = miller.Geqdsk(gfile=gfile)
    
    if scanparam in ['psinorm','rova','omt_factor']:
        # calc miller for each psinorm/rova/omt_factor value
        if scanparam == 'psinorm':
            args = {'rova':rova, 'omt_factor':omt_factor}
        elif scanparam == 'rova':
            args = {'psinorm':psinorm, 'omt_factor':omt_factor}
        elif scanparam == 'omt_factor':
            args = {'rova':rova, 'psinorm':psinorm}
        else:
            raise ValueError('Invalid scanparam: {}'.format(scanparam))
        for value in scanvalues:
            args[scanparam] = value
            m = geqdsk.miller(**args)
            genesubmit(miller=m)
    elif scanparam:
        # calc miller, and substitute parameter value
        m = geqdsk.miller(psinorm=psinorm, rova=rova, omt_factor=omt_factor)
        for value in scanvalues:
            genesubmit(miller=m, subparam=scanparam, subvalue=value)
    elif scanparam is None and scanvalues is None:
        # calc miller with no scan or substitution
        m = geqdsk.miller(psinorm=psinorm, rova=rova, omt_factor=omt_factor)
        genesubmit(miller=m)
    else:
        raise ValueError('Invalid scanparam or scanvalues:\n{}\n{}'.format(
                scanparam, scanvalues))


if __name__ == '__main__':
    genebatch(scanparam='omt_factor',
              scanvalues=[0.2,0.8])