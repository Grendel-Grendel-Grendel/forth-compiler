with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Hash_Case_Insensitive;
with Ada.Unchecked_Deallocation;

package body Token is
   function Make_Token (Text : Ada.Strings.Unbounded.Unbounded_String) return Token is
      MyToken : Token;
      function Is_Numeric (Item : in String) return Boolean is
         Dummy : Integer;
      begin
         Dummy := Integer'Value (Item);
         return True;
      exception
         when others =>
            return False;
      end Is_Numeric;
   begin
      if Is_Numeric(To_String(Text))
      then
         MyToken := (Is_Number => True,
                     String_Length => To_String(Text)'Length,
                     FInt => Integer'Value(To_String(Text)));
      else
         MyToken := (Is_Number => False,
                     String_Length => To_String(Text)'Length,
                     FWord => To_String(Text));
      end if;
      return MyToken;
   end Make_Token;

   function Make_Token(n : Integer) return Token is
      MyToken : Token;
   begin
      MyToken := (Is_Number => True,
                  String_Length => n'Image'Length,
                  FInt => n);
      return MyToken;
   end Make_Token;

   function Equal_Token (Tok1, Tok2 : Token) return Boolean is
      begin
      if Tok1.Is_Number and Tok2.Is_Number then
         if Tok1.FInt = Tok2.FInt then
            return True;
         else return false;
         end if;
      else if not Tok1.Is_Number or Tok2.Is_Number then
            if Tok1.FWord = Tok2.FWord then
               return True;
            else return False;
            end if;
         end if;
      end if;
      return False;
   end Equal_Token;

   function Hash_Token (Key : Token) return Ada.Containers.Hash_Type is
      use Ada.Strings;
   begin
      return Ada.Strings.Hash_Case_Insensitive(Key.FWord);
   end Hash_Token;


   package body Generic_Stack is

   ------------
   -- Create --
   ------------

      function Create return Stack is
      begin
         return (null);
      end Create;

   ----------
   -- Push --
   ----------

      procedure Push(Item : Element_Type; Onto : in out Stack) is
         Temp : Stack := new Node;
      begin
         Temp.Element := Item;
         Temp.Next := Onto;
         Onto := Temp;
      end Push;

   ---------
   -- Pop --
   ---------

      procedure Pop(Item : out Element_Type; From : in out Stack) is
         procedure Free is new Ada.Unchecked_Deallocation(Node, Stack);
         Temp : Stack := From;
      begin
         if Temp = null then
            raise Stack_Empty_Error;
         end if;
         Item := Temp.Element;
         From := Temp.Next;
         Free(Temp);
      end Pop;

   end Generic_Stack;
end Token;
