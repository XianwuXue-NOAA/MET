#! /bin/bash

source ${GITHUB_WORKSPACE}/.github/jobs/bash_functions.sh

DOCKERHUB_TAG=${DOCKERHUB_REPO}:${SOURCE_BRANCH}

LOCAL_OUTPUT_DIR=${RUNNER_WORKSPACE}/output
DOCKER_OUTPUT_DIR=/data/output/met_test_output

LOCAL_DIFF_DIR=${RUNNER_WORKSPACE}/diff
DOCKER_DIFF_DIR=/data/output/met_test_diff

#volumes_from="--volumes-from met_truth --volumes-from met_input"
volumes_from="--volumes-from met_input"

mount_args="-v $LOCAL_OUTPUT_DIR:$DOCKER_OUTPUT_DIR -v $LOCAL_DIFF_DIR:$DOCKER_DIFF_DIR -v ${RUNNER_WORKSPACE}/logs:/met/logs"

export TESTS_TO_RUN=$TESTS

#time_command docker create --name=run_unit ${DOCKERHUB_TAG}

#time_command docker start run_unit
#time_command docker run -d --name run_unit ${volumes_from} ${mount_args} ${DOCKERHUB_TAG}
#if [ $? != 0 ]; then
#  exit 1
#fi

# run unit test script inside Docker, mount MET input and truth data
cmd="\${MET_REPO_DIR}/.github/jobs/run_unit_tests.sh"
time_command docker run -e TESTS_TO_RUN ${volumes_from} ${mount_args} ${DOCKERHUB_TAG} bash -c \"${cmd}\"
#time_command docker exec -e TESTS_TO_RUN run_unit bash -c \"${cmd}\"
if [ $? != 0 ]; then
  exit 1
fi