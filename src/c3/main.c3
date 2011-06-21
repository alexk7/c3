

module C3
{
	module IR
	{
		struct Block
		{
			
		}
		struct Function
		{
			List(Block) blocks;
		}
		struct Type;
		type Constant = Union(Function, Type, Module);
		struct Call
		{
			Value* pFunction; 
		}
		type Value = Union(
		type Scope = Map(String, Value);
	}
}

// In a scope, names refer to values. Values are assigned once to a name but can
// be different at each execution. Variables are implemented through an
// alloca instruction that return a pointer to some memory that can
// hold the variable. The mem2ref transformation is used to create a SSA version
// of the same compuatation used for optimizations but they are ultimately
// translated back to memory handling for the "object allocation" phase.