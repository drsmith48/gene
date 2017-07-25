#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 25 17:31:13 2017

@author: drsmith
"""



def prepare_gene_scan(*args, **kwargs):
    """
    Prepare scan with multiple GENE `problems`.
    
    * Loads a single Geqdsk file using miller.py
    * Prepares scan parameter, and calls eq.miller() as needed
    * Runs newprob in /p/gene/drsmith/genetools
    * Replace launcher.cmd and parameters
    * Submit jobs to cluster
    """
    pass

if __name__ == '__main__':
    prepare_gene_scan(param1=1,
                      param2=2,
                      param3=3)