-module(erlycombinator).
-compile(export_all).

eternity(_) ->
  this_will_never_end.

%"regular" recursive length

test_mylength() ->
  0 = mylength([]),
  5 = mylength([1,2,3,4,5]).
  
mylength(L) ->
  case L of
    [] -> 0;
    [_|T] -> 1+mylength(T)
  end.
  
% w/o naming, attempt 0

test_mylength0() ->
  MyLength_0 =
    fun(L) ->
      case L of
        [] -> 0;
        [_|T] -> 1+eternity(T)
      end
    end,

  MyLength_1 =
    fun(L) ->
      case L of
        [] -> 0;
        [_|T] -> 1+
          fun(M) ->
            case M of
              [] -> 0;
              [_|T] -> 1+eternity(T)
            end
          end (T)
      end
    end,
      
  0 = MyLength_0([]),
  0 = MyLength_1([]),
  1 = MyLength_1([1]).

% w/o naming, attempt 1

test_mylength1() ->
  Eternity = fun(X) -> eternity(X) end,
  MyLength_0 =
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+F(T)
        end
      end
    end(Eternity),

  MyLength_1 =
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+F(T)
        end
      end
    end(
      fun(F) ->
        fun(L) ->
          case L of
            [] -> 0;
            [_|T] -> 1+F(T)
          end
        end
      end(Eternity)
    ),

  0 = MyLength_0([]),
  0 = MyLength_1([]),
  1 = MyLength_1([1]).

  
% w/o naming, attempt 2

test_mylength2() ->
  Eternity = fun(X) -> eternity(X) end,
  
  MyLength_0 =
  fun(G) ->
    G(Eternity)
  end(
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+F(T)
        end
      end
    end
  ),
  
  MyLength_1 =
  fun(G) ->
    G(G(Eternity))
  end(
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+F(T)
        end
      end
    end
  ),

  0 = MyLength_0([]),
  0 = MyLength_1([]),
  1 = MyLength_1([1]).


% w/o naming, attempt 3

test_mylength3() ->
  Eternity = fun(X) -> eternity(X) end,
  
  MyLength_0 =
  fun(G) ->
    G(G)
  end(
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+(F(Eternity))(T)
        end
      end
    end
  ),

  
  % come on, I can't understand why the heck the next step becomes the recursive length!
  
  % but the refactoring from now on - to extract the y-combinator - is pretty straightforward
  % I'll not go ahead here - please check the python version at http://github.com/bzanchet/pycombinator   
  
  MyLength =
  fun(G) ->
    G(G)
  end(
    fun(F) ->
      fun(L) ->
        case L of
          [] -> 0;
          [_|T] -> 1+(F(F))(T)
        end
      end
    end
  ),

  0 = MyLength_0([]),
  0 = MyLength([]),
  1 = MyLength([1]),
  2 = MyLength([1,2]),
  10 = MyLength([1,2,3,4,5,6,7,8,9,0]).
  
  
test() ->
  test_mylength(),
  test_mylength0(),
  test_mylength1(),
  test_mylength2(),
  test_mylength3(),
  io:format("ok!~n").
