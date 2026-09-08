// @dart=3.6
// ignore_for_file: type=lint
// build_runner >=2.4.16
import 'dart:io' as _io;
import 'package:build_runner/src/build_plan/builder_factories.dart'
    as _build_runner;
import 'package:build_runner/src/bootstrap/processes.dart' as _build_runner;
import 'package:hive_ce_generator/hive_ce_generator.dart' as _i1;
import 'package:source_gen/builder.dart' as _i2;

final _builderFactories = _build_runner.BuilderFactories(
  {
    'hive_ce_generator:hive_adapters_generator': [_i1.getAdaptersBuilder],
    'hive_ce_generator:hive_registrar_generator': [_i1.getRegistrarBuilder],
    'hive_ce_generator:hive_registrar_intermediate_generator': [
      _i1.getRegistrarIntermediateBuilder
    ],
    'hive_ce_generator:hive_schema_migrator': [_i1.getSchemaMigratorBuilder],
    'hive_ce_generator:hive_type_adapter_generator': [
      _i1.getTypeAdapterBuilder
    ],
    'source_gen:combining_builder': [_i2.combiningBuilder],
  },
  postProcessBuilderFactories: {
    'source_gen:part_cleanup': _i2.partCleanup,
  },
);
void main(List<String> args) async {
  _io.exitCode = await _build_runner.ChildProcess.run(
    args,
    _builderFactories,
  )!;
}
