with Ada.Strings.Unbounded;
with Ada.Containers;

package Token is
   subtype Max_Range is Integer range 1 .. 300;
   type Token (Is_Number: Boolean := False; String_Length : Max_Range := 1) is
      record
         case Is_Number is
            when True =>
               FInt : Integer;
            when False =>
               FWord : String(1..String_Length);
         end case;
      end record;

   function Make_Token (Text : Ada.Strings.Unbounded.Unbounded_String) return Token;
   function Make_Token (n : Integer) return Token;
   function Equal_Token (Tok1, Tok2 : Token) return Boolean;
   function Hash_Token (Key : Token) return Ada.Containers.Hash_Type;

   generic
      type Element_Type is private;
   package Generic_Stack is
      type Stack is private;
      procedure Push (Item : Element_Type; Onto : in out Stack);
      procedure Pop (Item : out Element_Type; From : in out Stack);
      function Create return Stack;
      Stack_Empty_Error : exception;
   private
      type Node;
      type Stack is access Node;
      type Node is record
         Element : Element_Type;
         Next    : Stack        := null;
      end record;
   end Generic_Stack;




end Token;
