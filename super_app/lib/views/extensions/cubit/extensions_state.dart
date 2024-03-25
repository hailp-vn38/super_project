// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'extensions_cubit.dart';

class ExtensionsState extends Equatable {
  const ExtensionsState(
      {required this.extensions,
      required this.allExtension,
      required this.extsUpdate});
  final StateRes<List<Extension>> extensions;
  final StateRes<List<Metadata>> allExtension;
  final StateRes<List<Metadata>> extsUpdate;

  factory ExtensionsState.init() => const ExtensionsState(
      extensions: StateRes(status: StatusType.init, data: []),
      allExtension: StateRes(status: StatusType.init, data: []),
      extsUpdate: StateRes(status: StatusType.init, data: []));

  @override
  List<Object> get props => [extensions, allExtension, extsUpdate];

  ExtensionsState copyWith(
      {StateRes<List<Extension>>? extensions,
      StateRes<List<Metadata>>? allExtension,
      StateRes<List<Metadata>>? extsUpdate}) {
    return ExtensionsState(
        extensions: extensions ?? this.extensions,
        allExtension: allExtension ?? this.allExtension,
        extsUpdate: extsUpdate ?? this.extsUpdate);
  }
}

class StateRes<T> extends Equatable {
  final StatusType status;
  final T? data;
  final String? message;
  const StateRes({required this.status, this.data, this.message});

  StateRes<T> copyWith({StatusType? status, T? data, String? message}) {
    return StateRes<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [status, data, message];
}
