// RUN: tf-opt %s -tf-replicated-clustering-bridge-v2 -tfrt-lower-cluster-to-runtime-ops-tpu -tf-dialect-to-executor-v2 --mlir-print-ir-before-all --mlir-print-ir-after-all | FileCheck %s

// CHECK-LABEL: func.func @main
// CHECK: %outputs, %control = tf_executor.island wraps "tf.ReadVariableOp"(%arg3) : (tensor<*x!tf_type.resource<tensor<128x1024xf32>>>) -> tensor<128x1024xf32>
// CHECK: %outputs_0, %control_1 = tf_executor.island wraps "tf.ReadVariableOp"(%arg4) : (tensor<*x!tf_type.resource<tensor<1024xf32>>>) -> tensor<1024xf32>
// CHECK: %outputs_2, %control_3 = tf_executor.island wraps "tf.Const"() <{value = dense<0.000000e+00> : tensor<f32>}> {ici_weight_distribution_mlir_bridge_marker = true} : () -> tensor<f32>
// CHECK: %outputs_4, %control_5 = tf_executor.island wraps "tf.Const"() <{value = dense<[128, 1024]> : tensor<2xi64>}> {ici_weight_distribution_mlir_bridge_marker = true} : () -> tensor<2xi64>
// CHECK: %outputs_6, %control_7 = tf_executor.island wraps "tf.Fill"(%outputs_4, %outputs_2) {ici_weight_distribution_mlir_bridge_marker = true} : (tensor<2xi64>, tensor<f32>) -> tensor<128x1024xf32>
// CHECK: %outputs_8, %control_9 = tf_executor.island wraps "tf.Const"() <{value = dense<0.000000e+00> : tensor<f32>}> {ici_weight_distribution_mlir_bridge_marker = true} : () -> tensor<f32>
// CHECK: %outputs_10, %control_11 = tf_executor.island wraps "tf.Const"() <{value = dense<1024> : tensor<1xi64>}> {ici_weight_distribution_mlir_bridge_marker = true} : () -> tensor<1xi64>
// CHECK: %outputs_12, %control_13 = tf_executor.island wraps "tf.Fill"(%outputs_10, %outputs_8) {ici_weight_distribution_mlir_bridge_marker = true} : (tensor<1xi64>, tensor<f32>) -> tensor<1024xf32>
// CHECK: %outputs_14:5, %control_15 = tf_executor.island wraps "tf._TPUCompileMlir"()
// CHECK: %outputs_16, %control_17 = tf_executor.island wraps "tf.Identity"(%outputs_14#0) {device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"} : (tensor<!tf_type.string>) -> tensor<!tf_type.string>
// CHECK: %control_18 = tf_executor.island wraps "tf.TPUCompileSucceededAssert"(%outputs_16) {device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"} : (tensor<!tf_type.string>) -> ()
// CHECK: %outputs_19, %control_20 = tf_executor.island wraps "tf.Const"() <{value = dense<0> : tensor<i32>}> {ici_weight_distribution_mlir_bridge_marker = true} : () -> tensor<i32>
// CHECK: %outputs_21, %control_22 = tf_executor.island wraps "tf.Identity"(%outputs) {_parallel_execution_ids = "r0:0", device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0", ici_weight_distribution_mlir_bridge_marker = true} : (tensor<128x1024xf32>) -> tensor<128x1024xf32>
// CHECK: %outputs_23, %control_24 = tf_executor.island wraps "tf.Identity"(%outputs_0) {_parallel_execution_ids = "r0:0", device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0", ici_weight_distribution_mlir_bridge_marker = true} : (tensor<1024xf32>) -> tensor<1024xf32>
// CHECK: %outputs_25:4, %control_26 = tf_executor.island wraps "tf.Split"(%outputs_19, %outputs_21) {_parallel_execution_ids = "r0:0", ici_weight_distribution_mlir_bridge_marker = true, num_split = 4 : i32} : (tensor<i32>, tensor<128x1024xf32>) -> (tensor<32x1024xf32>, tensor<32x1024xf32>, tensor<32x1024xf32>, tensor<32x1024xf32>)
// CHECK: %outputs_27, %control_28 = tf_executor.island wraps "tf.TPUExecute"(%outputs_25#0, %outputs_23, %outputs_14#1) {_parallel_execution_ids = "r0:0,p0:0", device = "/job:tpu_host_worker/replica:0/task:0/device:TPU:0"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_29, %control_30 = tf_executor.island wraps "tf.TPUExecute"(%outputs_25#1, %outputs_23, %outputs_14#2) {_parallel_execution_ids = "r0:0,p0:1", device = "/job:tpu_host_worker/replica:0/task:0/device:TPU:1"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_31, %control_32 = tf_executor.island wraps "tf.TPUExecute"(%outputs_25#2, %outputs_23, %outputs_14#3) {_parallel_execution_ids = "r0:0,p0:2", device = "/job:tpu_host_worker/replica:0/task:1/device:TPU:0"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_33, %control_34 = tf_executor.island wraps "tf.TPUExecute"(%outputs_25#3, %outputs_23, %outputs_14#4) {_parallel_execution_ids = "r0:0,p0:3", device = "/job:tpu_host_worker/replica:0/task:1/device:TPU:1"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_35, %control_36 = tf_executor.island wraps "tf.Identity"(%outputs_6) {_parallel_execution_ids = "r0:1", device = "/job:tpu_host_worker/replica:0/task:2/device:CPU:0", ici_weight_distribution_mlir_bridge_marker = true} : (tensor<128x1024xf32>) -> tensor<128x1024xf32>
// CHECK: %outputs_37, %control_38 = tf_executor.island wraps "tf.Identity"(%outputs_12) {_parallel_execution_ids = "r0:1", device = "/job:tpu_host_worker/replica:0/task:2/device:CPU:0", ici_weight_distribution_mlir_bridge_marker = true} : (tensor<1024xf32>) -> tensor<1024xf32>
// CHECK: %outputs_39:4, %control_40 = tf_executor.island wraps "tf.Split"(%outputs_19, %outputs_35) {_parallel_execution_ids = "r0:1", ici_weight_distribution_mlir_bridge_marker = true, num_split = 4 : i32} : (tensor<i32>, tensor<128x1024xf32>) -> (tensor<32x1024xf32>, tensor<32x1024xf32>, tensor<32x1024xf32>, tensor<32x1024xf32>)
// CHECK: %outputs_41, %control_42 = tf_executor.island wraps "tf.TPUExecute"(%outputs_39#0, %outputs_37, %outputs_14#1) {_parallel_execution_ids = "r0:1,p0:0", device = "/job:tpu_host_worker/replica:0/task:2/device:TPU:0"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_43, %control_44 = tf_executor.island wraps "tf.TPUExecute"(%outputs_39#1, %outputs_37, %outputs_14#2) {_parallel_execution_ids = "r0:1,p0:1", device = "/job:tpu_host_worker/replica:0/task:2/device:TPU:1"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_45, %control_46 = tf_executor.island wraps "tf.TPUExecute"(%outputs_39#2, %outputs_37, %outputs_14#3) {_parallel_execution_ids = "r0:1,p0:2", device = "/job:tpu_host_worker/replica:0/task:3/device:TPU:0"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_47, %control_48 = tf_executor.island wraps "tf.TPUExecute"(%outputs_39#3, %outputs_37, %outputs_14#4) {_parallel_execution_ids = "r0:1,p0:3", device = "/job:tpu_host_worker/replica:0/task:3/device:TPU:1"} : (tensor<32x1024xf32>, tensor<1024xf32>, tensor<3x!tf_type.string>) -> tensor<*xf32>
// CHECK: %outputs_49, %control_50 = tf_executor.island wraps "tf.ReadVariableOp"(%arg2) {device = ""} : (tensor<*x!tf_type.resource<tensor<i64>>>) -> tensor<i64>
// CHECK: %outputs_51, %control_52 = tf_executor.island wraps "tf.Identity"(%outputs_49) {device = ""} : (tensor<i64>) -> tensor<i64>
// CHECK: tf_executor.fetch %outputs_51, %control, %control_1, %control_28, %control_30, %control_32, %control_34, %control_42, %control_44, %control_46, %control_48, %control_50 : tensor<i64>, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control, !tf_executor.control

