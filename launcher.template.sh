#!/bin/tcsh
#SBATCH -J {{ jobname|default('GENE', true) }}
#SBATCH -p {{ partition|default('kruskal', true) }}
#SBATCH --time={{ walltime|default('24:0:00', true) }}
#SBATCH --nodes={{ nodes|default('1', true) }}
#SBATCH --ntasks={{ tasks|default('64', true) }}
#SBATCH --mem-per-cpu={{ mempercpu|default('2000', true) }}
#SBATCH --workdir={{ workdir|default('./', true) }}
#SBATCH --mail-type=ALL --mail-user=drsmith@pppl.gov
#SBATCH -o std.out -e std.err

echo "--------------------------------"
echo "--------------------------------"
echo "Cluster: ${SLURM_CLUSTER_NAME}"
echo "Partition: ${SLURM_JOB_PARTITION}"
echo "Submit directory: ${SLURM_SUBMIT_DIR}"
echo " "
echo "Job ID: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo " "
echo "Nodes/tasks/CPUs: ${SLURM_NNODES}/${SLURM_NTASKS}/${SLURM_NPROCS}"
echo "Mem/CPU (MB): ${SLURM_MEM_PER_CPU}"
echo "--------------------------------"
echo "Node list: ${SLURM_NODELIST}"
echo "--------------------------------"
echo " "

set sourcefile="/p/gene/drsmith/gene-pgf.csh"
echo "Sourcing ${sourcefile}"
source ${sourcefile}

set localdir="/local/drsmith-${SLURM_JOB_NAME}-${SLURM_JOB_ID}"
echo "Creating local dir ${localdir}"
mkdir ${localdir}

echo "Creating sym links in local dir"
cp -sL parameters scanscript gene_pppl_pgf ${localdir}

echo "cd to local dir"
cd ${localdir}

echo "Running scanscript"
./scanscript --n_pes={{ tasks|default('64', true) }} --procs_per_node=32

echo "Copy std.out, std.err, scanfiles*/ to ${SLURM_SUBMIT_DIR}"
cp -f std.* scanfiles*/ ${SLURM_SUBMIT_DIR}

echo "Finished"
exit