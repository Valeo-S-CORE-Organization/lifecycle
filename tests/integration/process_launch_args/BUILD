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
    name = "process_initial",
    srcs = ["process_initial.cpp"],
    deps = [
        "//score/launch_manager:lifecycle_cc",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

lm_integration_test(
    name = "process_launch_args",
    config = "//tests/integration/process_launch_args:process_launch_args.json",
    srcs = ["process_launch_args.py"],
    main_files = [
        ":process_initial",
        "//score/launch_manager",
    ],
)