module attributes {tf.devices = {"/job:tpu_host_worker/replica:0/task:0/device:CPU:0", "/job:tpu_host_worker/replica:0/task:0/device:TPU:0", "/job:tpu_host_worker/replica:0/task:0/device:TPU:1", "/job:tpu_host_worker/replica:0/task:0/device:TPU_SYSTEM:0", "/job:tpu_host_worker/replica:0/task:1/device:CPU:0", "/job:tpu_host_worker/replica:0/task:1/device:TPU:0", "/job:tpu_host_worker/replica:0/task:1/device:TPU:1", "/job:tpu_host_worker/replica:0/task:1/device:TPU_SYSTEM:0", "/job:tpu_host_worker/replica:0/task:2/device:CPU:0", "/job:tpu_host_worker/replica:0/task:2/device:TPU:0", "/job:tpu_host_worker/replica:0/task:2/device:TPU:1", "/job:tpu_host_worker/replica:0/task:2/device:TPU_SYSTEM:0", "/job:tpu_host_worker/replica:0/task:3/device:CPU:0", "/job:tpu_host_worker/replica:0/task:3/device:TPU:0", "/job:tpu_host_worker/replica:0/task:3/device:TPU:1", "/job:tpu_host_worker/replica:0/task:3/device:TPU_SYSTEM:0"}, tf.versions = {bad_consumers = [], min_consumer = 0 : i32, producer = 1857 : i32}} {
  func.func @main(%arg0: tensor<i32> {tf._user_specified_name = "steps", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg1: tensor<*x!tf_type.resource<tensor<i64>>> {tf._user_specified_name = "899", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg2: tensor<*x!tf_type.resource<tensor<i64>>> {tf._user_specified_name = "901", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg3: tensor<*x!tf_type.resource<tensor<128x1024xf32>>> {tf._user_specified_name = "903", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg4: tensor<*x!tf_type.resource<tensor<1024xf32>>> {tf._user_specified_name = "905", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg5: tensor<*x!tf_type.resource<tensor<1024x1xf32>>> {tf._user_specified_name = "907", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg6: tensor<*x!tf_type.resource<tensor<i64>>> {tf._user_specified_name = "909", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg7: tensor<*x!tf_type.resource<tensor<25001x64xf32>>> {tf._user_specified_name = "911", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg8: tensor<*x!tf_type.resource<tensor<25001x64xf32>>> {tf._user_specified_name = "913", tf.device = "/job:tpu_host_worker/replica:0/task:1/device:CPU:0"}, %arg9: tensor<*x!tf_type.resource<tensor<25001x64xf32>>> {tf._user_specified_name = "915", tf.device = "/job:tpu_host_worker/replica:0/task:2/device:CPU:0"}, %arg10: tensor<*x!tf_type.resource<tensor<25001x64xf32>>> {tf._user_specified_name = "917", tf.device = "/job:tpu_host_worker/replica:0/task:3/device:CPU:0"}, %arg11: tensor<*x!tf_type.resource<tensor<25001x32xf32>>> {tf._user_specified_name = "919", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg12: tensor<*x!tf_type.resource<tensor<25001x32xf32>>> {tf._user_specified_name = "921", tf.device = "/job:tpu_host_worker/replica:0/task:1/device:CPU:0"}, %arg13: tensor<*x!tf_type.resource<tensor<25001x32xf32>>> {tf._user_specified_name = "923", tf.device = "/job:tpu_host_worker/replica:0/task:2/device:CPU:0"}, %arg14: tensor<*x!tf_type.resource<tensor<25001x32xf32>>> {tf._user_specified_name = "925", tf.device = "/job:tpu_host_worker/replica:0/task:3/device:CPU:0"}, %arg15: tensor<*x!tf_type.resource<tensor<6x32xf32>>> {tf._user_specified_name = "927", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg16: tensor<*x!tf_type.resource<tensor<6x32xf32>>> {tf._user_specified_name = "929", tf.device = "/job:tpu_host_worker/replica:0/task:1/device:CPU:0"}, %arg17: tensor<*x!tf_type.resource<tensor<6x32xf32>>> {tf._user_specified_name = "931", tf.device = "/job:tpu_host_worker/replica:0/task:2/device:CPU:0"}, %arg18: tensor<*x!tf_type.resource<tensor<6x32xf32>>> {tf._user_specified_name = "933", tf.device = "/job:tpu_host_worker/replica:0/task:3/device:CPU:0"}, %arg19: tensor<*x!tf_type.resource<tensor<128x1024xf32>>> {tf._user_specified_name = "935", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg20: tensor<*x!tf_type.resource<tensor<1024xf32>>> {tf._user_specified_name = "937", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}, %arg21: tensor<*x!tf_type.resource<tensor<1024x1xf32>>> {tf._user_specified_name = "939", tf.device = "/job:tpu_host_worker/replica:0/task:0/device:CPU:0"}) -> tensor<*xi64> attributes {allow_soft_placement = false, tf.entry_function = {control_outputs = "", inputs = "steps,unknown,unknown_0,unknown_1,unknown_2,unknown_3,unknown_4,unknown_5,unknown_6,unknown_7,unknown_8,unknown_9,unknown_10,unknown_11,unknown_12,unknown_13,unknown_14,unknown_15,unknown_16,unknown_17,unknown_18,unknown_19", outputs = "statefulpartitionedcall_RetVal"}} {
    %0 = tf_executor.graph {
      %outputs, %control = tf_executor.island wraps "tf.Const"() <{value = dense<false> : tensor<i1>}> {device = ""} : () -> tensor<i1>
      %outputs_0, %control_1 = tf_executor.island wraps "tf.StatefulPartitionedCall"(%arg0, %outputs, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14, %arg15, %arg16, %arg17, %arg18, %arg19, %arg20, %arg21) <{config = "", config_proto = "\0A\07\0A\03CPU\10\01\0A\07\0A\03GPU\10\002\02J\00\82\01\14h\01\88\01\01\BA\01\0C\0A\0Astandalone", executor_type = "", f = @__inference__train_helper_8510}> {_collective_manager_ids = [], _read_only_resource_inputs = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], device = ""} : (tensor<i32>, tensor<i1>, tensor<*x!tf_type.resource<tensor<i64>>>, tensor<*x!tf_type.resource<tensor<i64>>>, tensor<*x!tf_type.resource<tensor<128x1024xf32>>>, tensor<*x!tf_type.resource<tensor<1024xf32>>>, tensor<*x!tf_type.resource<tensor<1024x1xf32>>>, tensor<*x!tf_type.resource<tensor<i64>>>, tensor<*x!tf_type.resource<tensor<25001x64xf32>>>, tensor<*x!tf_type.resource<tensor<25001x64xf32>>>, tensor<*x!tf_type.resource<tensor<25001x64xf32>>>, tensor<*x!tf_type.resource<tensor<25001x64xf32>>>, tensor<*x!tf_type.resource<tensor<25001x32xf32>>>, tensor<*x!tf_type.resource<tensor<25001x32xf32>>>, tensor<*x!tf_type.resource<tensor<25001x32xf32>>>, tensor<*x!tf_type.resource<tensor<25001x32xf32>>>, tensor<*x!tf_type.resource<tensor<6x32xf32>>>, tensor<*x!tf_type.resource<tensor<6x32xf32>>>, tensor<*x!tf_type.resource<tensor<6x32xf32>>>, tensor<*x!tf_type.resource<tensor<6x32xf32>>>, tensor<*x!tf_type.resource<tensor<128x1024xf32>>>, tensor<*x!tf_type.resource<tensor<1024xf32>>>, tensor<*x!tf_type.resource<tensor<1024x1xf32>>>) -> tensor<*xi64>
      tf_executor.fetch %outputs_0 : tensor<*xi64>
    }
    return %0 : tensor<*xi64>
  }
  func.func private @__inference__train_helper_8510(%arg0: tensor<i32> {tf._user_specified_name = "steps"}, %arg1: tensor<i1> {tf._user_specified_name = "include_summaries"}, %arg2: tensor<!tf_type.resource> {tf._user_specified_name = "input_5"}, %arg3: tensor<!tf_type.resource> {tf._user_specified_name = "input_6"}, %arg4: tensor<!tf_type.resource> {tf._user_specified_name = "input_7"}, %arg5: tensor<!tf_type.resource> {tf._user_specified_name = "input_8"}, %arg6: tensor<!tf_type.resource> {tf._user_specified_name = "input_9"}, %arg7: tensor<!tf_type.resource> {tf._user_specified_name = "input_10"}, %arg8: tensor<!tf_type.resource> {tf._user_specified_name = "input_11"}, %arg9: tensor<!tf_type.resource> {tf._user_specified_name = "input_12"}, %arg10: tensor<!tf_type.resource> {tf._user_specified_name = "input_13"}, %arg11: tensor<!tf_type.resource> {tf._user_specified_name = "input_14"}, %arg12: tensor<!tf_type.resource> {tf._user_specified_name = "input_15"}, %arg13: tensor<!tf_type.resource> {tf._user_specified_name = "input_16"}, %arg14: tensor<!tf_type.resource> {tf._user_specified_name = "input_17"}, %arg15: tensor<!tf_type.resource> {tf._user_specified_name = "input_18"}, %arg16: tensor<!tf_type.resource> {tf._user_specified_name = "input_19"}, %arg17: tensor<!tf_type.resource> {tf._user_specified_name = "input_20"}, %arg18: tensor<!tf_type.resource> {tf._user_specified_name = "input_21"}, %arg19: tensor<!tf_type.resource> {tf._user_specified_name = "input_22"}, %arg20: tensor<!tf_type.resource> {tf._user_specified_name = "input_23"}, %arg21: tensor<!tf_type.resource> {tf._user_specified_name = "input_24"}, %arg22: tensor<!tf_type.resource> {tf._user_specified_name = "input_25"}) -> tensor<*xi64> attributes {tf._construction_context = "kEagerRuntime", tf._disable_acd = true, tf._input_shapes = [#tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>, #tf_type.shape<>], tf.signature.is_stateful} {
    %0 = tf_executor.graph {
      %control = tf_executor.island wraps "tf.NoOp"() {_pivot_for_cluster = "cluster__train_helper", device = ""} : () -> ()
      %control_0 = tf_executor.island(%control) wraps "tf.NoOp"() {_has_manual_control_dependencies = true, _tpu_replicate = "cluster__train_helper", device = ""} : () -> ()
      %control_1 = tf_executor.island(%control) wraps "tf.TPUReplicateMetadata"() <{allow_soft_placement = false, computation_shape = [], device_assignment = [0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0], host_compute_core = [], num_cores_per_replica = 4 : i64, num_replicas = 2 : i64, padding_map = [], step_marker_location = "STEP_MARK_AT_TOP_LEVEL_WHILE_LOOP", topology = "\0A\04\02\02\02\01\10\04\18\02\22 \00\00\00\00\00\01\00\00\01\00\00\00\01\01\00\00\00\00\01\00\00\01\01\00\01\00\01\00\01\01\01\00*\02\08\01", tpu_compile_options_proto = "", use_spmd_for_xla_partitioning = true, use_tpu = true}> {_has_manual_control_dependencies = true, _tpu_replicate = "cluster__train_helper", device = ""} : () -> ()
      %outputs, %control_2 = tf_executor.island(%control_1) wraps "tf.Const"() <{value = dense<0> : tensor<i32>}> {_tpu_replicate = "cluster__train_helper", device = ""} : () -> tensor<i32>
      %outputs_3, %control_4 = tf_executor.island(%control_1) wraps "tf.Const"() <{value = dense<0> : tensor<i32>}> {_tpu_replicate = "cluster__train_helper", device = ""} : () -> tensor<i32>
      %outputs_5, %control_6 = tf_executor.island(%control_1) wraps "tf.TPUCompilationResult"() {_tpu_compilation_status = "cluster__train_helper", device = ""} : () -> tensor<!tf_type.string>
      %outputs_7, %control_8 = tf_executor.island(%control_1) wraps "tf.Const"() <{value = dense<0> : tensor<i32>}> {_tpu_replicate = "cluster__train_helper", device = ""} : () -> tensor<i32>
      %outputs_9, %control_10 = tf_executor.island(%control_1) wraps "tf.Const"() <{value = dense<-1> : tensor<i32>}> {_tpu_replicate = "cluster__train_helper", device = ""} : () -> tensor<i32>
      %outputs_8, %control_9 = tf_executor.island wraps "tf.ReadVariableOp"(%arg4) {_tpu_replicate = "cluster__train_helper", device = ""} : (tensor<!tf_type.resource>) -> tensor<*xf32>
      %outputs_10, %control_11 = tf_executor.island wraps "tf.ReadVariableOp"(%arg5) {_tpu_replicate = "cluster__train_helper", device = ""} : (tensor<!tf_type.resource>) -> tensor<*xf32>
      %outputs_12, %control_382 = tf_executor.island wraps "tf.XlaSharding"(%outputs_8) <{_XlaSharding = "\08\03\1A\01\04\22\04\00\01\02\03", sharding = "\08\03\1A\01\04\22\04\00\01\02\03"}> {_tpu_replicate = "cluster__train_helper", device = "", unspecified_dims = []} : (tensor<*xf32>) -> tensor<*xf32>
      %outputs_11, %control_12 = tf_executor.island wraps "tf.MatMul"(%outputs_12, %outputs_10) {_tpu_replicate = "cluster__train_helper", device = ""} : (tensor<*xf32>, tensor<*xf32>) -> tensor<*xf32>
      %outputs_13, %control_14 = tf_executor.island wraps "tf.Identity"(%outputs_11) {_tpu_output_identity = true, _tpu_replicate = "cluster__train_helper", device = ""} : (tensor<*xf32>) -> tensor<*xf32>
      %outputs_15:2, %control_16 = tf_executor.island wraps "tf.TPUReplicatedOutput"(%outputs_13) {device = ""} : (tensor<*xf32>) -> (tensor<*xf32>, tensor<*xf32>)
      %outputs_17, %control_18 = tf_executor.island(%control_0) wraps "tf.Identity"(%outputs_15#0) {_has_manual_control_dependencies = true, device = ""} : (tensor<*xf32>) -> tensor<*xf32>
      %control_19 = tf_executor.island(%control_18) wraps "tf.NoOp"() {_has_manual_control_dependencies = true, device = ""} : () -> ()
      %outputs_20, %control_21 = tf_executor.island(%control_18, %control_19) wraps "tf.ReadVariableOp"(%arg3) {device = ""} : (tensor<!tf_type.resource>) -> tensor<*xi64>
      %outputs_22, %control_23 = tf_executor.island wraps "tf.Identity"(%outputs_20) {device = ""} : (tensor<*xi64>) -> tensor<*xi64>
      %outputs_24, %control_25 = tf_executor.island(%control_0) wraps "tf.Identity"(%outputs_15#1) {device = ""} : (tensor<*xf32>) -> tensor<*xf32>
      tf_executor.fetch %outputs_22 : tensor<*xi64>
    }
    return %0 : tensor<*xi64>
  }
}