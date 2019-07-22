#!/bin/bash

set -x

PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../.. && pwd )"

okd_base_hash="sha256:259e776998da3a503a30fdf935b29102443b24ca4ea095c9478c37e994e242bb"
gocli_image_hash="sha256:1e21a7b0fc959ae2a47d1d6462ceb74f9e9181d52f9bc618e61bcab80bedaa9e"

gocli="docker run \
--privileged \
--net=host \
--rm -t \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${PARENT_DIR}:${PARENT_DIR} \
docker.io/kubevirtci/gocli@${gocli_image_hash}"

# Custom release image contains libvirt provider PR's
# https://github.com/openshift/cluster-api-provider-libvirt/pull/155
# https://github.com/openshift/cluster-api-provider-libvirt/pull/156
# https://github.com/openshift/cluster-api-provider-libvirt/pull/157
${gocli} provision okd \
--prefix okd-4.1.2 \
--dir-scripts ${PARENT_DIR}/okd/scripts \
--dir-manifests ${PARENT_DIR}/manifests \
--dir-hacks ${PARENT_DIR}/okd/hacks \
--master-memory 10240 \
--installer-pull-token-file ${INSTALLER_PULL_SECRET} \
--installer-repo-tag release-4.1 \
--installer-release-image docker.io/alukiano/ocp-release:4.1.2 \
"kubevirtci/okd-base@${okd_base_hash}"