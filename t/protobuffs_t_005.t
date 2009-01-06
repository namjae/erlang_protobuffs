#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./ebin -sasl errlog_type error -boot start_sasl -noshell

-record(person, {name, address, phone_number, age, location}).

main(_) ->
    etap:plan(1),
    etap:is(protobuffs_compile:scan_file("t/simple.proto"), ok, "simple.proto compiled"),
    compile:file("simple_pb.erl"),
    Data = [{1, <<"Nick">>, string}, {2, <<"Mountain View">>, string}, {3, <<"+1 (000) 555-1234">>, string}, {4, 25, int32}],
    BinData = erlang:iolist_to_binary([protobuffs:encode(Pos, Value, Type) || {Pos, Value, Type} <- Data]),
    #person{
        name = <<"Nick">>,
        address = <<"Mountain View">>,
        phone_number = <<"+1 (000) 555-1234">>,
        age = 25
    } = simple_pb:decode_person(BinData),
    BinData = simple_pb:encode_person(#person{
        name = <<"Nick">>,
        address = <<"Mountain View">>,
        phone_number = <<"+1 (000) 555-1234">>,
        age = 25
    }),
    etap:end_tests().
