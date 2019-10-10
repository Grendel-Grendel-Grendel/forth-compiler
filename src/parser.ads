with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO;
with Token;

use type Ada.Strings.Unbounded.Unbounded_String;

package Parser is
   function Get_Next (Forth_File : in out Ada.Streams.Stream_IO.File_Type) return Ada.Strings.Unbounded.Unbounded_String;
   package String_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural,
      Element_Type => Ada.Strings.Unbounded.Unbounded_String);
   package Token_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural,
      Element_Type => Token.Token,
      "=" => Token.Equal_Token);
   function File_To_Words(Forth_File : in out Ada.Streams.Stream_IO.File_Type) return String_Vector.Vector;
   --type Token (Option: Ada.Strings.Unbounded.Unbounded_String);
   function Parse (Str_Vec : String_Vector.Vector) return Token_Vector.Vector;

end Parser;
