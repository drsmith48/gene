#!/bin/tcsh
#SBATCH -J {{ jobname|default('GENE', true) }}
#SBATCH -p {{ partition|default('kruskal', true) }}
#SBATCH --time={{ walltime|default('12:0:00', true) }}
#SBATCH --nodes={{ nodes|default('2', true) }}
#SBATCH --ntasks={{ tasks|default('64', true) }}
#SBATCH --mem-per-cpu={{ mempercpu|default('2000', true) }}
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

set genedir="/local/drsmith-${SLURM_JOB_NAME}-${SLURM_JOB_ID}"
mkdir ${genedir}
cd ${genedir}
ln -s ${GENEHOME}/tools tools
ln -s ${GENEHOME}/bin bin
ln -s ${GENEHOME}/makefile makefile
ln -s ${GENEHOME}/makefiles makefiles
ln -s ${GENEHOME}/.git .git
ln -s ${GENEHOME}/src src
ls -al

mkdir probdir
cd probdir

##set localdir="/local/drsmith-${SLURM_JOB_NAME}-${SLURM_JOB_ID}"
##echo "Creating and move to local dir ${localdir}"
##mkdir ${localdir}
##cd ${localdir}
##pwd

echo "Creating sym links in local problem dir"
ln -s ${SLURM_SUBMIT_DIR}/parameters parameters
ln -s ${SLURM_SUBMIT_DIR}/scanscript scanscript
ln -s ${SLURM_SUBMIT_DIR}/gene_pppl_pgf gene_pppl_pgf
ls -l

echo "Running scanscript"
./scanscript --np={{ tasks|default('64', true) }} --ppn=32 --mps=4
###${SLURM_SUBMIT_DIR}/scanscript --np={{ tasks|default('64', true) }} --ppn=32 --mps=4

echo "Copy scanfiles*/ to ${SLURM_SUBMIT_DIR}"
cp -fR scanfiles*/ ${SLURM_SUBMIT_DIR}
ls -l
ls -l ${SLURM_SUBMIT_DIR}

echo "Finished"
exit