type Container(type Item);
type StableIterator(Container c);
type Sequence(type Item) : Container(Item);
type Integer;

namespace C3.IR
{
	struct Function
	{
		Type in;
		Type out;
		Sequence(BasicBlock) bbs;
	}
	
	struct BasicBlock
	{
		Sequence(Instruction) insts;
		Terminator end;
	}
	
	variant Instruction
	{
		Input,
		Phi,
		Apply,
		Run,
	}
	
	struct Input
	{
	}
	
	struct Phi
	{
		BasicBlockIterator iBB;
		Use use;		
	}
	
	type Apply : Call;
	type Run : Call;
	
	type BasicBlockIterator = StableIterator(Function.bbs);
	
	struct Use
	{
		BasicBlockIterator iBB;
		InstructionIterator iI;
	}
	
	struct Call
	{
		Value callee;
		Value arg;
	}
	
	type InstructionIterator = StableIterator(BasicBlock.insts);
	
	variant Value
	{
		Function,
		Integer,
		Use,
	}
}

// A valid function must contain at least one basic block, called the "entry
// block".

// Rules for the entry block:
//	-	It is always the first basic block of a function.
//	- Its first instruction is always an Input instruction. Input instructions
//		cannot appear anywhere else.
//	- It contains no Phi instructions.

// Rules for all blocks:
//	-	Phi instructions must all be grouped together at the beginning of the
//		instruction sequence.

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

//Part of minimal feature set:
//	-	Integers
//	-	Arrays
//	-	(Text does not require special features since it is an array of integers
//		representing utf-32 characters)

//On hold, ideas for the future:
//	- dependent types
//	- exception handling
//	- rational and floating-point numbers
//	- symbolic computation
//	- pattern matching and type functions (or sooner?)

//Rules for names:
//	-	Global names do not contain any abbreviation and have an unambiguous
//		meaning. If another global name is introduced that cause an ambiguity,
//		both names must be changed to resolve it (refactoring of all uses should
//		be easy.
//	- Local names (including local variables and function arguments) can be as
//		short as possible. Sometimes, the type of a parameter is enough to
//		understand its purpose and a single letter name is enough (it is still
//		required by the C3 syntax to have a name for the parameter).
