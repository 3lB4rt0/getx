import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('once', () async {
    final count = 0.obs;
    var result = -1;
    once(count, (dynamic _) {
      result = _ as int;
    });
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
  });

  test('ever', () async {
    final count = 0.obs;
    var result = -1;
    ever<int>(count, (value) {
      result = value;
    });
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(2, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(3, result);
  });

  test('debounce', () async {
    final count = 0.obs;
    int? result = -1;
    debounce(count, (dynamic _) {
      // print(_);
      result = _ as int?;
    }, time: Duration(milliseconds: 100));

    count.value++;
    count.value++;
    count.value++;
    count.value++;
    await Future.delayed(Duration.zero);
    expect(-1, result);
    await Future.delayed(Duration(milliseconds: 100));
    expect(4, result);
  });

  test('interval', () async {
    final count = 0.obs;
    int? result = -1;
    interval(count, (dynamic _) {
      // print(_);
      result = _ as int?;
    }, time: Duration(milliseconds: 100));

    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(1, result);
    count.value++;
    count.value++;
    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(2, result);
    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(5, result);
  });

  test('bindStream test', () async {
    int? count = 0;
    final controller = StreamController<int>();
    final rx = 0.obs;

    rx.listen((value) {
      count = value;
    });
    rx.bindStream(controller.stream);
    expect(count, 0);
    controller.add(555);

    await Future.delayed(Duration.zero);
    expect(count, 555);
  });

  test('Rx same value will not call the same listener when `call`', () async {
    var reactiveInteger = RxInt(2);
    var timesCalled = 0;
    reactiveInteger.listen((newInt) {
      timesCalled++;
    });

    // we call 3
    reactiveInteger.call(3);
    // then repeat twice
    reactiveInteger.call(3);
    reactiveInteger.call(3);

    await Future.delayed(Duration(milliseconds: 100));
    expect(1, timesCalled);
  });

  test('Rx same value will call the listener when `trigger`', () async {
    var reactiveInteger = RxInt(2);
    var timesCalled = 0;
    reactiveInteger.listen((newInt) {
      timesCalled++;
    });

    // we call 3
    reactiveInteger.trigger(3);
    // then repeat twice
    reactiveInteger.trigger(3);
    reactiveInteger.trigger(3);

    await Future.delayed(Duration(milliseconds: 100));
    expect(3, timesCalled);
  });
}
