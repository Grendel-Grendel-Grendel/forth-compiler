with Parser; use Parser;
with Interpreter;
with Token;
with Ada.Text_IO;
with Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded;

procedure Main is
   Forth_File : Ada.Streams.Stream_IO.File_Type;
   Worded : String_Vector.Vector;
   Parsed : Token_Vector.Vector;
   Init_Data_Stack : Interpreter.Forth_Stack.Stack := Interpreter.Forth_Stack.Create;
   Init_Retun_Stack : Interpreter.Addr_Stack.Stack := Interpreter.Addr_Stack.Create;
begin
   --zAda.Streams.Stream_IO.Open(Forth_File,Ada.Streams.Stream_IO.In_File,"input.fs");
   -- Forth_Stream := Ada.Streams.Stream_IO.Stream(Forth_File);
   Worded := File_To_Words(Forth_File);
   Interpreter.Tok_Vec := Parse(Worded);

   Interpreter.Interpret(Data_Stack   => Init_Data_Stack,
                         Return_Stack => Init_Retun_Stack);
end Main;


