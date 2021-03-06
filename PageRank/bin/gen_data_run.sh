#!/bin/bash

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
DIR=`cd $bin/../; pwd`
. "${DIR}/../bin/config.sh"
. "${DIR}/bin/config.sh"

echo "========== running ${APP} benchmark =========="


# path check

SIZE=`${DU} -s ${INPUT_HDFS} | awk '{ print $1 }'`

JAR="${DIR}/target/scala-2.10/pagerankapp_2.10-1.0.jar"
CLASS="src.main.scala.pageRankDataGenRun"
OPTION="${INPUT_HDFS} ${OUTPUT_HDFS}  ${numV} ${NUM_OF_PARTITIONS} ${mu} ${sigma} ${MAX_ITERATION} ${TOLERANCE} ${RESET_PROB}"

echo "opt ${OPTION}"


for((i=0;i<${NUM_TRIALS};i++)); do
	
	${RM} -r ${OUTPUT_HDFS}
	purge_data "${MC_LIST}"	
	START_TIME=`timestamp`
START_TS=`get_start_ts`;
	exec ${SPARK_HOME}/bin/spark-submit --class $CLASS --master ${APP_MASTER} ${YARN_OPT} --conf spark.storage.memoryFraction=${memoryFraction} --conf spark.executor.memory=1g $JAR ${OPTION} 2>&1|tee ${BENCH_NUM}/${APP}_run_${START_TS}.dat
res=$?;
	END_TIME=`timestamp`
get_config_fields >> ${BENCH_REPORT}
print_config  ${APP} ${START_TIME} ${END_TIME} ${SIZE} ${START_TS} ${res}>> ${BENCH_REPORT};
done
exit 0


