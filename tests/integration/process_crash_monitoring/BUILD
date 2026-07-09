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
    name = "control_client_mock",
    srcs = ["control_client_mock.cpp"],
    deps = [
        "//score/launch_manager:control_cc",
        "//score/launch_manager:lifecycle_cc",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

cc_binary(
    name = "process_crashing_on_runtime",
    srcs = ["process_crashing_on_runtime.cpp"],
    deps = [
        "//score/launch_manager:lifecycle_cc",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

lm_integration_test(
    name = "process_crash_monitoring",
    config = "//tests/integration/process_crash_monitoring:process_crash_monitoring.json",
    srcs = ["process_crash_monitoring.py"],
    main_files = [
        ":control_client_mock",
        ":process_crashing_on_runtime",
        "//score/launch_manager",
        "//tests/utils/test_helper:verification_process",
    ],
)
