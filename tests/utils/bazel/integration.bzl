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
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_files")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@score_itf//:defs.bzl", "py_itf_test")
load("@score_lifecycle_pip//:requirements.bzl", "all_requirements")
load("//:defs.bzl", "launch_manager_config")
load("//tests/utils/bazel:constants.bzl", "SCORE_TEST_INSTALL_PREFIX")

def integration_test(name, srcs, test_binaries, args = [], deps = [], data = [], install_prefix = SCORE_TEST_INSTALL_PREFIX, **kwargs):
    """Creates an integration test with test binaries available, also adds all
    the required dependencies.

    Args:
        test_binaries: Label of the `package_test_binaries` target
    """

    merged_data = data + [test_binaries] + select({
        "//config:host": [],
        "//conditions:default": ["//tests/utils/environments:test_environment"],
    })

    # The test container does not ship the sanitizer runtime; daemon fails to start.
    sanitizer_tags = ["no-asan"]
    tags = kwargs.pop("tags", []) + sanitizer_tags

    py_itf_test(
        name = name,
        srcs = srcs,
        tags = tags,
        deps = deps + all_requirements + ["@score_tooling//python_basics/score_pytest:attribute_plugin"],
        data = merged_data,
        args = args + [
            "--score-test-binary-path=$(locations {})".format(test_binaries),
            "--score-test-remote-directory={}/tests/{}".format(install_prefix, name),
        ] + select({
            "//config:x86_64-linux": [
                "--docker-image-bootstrap=$(location //tests/utils/environments:test_environment)",
                "--docker-image=score_itf_examples:latest",
            ],
            "//config:host": [
                "--local-dir=/tmp/score_itf_host/{}".format(name),
            ],
            "//conditions:default": [],
        }),
        plugins = ["//tests/utils/plugins:integration_plugin"] + select({
            "//config:x86_64-linux": ["@score_itf//score/itf/plugins:docker_plugin"],
            "//config:x86_64-qnx": ["@score_itf//score/itf/plugins/qemu"],
            "//config:host": ["//tests/utils/plugins:localhost_plugin"],
            "//conditions:default": [],
        }),
        **kwargs
    )

def lm_integration_test(name, config, srcs, main_files, deps = [], tags = [], **kwargs):
    """Creates a complete LCM integration test.

    Wraps the common boilerplate present in every integration test: generating
    the LM flatbuffer config, packaging binaries and config into a tar archive,
    and creating the integration test target.

    Args:
        name:       Test name, also used to derive all intermediate target names.
        config:     Label of the JSON config file passed to launch_manager_config.
        srcs:       Python test source files.
        main_files: Targets to include as test binaries (mode 0755).
        deps:       Additional Python test dependencies.
        tags:       Additional Bazel tags ("integration" is always included).
    """
    launch_manager_config(
        name = "lm_" + name + "_config",
        config = config,
        flatbuffer_out_dir = "etc",
    )

    pkg_files(
        name = name + "_etc_files",
        srcs = [":lm_" + name + "_config"],
        prefix = "tests/" + name,
    )

    pkg_files(
        name = name + "_main_files",
        srcs = main_files,
        attributes = pkg_attributes(mode = "0755"),
        prefix = "tests/" + name,
    )

    pkg_tar(
        name = name + "_binaries",
        srcs = [
            ":" + name + "_etc_files",
            ":" + name + "_main_files",
        ],
    )

    integration_test(
        name = name,
        srcs = srcs,
        tags = ["integration"] + tags,
        test_binaries = ":" + name + "_binaries",
        deps = ["//tests/utils/testing_utils"] + deps,
        **kwargs
    )
