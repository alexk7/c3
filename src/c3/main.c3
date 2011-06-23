type Set(type Item);
type Integer;
type Void;

namespace C3.IR
{
	struct BasicBlock
	{
		Set(Instruction) instructions;
		Terminator terminator;
	}
	
	struct Function
	{
		Type input;
		Type output;
		Set(BasicBlock) basicBlocks;
	}

	struct Call
	{
		Value callee;
		Value input;
	}

	struct Apply
	{
		Call call;
	}

	struct Run
	{
		Call call;
	}

	variant Instruction
	{
		Apply,
		Run,
	}

	struct Local
	{
		Function.basicBlocks.Index basicBlockIndex;
		BasicBlock.instructions.Index instructionIndex;
	}
	
	struct InputUse 
	{
	}

	variant Value
	{
		Function,
		Integer,
		Local,
		Input,
	}
}

// Function: modular piece of code. The whole program itself is a Function.
// Any I/O in the C3IR program is done using functions passed as input (this is
// the way a C3IR access anything from the environment).

// Apply: Functional programming function call
// Run: Imperative programming procedure call

// Variables are implemented through an
// alloca instruction that return a pointer to some memory that can
// hold the variable. The mem2ref transformation is used to create a SSA version
// of the same computation used for optimizations but they are ultimately
// translated back to memory handling for the "object allocation" phase.

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
