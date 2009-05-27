ERL        := erl
ERLC       := erlc
ERLC_FLAGS := 

test: erlycombinator.beam
	$(ERL) -noshell -s erlycombinator test
	
clean:
	rm -f *.beam
	rm -f *.dump

./%.beam: %.erl
	$(ERLC) $(ERLC_FLAGS) -o . $<