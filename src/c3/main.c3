
type list(type item);
type string;

module c3
{
	module ir
	{
		type instruction;
		struct lambda : instruction
		{
			
		}
		struct call : instruction
		{
			Value* pFunction;
		}
		type block = list(instruction);
		type function
		{
			type input;
			type output;
			list(block) body;
		}
		type scope = dict(string, instruction);
	}
}

// In a scope, names refer to values. Values are assigned once to a name but can
// be different at each execution. Variables are implemented through an
// alloca instruction that return a pointer to some memory that can
// hold the variable. The mem2ref transformation is used to create a SSA version
// of the same compuatation used for optimizations but they are ultimately
// translated back to memory handling for the "object allocation" phase.