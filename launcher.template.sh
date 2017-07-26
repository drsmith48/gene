#!/bin/tcsh
### PROCSPERNODE 32
### MAXWT 8
### SUBMITCMD sbatch
#SBATCH -J GENE
#SBATCH -o std.out -e std.err
#SBATCH -t 24:0:00
#SBATCH -p kruskal
####SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem-per-cpu=2000
#SBATCH --mail-type=ALL --mail-user=drsmith@pppl.gov

source /p/gene/drsmith/gene-pgf.csh

echo "--------------------------------"
echo "--------------------------------"
echo "Cluster name: ${SLURM_CLUSTER_NAME}"
echo "Partition/queue name: ${SLURM_JOB_PARTITION}"
echo "Submit host: ${SLURM_SUBMIT_HOST}"
echo "Submit directory: ${SLURM_SUBMIT_DIR}"
echo " "
echo "Job ID: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo " "
echo "Total CPUs: ${SLURM_NPROCS}"
echo "Total tasks: ${SLURM_NTASKS}"
echo " "
if (${?SLURM_MEM_PER_NODE}) then
	echo "Mem/node (MB): ${SLURM_MEM_PER_NODE}"
endif
if (${?SLURM_MEM_PER_CPU}) then
	echo "Mem/CPU (MB): ${SLURM_MEM_PER_CPU}"
endif
echo "--------------------------------"
echo "--------------------------------"
echo "Node list: ${SLURM_NODELIST}"
echo "--------------------------------"
echo "--------------------------------"
echo " "

#mpiexec -n ${SLURM_NTASKS} ./gene_pppl_pgf

### to submit a parameter scan, comment the previous line and uncomment
### the following (see GENE documentation or ./scanscript --help)
./scanscript --n_pes=32 --procs_per_node=32
