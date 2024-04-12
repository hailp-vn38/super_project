import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class Entry<T> {
  final Completer<T?> completer;
  Entry({required this.completer});
}

class ExtensionEntry<Extension> extends Entry<Extension> {
  ExtensionEntry({required this.extension})
      : super(completer: Completer.sync());
  final Extension extension;
}

class HandlerConcurrent<T, S extends Entry<T>> {
  final requestController = StreamController<S>();
  late final StreamSubscription<void> _subscription;

  final Future<T?> Function(S entry) fun;

  HandlerConcurrent({int maxConcurrent = 1, required this.fun}) {
    Stream<void> sendRequest(S entry) {
      return fun(entry)
          .asStream()
          .doOnError(entry.completer.completeError)
          .doOnData(entry.completer.complete)
          .onErrorResumeNext(const Stream.empty());
    }

    _subscription = requestController.stream
        .flatMap(sendRequest, maxConcurrent: maxConcurrent)
        .listen(null);
  }

  Future<T?> run(S entry) async {
    requestController.add(entry);
    return entry.completer.future;
  }

  void close() {
    _subscription.cancel().then((_) => requestController.close());
  }
}
