module C3
{
    module IR
    {
        struct Function;
        struct Type;
        type Constant = Union(Function, Type, Module);
        struct Constant
        {
            Expression type;
        }
        type Module = Map(String, Constant);
    }
}

