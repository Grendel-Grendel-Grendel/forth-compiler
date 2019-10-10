with Token;
with Parser;
with Ada.Strings.Hash_Case_Insensitive;
with Ada.Containers.Indefinite_Hashed_Maps; use Ada.Containers;
package Interpreter is
   Program_Counter : Natural := 0;
   Tok_Vec : Parser.Token_Vector.Vector;
   package Forth_Stack is new Token.Generic_Stack(Element_Type => Token.Token);
   package Addr_Stack is new Token.Generic_Stack(Element_Type => Natural);
   type Primitive_Ptr is access procedure ( Data_Stack : in out Forth_Stack.Stack;
                                            Return_Stack : in out Addr_Stack.Stack);
   type Dic_Entry (IsCompiled : Boolean := False; Name_Length : Token.Max_Range :=1) is record
      Name : String (1..Name_Length);
      case IsCompiled is
         when False =>
            Function_Address : Primitive_Ptr;
         when True =>
            Definition_Index : Natural;
      end case;
   end record;
   package Dictionary is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type => Token.Token,
      Element_Type => Dic_Entry,
      Hash => Token.Hash_Token,
      Equivalent_Keys => Token.Equal_Token);
   procedure Interpret (Data_Stack : in out Forth_Stack.Stack;
                        Return_Stack: in out Addr_Stack.Stack);


end Interpreter;
