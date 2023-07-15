/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

struct FirstAnnotation {
  1: string name;
  2: i64 count = 1;
}
struct SecondAnnotation {
  2: i64 total = 0;
  3: SecondAnnotation recurse;
  4: UnionAnnotation either;
}
union UnionAnnotation {
  2: i64 left;
  3: i64 right;
}

@FirstAnnotation{name = "my_type"}
typedef string annotated_string

@FirstAnnotation{name = "my_struct", count = 3}
@SecondAnnotation
struct MyStruct {
  @SecondAnnotation{}
  5: annotated_string tag;
}

@FirstAnnotation
exception MyException {
  1: string message;
}

@SecondAnnotation{total = 1, either = UnionAnnotation{left = 0}}
union MyUnion {
  1: i64 int_value;
  2: string string_value;
}

@SecondAnnotation{total = 4, recurse = SecondAnnotation{total = 5}}
service MyService {
  @SecondAnnotation
  i64 my_function(2: annotated_string param);
}

@FirstAnnotation{name = "shiny"}
enum MyEnum {
  UNKNOWN = 0,
  @SecondAnnotation
  FIRST = 1,
}

@FirstAnnotation{name = "my_hack_enum"}
const map<string, string> MyConst = {"ENUMERATOR": "value"};
