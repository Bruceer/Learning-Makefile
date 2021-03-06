.PHONY: all clean

MKDIR = mkdir

CC = gcc
RM = rm
RMFLAGS = -rf

DIR_OBJS = objs
DIR_EXES = exes
DIR_DEPS = deps
DIRS = $(DIR_OBJS) $(DIR_EXES) $(DIR_DEPS)

EXE  = compilcated
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
DEPS = $(SRCS:.c=.dep)

OBJS := $(addprefix $(DIR_OBJS)/, $(OBJS))
EXE  := $(addprefix $(DIR_EXES)/, $(EXE) )
DEPS := $(addprefix $(DIR_DEPS)/, $(DEPS))

all: $(EXE)

-include $(DEPS)

clean:
	$(RM) $(RMFLAGS) $(DIRS) 
 
$(DIRS):
	$(MKDIR) $@

$(EXE): $(DIR_EXES) $(OBJS)
	$(CC) -o $@ $(filter %.o,$^)

$(DIR_OBJS)/%.o: $(DIR_OBJS) %.c 
	$(CC) -o $@ -c $(filter %.c,$^)

$(DIR_DEPS)/%.dep: $(DIR_DEPS) %.c
	@echo "Making $@ ..."
	@set -e; \
	$(RM) $(RMFLAGS) $@.tmp ; \
	$(CC) -E -MM $(filter %.c,$^) > $@.tmp ; \
	sed 's,\(.*\)\.o[ :]*,objs/\1.o: ,g'< $@.tmp > $@ ; \
	$(RM) $(RMFLAGS) $@.tmp
