with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

use type Ada.Strings.Unbounded.Unbounded_String;

package body Parser is
   --This function converts a file into a list of string words.
   function File_To_Words (Forth_File : in out Ada.Streams.Stream_IO.File_Type) return String_Vector.Vector is
      use Ada.Strings.Unbounded;
      Words : String_Vector.Vector;
      Word : Unbounded_String;
      begin
      Ada.Streams.Stream_IO.Open(Forth_File,Ada.Streams.Stream_IO.In_File,"input.fs");
      
      
      Get_Words:
      while not Ada.Streams.Stream_IO.End_Of_File(Forth_File) loop
         Word := Get_Next(Forth_File);
         if element(Word,1) = ' ' or element(Word,1) = LF then
            goto continue;
         else String_Vector.Append(Words,Word);
         end if;
         <<continue>>
      end loop Get_Words;
      return Words;
      end File_To_Words;
   -- This function gets the next word token out of the file.
   function Get_Next (Forth_File : in out Ada.Streams.Stream_IO.File_Type) return Ada.Strings.Unbounded.Unbounded_String is
      Word : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
      Char : Character;
      Forth_Stream : Ada.Streams.Stream_IO.Stream_Access; 
   begin
      --Open(Input_File,In_File,"input.fs");
      Forth_Stream := Ada.Streams.Stream_IO.Stream(Forth_File);
      Read_Word:
      while not Ada.Streams.Stream_IO.End_Of_File(Forth_File) loop
         Char := Character'Input (Forth_Stream);
         exit Read_Word when Char = LF;
         Ada.Strings.Unbounded.Append(Word, Char);
         exit Read_Word when Char = ' ';
      end loop Read_Word;
      return Word;
   end Get_Next;
   function Parse (Str_Vec : String_Vector.Vector) return Token_Vector.Vector is
      Tok_Vec : Token_Vector.Vector;
      procedure Iter_Parse (C: String_Vector.Cursor) is
      begin
         Token_Vector.Append(Tok_Vec,(Token.Make_Token(String_Vector.Element(C))));
      end Iter_Parse;
      
      begin
      Str_Vec.Iterate(Iter_Parse'Access);
      return Tok_Vec;
   end Parse;
end Parser;
