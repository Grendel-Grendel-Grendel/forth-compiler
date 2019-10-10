with Token; use Token;
with Parser;
with Ada.Containers;
with Ada.Strings.Unbounded;
With Ada.Text_IO;

package body Interpreter is
    procedure Add (Data_Stack : in out Forth_Stack.Stack;
                   Return_Stack : in out Addr_Stack.Stack) is
      use Token;
      X : Token.Token;
      Y : Token.Token;
   begin
      Interpreter.Forth_Stack.Pop(X,Data_Stack);
      Interpreter.Forth_Stack.Pop(Y,Data_Stack);
      Interpreter.Forth_Stack.Push(Make_Token(X.FInt + Y.FInt),Data_Stack);
      Program_Counter := Program_Counter + 1;
   end Add;
   procedure CBranch (Data_Stack : in out Forth_Stack.Stack;
                      Return_Stack : in out Addr_Stack.Stack) is
      X: Token.Token;
   begin
      Interpreter.Forth_Stack.Pop(X,Data_Stack);
      if not (X.FInt = 0) then
         Interpreter.Addr_Stack.Push(Program_Counter
                                      ,Return_Stack);
         Program_Counter := Natural(Tok_Vec.Element(Program_Counter + 1).FInt);
      end if;
   end CBranch;
   procedure FPrint (Data_Stack : in out Forth_Stack.Stack;
                     Return_Stack : in out Addr_Stack.Stack) is
      use Ada.Text_IO;
      X : Token.Token;
   begin
      Forth_Stack.Pop(X,Data_Stack);
      if X.Is_Number
      then Put_Line(X.FInt'Image);
      else Put_Line(X.FWord);
      end if;
      Program_Counter := Program_Counter + 1;
   end FPrint;

   procedure
   function Make_Primitive_Entry (Prim : Primitive_Ptr; Name : String)
                                  return Dic_Entry is
      D : Dic_Entry;
   begin
      D := (IsCompiled => False,
            Name => Name,
            Name_Length => Token.Max_Range(Name'Length),
            Function_Address => Prim);
      return D;
   end Make_Primitive_Entry;

   function Initialize_Dictionary return Dictionary.Map is
      use Ada.Strings.Unbounded;
      use Interpreter;
      Primitive_Dic : Dictionary.Map;
   begin
      Dictionary.Insert(Primitive_Dic,
                        Token.Make_Token(To_Unbounded_String("+")),
                        Make_Primitive_Entry(Add'Access,"+"));
      Dictionary.Insert(Primitive_Dic,
                        Token.Make_Token(To_Unbounded_String("Branch?")),
                        Make_Primitive_Entry(CBranch'Access,"Branch?"));
      Dictionary.Insert(Primitive_Dic,
                        Token.Make_Token(To_Unbounded_String("Print")),
                        Make_Primitive_Entry(FPrint'Access,"Print"));
      return Primitive_Dic;
   end Initialize_Dictionary;


   procedure Interpret (Data_Stack : in out Forth_Stack.Stack;
                        Return_Stack : in out Addr_Stack.Stack) is
      Dic : Dictionary.Map := Initialize_Dictionary;
      Program_Length : Natural := Natural(Parser.Token_Vector.Length(Tok_Vec));
      Current_Tok : Token.Token;
      procedure Execute(Word : Dic_Entry) is
      begin
         if Word.IsCompiled
         then
            Addr_Stack.Push(Item => Program_Counter,
                            Onto => Return_Stack);
            Program_Counter := Word.Definition_Index;
         else
            Word.Function_Address(Data_Stack,Return_Stack);
         end if;
      end Execute;
      procedure Interpret_Token (Tok : Token.Token) is
         use Forth_Stack;
         begin
         if Tok.Is_Number then
            Push(Item => Tok,
                 Onto => Data_Stack);
            Program_Counter := Program_Counter + 1;
         else
            --Lookup a word in the dictionary with the token and execute it
            Execute(Dictionary.Element(Dic.Find(Key => Tok)));
         end if;
      end Interpret_Token;

   begin

      while Program_Counter < Program_Length
      loop
         Current_Tok := Tok_Vec.Element(Program_Counter);
         Interpret_Token(Current_Tok);
      end loop;

   end Interpret;

end Interpreter;
