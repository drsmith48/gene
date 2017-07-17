#!/bin/tcsh
#SBATCH --job-name={{ jobname|default('bout', true) }}
#SBATCH --output=std.out --error=std.err
#SBATCH --time=2:00:00
#SBATCH --partition={{ queue|default('kruskal', true) }}
#SBATCH --nodes={{ nodes|default('1', true) }}
#SBATCH --ntasks-per-node=32
#SBATCH --mem-per-cpu=2000M
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drsmith@pppl.gov

source ${HOME}/bout.csh

module list

### Executable and arguments
set EXEPATH="{{ exepath|default('${BOUT_HOME}/models/elm_pb/elm_pb_v07', true) }}"
set ARGS=""

env | grep SLURM

echo " "
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
echo "Total nodes: ${SLURM_NNODES}"
echo "Total CPUs: ${SLURM_NPROCS}"
echo "Total tasks: ${SLURM_NTASKS}"
echo " "
echo "Tasks/node: ${SLURM_NTASKS_PER_NODE}"
echo "CPUs/node: ${SLURM_JOB_CPUS_PER_NODE}"
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

# cd to submission directory
echo "cd to submission directory"
cd ${SLURM_SUBMIT_DIR}

# setup local directory and copy files
set localdir="/local/drsmith-${SLURM_JOB_NAME}-${SLURM_JOB_ID}"
echo "The local directory is ${localdir}"
mkdir -p ${localdir}/data
cp sbatch.sh ${localdir}
cp data/BOUT.inp ${localdir}/data
cp data/BOUT.restart* ${localdir}/data

# cd to local dir
echo "cd to local dir"
cd ${localdir}

### Command syntax
echo "The command syntax for this job is:"
echo "mpirun -np ${SLURM_NPROCS} ${EXEPATH} ${ARGS}"
echo " "

### Submit SLURM job
echo -n 'Started job at : ' ; date
mpirun -np ${SLURM_NPROCS} ${EXEPATH} ${ARGS}
echo -n 'Ended job at  : ' ; date
echo " "

# cd to submission directory
echo "cd to submission directory"
cd ${SLURM_SUBMIT_DIR}

# copy output to submit dir
echo "copying output"
cp -f ${localdir}/std.* ./
cp -f ${localdir}/data/BOUT.dmp* ${localdir}/data/BOUT.log* data

# save profile figure
#echo "saving profile figure"
#python ${HOME}/python/gridinspect.py {{ gridfile }}

# save evolution figure
#echo "saving evolution figure"
#python ${HOME}/python/boutinspect.py

echo "Exiting"
echo " "
exit

