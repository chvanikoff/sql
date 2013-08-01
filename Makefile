REBAR=`which rebar`

all: compile

compile:
	@( $(REBAR) compile )