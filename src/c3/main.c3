type Sequence(type Item);
type StableIterator(Sequence(type Item));
type Integer;

namespace C3.IR
{	
	struct Function : FunctionType type, Sequence(Instruction) insts;
	
	struct FunctionType : Type parameterT, Type returnT;
	type Instruction > Parameter, Phi, Apply, Run, Terminator;
	
	type Type > FunctionType, IntegerType, TupleType, ArrayType;
	
	struct Parameter : Type;
	struct Phi : InstructionIterator iComeFrom, InstructionIterator iValue;
	struct Apply : Call;
	struct Run : Call;
	type Terminator > Return, Branch, Unreachable;

	struct IntegerType : Integer bitCount;
	struct TupleType : Sequence(Type) memberTypes;
	struct ArrayType : Type memberType, Integer size;
	
	type InstructionIterator = StableIterator(Function.insts);
	
	struct Call : Type ty, Callee fn, Argument arg;
	
	struct Return : Argument;
	type Branch > UnconditionalBranch, ConditionalBranch;
	struct Unreachable;
	
	type Callee > Function, InstructionIterator;
	type Argument > Constant, InstructionIterator;
	
	struct UnconditionalBranch : InstructionIterator;
	struct ConditionalBranch :
		Argument cond, InstructionIterator then, InstructionIterator else;
	
	type Constant > Integer, Function;
}

// A basic block is a range of instructions inside a function. It is an
// important concept because they form the nodes of the control flow graph of
// the function. Terminator instructions can only direct the flow of
// execution to the beginning of non-entry basic blocks.
// It starts with either:
//	-	The first instruction of the function, which is always a Parameter
//		instruction. In this case, the basic block is the "Entry Block".
//	-	The instruction following a Terminator instruction, which mark the end of
//		the previous basic block.

// A valid function must contain at least one basic block, called the "entry
// block".

// Rules for the entry block:
//	-	It is always the first basic block of a function.
//	- Its first instruction is always a Parameter instruction. Parameter
//		instructions cannot appear anywhere else.
//	- It contains no Phi instructions.

// Rules for all blocks:
//	-	Phi instructions must all be grouped together at the beginning of the
//		instruction sequence.
//	-	Ends with a Terminator instruction.

// Rules for the exit block:
//	- Ends with a Return instruction. Return instructions cannot appear
//		anywhere else.

// Function: modular piece of code. The whole program itself is a Function.
// Any I/O in the C3IR program is done using functions passed as input (this is
// the way a C3IR access anything from the environment).

// Apply: Functional programming function call
// Run: Imperative programming procedure call

// Variables are implemented through an alloca instruction that return a pointer
// to some memory that can hold the variable. The mem2ref transformation is used
// to create a SSA version of the same computation used for optimizations but
// they are ultimately translated back to memory handling for the "object
// allocation" phase.

// Overloading must be supported by the IR because the object allocation phase
// can choose a different implementation than the declared type of a variable.
// (A concrete implementation may not even exist for the declared type.) The
// can choose a supertype (that can represent a superset of the set represented
// by the declared type).

// Destructor calls must be implicit in the IR because of arbitrary exits and
// exception handling. In order to allow optimizations accross multiple function
// calls, handling of dynamically changing function epilog must be automatic and
// implicit. For example, the number destructors to call change depending of the
// exit point. That also mean that the C3 construct "atexit" must be explicitly
// supported to introduce and remove part of the epilog. In fact, after object
// allocation, all destructor calls will be explicit using this facility.

// Part of minimal feature set:
//	-	Integers
//	-	Arrays
//	-	(Text does not require special features since it is an array of integers
//		representing utf-32 characters)

// On hold, ideas for the future:
//	- dependent types
//	- exception handling
//	- rational and floating-point numbers
//	- symbolic computation
//	- pattern matching and type functions (or sooner?)

// The Plan is to NOT implement those:
//	-	Switch and IndirectBranch instructions. Both can be simulated with Branch
//		instructions.

//Rules for names:
//	-	Global names do not contain any abbreviation and have an unambiguous
//		meaning. If another global name is introduced that cause an ambiguity,
//		both names must be changed to resolve it (refactoring of all uses should
//		be easy.
//	- Local names (including local variables and function arguments) can be as
//		short as possible. Sometimes, the type of a parameter is enough to
//		understand its purpose and a single letter name is enough (it is still
//		required by the C3 syntax to have a name for the parameter).

// A C3 Array is equivalent to a C++ Random Access Container.