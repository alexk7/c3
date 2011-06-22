
type list(type item);
type string;

module c3
{
	module ir
	{
		type basicBlock = list(value);
	
		type function
		{
			type input;
			type output;
			list(basicBlock) body;
		}
		
		struct call
		{
			value callee;
			value input;
		}
		
		struct use
		{
			list(basicBlock).index basicBlockIndex;
			list(value).index valueIndex;
		}
		
		type global
		
		type value = function | call | use;
		
		type scope = list(value);
	}
}

// In a scope, names refer to values. Values are assigned once to a name but can
// be different at each execution. Variables are implemented through an
// alloca instruction that return a pointer to some memory that can
// hold the variable. The mem2ref transformation is used to create a SSA version
// of the same computation used for optimizations but they are ultimately
// translated back to memory handling for the "object allocation" phase.