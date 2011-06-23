
type list(type item);
type string;

module C3
{
	module IR
	{
		struct BasicBlock
		{
			List(Instruction) instructions;
			Terminator terminator;
		}
			
		struct Function
		{
			Type input;
			Type output;
			List(BasicBlock) basicBlocks;
		}
		
		struct Call
		{
			Value callee;
			Value input;
		}
		
		type Apply : Call;
		type Run : Call;
		
		variant Instruction
		{
			Apply,
			Run,
		}

		struct LocalUse
		{
			Function.basicBlocks.Index basicBlockIndex;
			BasicBlock.instructions.Index instructionIndex;
		}
		
		variant Value
		{
			Function,
			Apply,
			LocalUse,
		}
		
		type scope = list(value);
		type environment = list(scope);
	}
}

// In a scope, names refer to values. Values are assigned once to a name but can
// be different at each execution. Variables are implemented through an
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
// exit point.

//On hold, ideas for the future:
//	- dependent types
//	- exception handling
//	- pattern matching and type functions (or sooner?)