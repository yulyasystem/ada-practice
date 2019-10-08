--Yulia Bekeniova
--CS 422A
-- Lab Work #1 Ada


with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;

-- A=Sort(B+C*MZ)
procedure lab1 is

   N: integer:=10;
   P: integer:=2;
   H: integer:=N/P;


  --declarations
   type Vector is array (integer range <>) of integer;
   type Matrix is array (integer range <>,integer range <>) of integer;
   subtype VectH is Vector(1..H);
   subtype VectN is Vector(1..N);
   subtype MatrixN is Matrix(1..N,1..N);


   --function for simple Sorting of one part of data
   procedure SortData (K : in out Vector) is
    Temp : Integer;
 begin
    for I in reverse K'Range loop
       for J in K'First .. I loop
          if K(I) < K(J) then
             Temp := K(J);
             K(J) := K(I);
             K(I) := Temp;
          end if;
       end loop;
    end loop;
   end SortData;

   --variables
   A1:VectH;
   A2:VectH;
   A,B,C:VectN;
   MZ:MatrixN;
   z: integer:=0;
   x: integer:=0;

      -- Semaphors
   Sx,S1,S2,S3:Suspension_Object;

 procedure TaskStart is

      --THREADS
      --first thread
   task T1;
   task body T1 is
         C1: VectN;
      decrementForMerge1: Integer:=-1;
      decrementForMerge2: Integer:=-1;
   begin
      put("T1 started");
      --DATA INPUT A, MZ
        for i in 1..N loop
         A(i):=0;
         if i<=H then
            A1(i):=0;
            end if;
            for j in 1..N loop
               MZ(i,j):=j+1;
            end loop;
      end loop;

      --Send signal to T2
         Set_True(S1);

      --wait for data from T2 input
      Suspend_Until_True(Sx);
        --COPY SHARED RESOURCE
      Suspend_Until_True(S2);
         Set_False(S2);
         --CRITICAL SECTION!
      C1:=C;
         Set_True(S2);


      --CALCULATION
      for i in 1..H loop
         A1(i):=A1(i)+B(i);
         for j in 1..N loop
            A1(i):=A1(i)+MZ(i,j)*C1(j);
         end loop;
      end loop;
      --wait for signal
         Suspend_Until_True(S2);


      -- SortData part of TASK
      SortData(A1);
      --wait for T2 calculation
         Suspend_Until_True(S3);


      --MERGE SortData
      for i in 1..N loop
         if  (i+decrementForMerge1+1)>H then
            A(i):=A2(i-H);
         else
            if (i+decrementForMerge2+1)>H then
               A(i):=A1(i-H);
            else
               if A1(i+decrementForMerge1+1)<A2(i+decrementForMerge2+1) then
                  A(i):=A1(i+decrementForMerge1+1);
                  decrementForMerge2:=decrementForMerge2-1;
               else
                  A(i):=A2(i+decrementForMerge2+1);
                  decrementForMerge1:=decrementForMerge1-1;
               end if;
            end if;
         end if;
      end loop;
         --RESULT OUTPUT
     for i in 1..N loop
         put(A(i));
      end loop;
      put("T1 is finished!");
      end T1;

      --SECOND THREAD
   task T2;
   task body T2 is
      C2:VectN;
   begin
       -- data input C, B
      for i in 1..N loop
            B(i):=N-i;
            C(i):=i;
         if i<=H then
            A2(i):=0;
         end if;
      end loop;
      put("T2 is started");

      --SEND SIGNAL
         Set_True(Sx);


      --wait for signal
      Suspend_Until_True(S1);
      --COPY SHARED RESOURCE
      Suspend_Until_True(S2);
         Set_False(S2);
         --CRITICAL SECTION
      C2:= C;
      Set_True(S2);
      --CALCULATION
      for i in 1..H loop
         A2(i):=A2(i)+B(N-i+1);
         for j in 1..N loop
            A2(i):=A2(i)+MZ(N-i+1,j)*C2(j);
         end loop;
      end loop;
      SortData(A2);
      --SIGNAL TO T1
      Set_True(S3);
         New_Line;
      put("T2 is finished");
      end T2;

       begin
      null;
   end TaskStart;
begin
   Set_True(S2);
   New_Line;

   Put_Line("Lab1 is started");
   TaskStart;
   null;
end lab1;
