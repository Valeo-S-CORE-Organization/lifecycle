# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************
load("//tests/utils/bazel:integration.bzl", "lm_integration_test")

cc_binary(
    name = "non_reporting_process",
    srcs = ["non_reporting_process.cpp"],
    deps = [
        "//score/launch_manager:lifecycle_cc",
        "//score/launch_manager/src/daemon/src/osal:ipc_comms",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

lm_integration_test(
    name = "incorrect_config_non_reporting",
    config = ":non_reporting_config.json",
    srcs = ["test_incorrect_config_non_reporting.py"],
    main_files = [
        ":non_reporting_process",
        "//score/launch_manager",
    ],
)
