with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

use type Ada.Strings.Unbounded.Unbounded_String;

package body Parser is 
   package String_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural,
      Element_Type => Unbounded_String);
   
   function Get_Next return String is
      Word : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.Null_Unbounded_String;
      Buff : WordBuffer;
      Words : String_Vector.Vector;
   begin
      Open(Input_File,In_File,"input.fs");
  Read_Word:
      loop
	 Char := Character'Input (Stream (Input_File));
	 if Char = ' ' then
	    goto Continue;
	 else
	    Unbounded_String.Append(Word, Char);	       
	 end if;
	 <<Continue>>
      end loop Read_Word;
   end Get_Next;
end Parser;
