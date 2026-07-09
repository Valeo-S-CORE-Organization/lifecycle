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

cc_library(
    name = "switch_run_target_common",
    hdrs = ["common.hpp"],
)

cc_binary(
    name = "control_client_mock",
    srcs = ["control_client_mock.cpp"],
    deps = [
        ":switch_run_target_common",
        "//score/launch_manager:control_cc",
        "//score/launch_manager:lifecycle_cc",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

[
    cc_binary(
        name = component,
        srcs = [component + ".cpp"],
        deps = [
            ":switch_run_target_common",
            "//score/launch_manager:lifecycle_cc",
            "//tests/utils/test_helper",
            "@googletest//:gtest_main",
        ],
    )
    for component in [
        "component_a",
        "component_b",
        "component_d",
    ]
]

cc_binary(
    name = "component_e",
    srcs = ["//tests/utils/test_helper:reporting_process.cpp"],
    deps = [
        "//score/launch_manager:lifecycle_cc",
        "//tests/utils/test_helper",
        "@googletest//:gtest_main",
    ],
)

lm_integration_test(
    name = "switch_run_target",
    config = "//tests/integration/switch_run_target:switch_run_target.json",
    srcs = ["switch_run_target.py"],
    main_files = [
        ":component_a",
        ":component_b",
        ":component_d",
        ":component_e",
        ":control_client_mock",
        "//score/launch_manager",
    ],
)
