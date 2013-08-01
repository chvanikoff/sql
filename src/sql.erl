-module(sql).

%% API
-export([process_query/2]).

%% ===================================================================
%% API functions
%% ===================================================================

process_query([], _) -> [];
process_query(Q, []) -> Q;
process_query([$? | Query], [A | Args]) ->
	[prepare_argument(A) | process_query(Query, Args)];
process_query([Q | Query], [A | Args]) ->
	[Q | process_query(Query, [A | Args])].

%% ===================================================================
%% Internal functions
%% ===================================================================

prepare_argument(A) when is_binary(A) -> "'" ++ escape(binary_to_list(A)) ++ "'";
prepare_argument(A) when is_integer(A) -> integer_to_list(A);
prepare_argument(A) when is_float(A) -> float_to_list(A);
prepare_argument(A) when is_list(A) ->
	true = lists:all(fun(V) when is_integer(V) -> true; (_) -> false end, A),
	"(" ++ string:join(lists:map(fun(V) -> integer_to_list(V) end, A), ",") ++ ")";
prepare_argument(AB) when is_binary(AB) ->
	A = binary_to_list(AB),
	case length(A) > 0 andalso can_be_integer(A) of
		true -> A;
		false -> case length(A) > 0 andalso can_be_float(A) of
			true -> A;
			false -> "'" ++ escape(A) ++ "'"
		end
	end.

escape([]) -> [];
escape([$' | Alpha]) -> [92, 39 | escape(Alpha)];
escape([A | Alpha]) -> [A | escape(Alpha)].

can_be_integer([]) -> true;
can_be_integer([$0 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$1 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$2 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$3 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$4 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$5 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$6 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$7 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$8 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([$9 | Alpha]) -> can_be_integer(Alpha);
can_be_integer([_ | Alpha]) -> false.

can_be_float([]) -> true;
can_be_float([$0 | Alpha]) -> can_be_float(Alpha);
can_be_float([$1 | Alpha]) -> can_be_float(Alpha);
can_be_float([$2 | Alpha]) -> can_be_float(Alpha);
can_be_float([$3 | Alpha]) -> can_be_float(Alpha);
can_be_float([$4 | Alpha]) -> can_be_float(Alpha);
can_be_float([$5 | Alpha]) -> can_be_float(Alpha);
can_be_float([$6 | Alpha]) -> can_be_float(Alpha);
can_be_float([$7 | Alpha]) -> can_be_float(Alpha);
can_be_float([$8 | Alpha]) -> can_be_float(Alpha);
can_be_float([$9 | Alpha]) -> can_be_float(Alpha);
can_be_float([$. | Alpha]) -> can_be_float(Alpha);
can_be_float([_ | Alpha]) -> false.
