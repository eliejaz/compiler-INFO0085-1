CXX 			= clang++

CXXFLAGS        = -Wall -Wextra $(shell llvm-config --cxxflags) -Wno-unused-parameter
LDFLAGS         = $(shell llvm-config --ldflags --libs --system-libs)

BISONFLAGS 		= -d

EXEC			= vsopc

SRC				= main.cpp \
				  driver.cpp \
				  parser.cpp \
				  lexer.cpp \
				  ASTClassesSemanticChecker.cpp \
				  ASTClassesCodeGenerator.cpp

OBJ	  			= $(SRC:.cpp=.o)


vsopc: $(EXEC)

main.o: driver.hpp parser.hpp

driver.o: driver.hpp parser.hpp

parser.o: driver.hpp parser.hpp

lexer.o: driver.hpp parser.hpp

ASTClassesSemanticChecker.o: driver.hpp parser.hpp ASTClasses.hpp ProgramScope.hpp

ASTClassesCodeGenerator.o: driver.hpp parser.hpp ASTClasses.hpp CodeGenerator.hpp


$(EXEC): $(OBJ)
	$(CXX) -o $@ $(LDFLAGS) $(OBJ)

parser.cpp: parser.y
	bison $(BISONFLAGS) -o parser.cpp $^

parser.hpp: parser.y
	bison $(BISONFLAGS) -o parser.cpp $^

lexer.cpp: lexer.lex
	flex $(LEXFLAGS) -o lexer.cpp $^

clean:
	@rm -f $(EXEC)
	@rm -f $(OBJ)
	@rm -f lexer.cpp
	@rm -f parser.cpp parser.hpp location.hh

.PHONY: clean

install-tools:
