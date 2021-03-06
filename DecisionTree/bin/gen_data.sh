#!/bin/bash

# configure
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
DIR=`cd $bin/../; pwd`
. "${DIR}/../bin/config.sh"
. "${DIR}/bin/config.sh"

echo "========== preparing ${APP} data =========="

# paths check
${RM} -r ${INPUT_HDFS}


# "Usage: SVMGenerator <master> <output_dir> [num_examples] [num_features] [num_partitions]"


JAR="${DIR}/../SVM/target/SVMApp-1.0.jar"
CLASS="SVM.src.main.scala.SVMDataGen"
#JAR="${MllibJar}"
#CLASS="org.apache.spark.mllib.util.SVMDataGenerator"
OPTION=" ${SPARK_MASTER} ${INOUT_SCHEME}${INPUT_HDFS} ${NUM_OF_EXAMPLES} ${NUM_OF_FEATURES}  ${NUM_OF_PARTITIONS} "

START_TS=`get_start_ts`;
setup
START_TIME=`timestamp`
exec ${SPARK_HOME}/bin/spark-submit --class $CLASS --master ${APP_MASTER} ${YARN_OPT} ${SPARK_OPT} $JAR ${OPTION} 2>&1|tee ${BENCH_NUM}/DecisionTree_gendata_${START_TS}.dat
res=$?;
END_TIME=`timestamp`

SIZE=`${DU} -s ${INPUT_HDFS} | awk '{ print $1 }'`
get_config_fields >> ${BENCH_REPORT}
print_config  ${APP}-gen ${START_TIME} ${END_TIME} ${SIZE} ${START_TS} ${res}>> ${BENCH_REPORT};
teardown
exit 0


