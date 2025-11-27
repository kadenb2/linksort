with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure LinkSort is

   -- Enumeration types for sorting
   type JobType is (Accountant, Analyst, Manager, Manufacturing, Programmer,
                    Inventory, Sales, SoftwareEngineer);
   package JobTypeIO is new Enumeration_IO(JobType); use JobTypeIO;

   type EmpName is (Ben, Betty, Bob, Damon, Darlene, David, Desire, Donald, Dustin,
                    Jerry, Kevin, Mary, Marty, Sable, Sam, Sara, Teddy, Tom);
   package EmpNameIO is new Enumeration_IO(EmpName); use EmpNameIO;

   -- Employee record
   type Emp is record
      Name: EmpName;
      Job: JobType;
      Age: Integer;
      Next: Integer;
   end record;

   -- Static array for employee records
   SortSpace: array (1..200) of Emp;
   -- Array to track job type lists
   SortByJob: array (JobType) of Integer := (others => 0);
   -- Track available index
   Avail: Integer := 1;

   -- File handling
   File_Input: File_Type;
   Employee_Name: EmpName;
   Employee_Job: JobType;
   Employee_Age: Integer;
   Pt, Current, Prev, Temp: Integer;

begin
   -- Open the input file
   Open(File_Input, In_File, "C:\Users\kaden\Downloads\bin\obj\ContainersCSpring25CMission.txt");

   -- Read employee records until EOF
   while not End_Of_File(File_Input) loop
      -- Read input data
      Get(File_Input, Employee_Name);
      Get(File_Input, Employee_Job);
      Get(File_Input, Employee_Age);

      -- Assign values to SortSpace
      SortSpace(Avail).Name := Employee_Name;
      SortSpace(Avail).Job := Employee_Job;
      SortSpace(Avail).Age := Employee_Age;
      SortSpace(Avail).Next := 0;

      -- If the list for this job type is empty, create a new circular list
      if SortByJob(Employee_Job) = 0 then
         SortSpace(Avail).Next := Avail; -- Points to itself
         SortByJob(Employee_Job) := Avail;
      else
         -- Insert sorted (by age, then name)
         Current := SortByJob(Employee_Job);
         Prev := 0;

         -- Traverse list to find the correct position
         loop
            if (SortSpace(Current).Age > Employee_Age) or
               ((SortSpace(Current).Age = Employee_Age) and (SortSpace(Current).Name > Employee_Name)) then
               exit;
            end if;

            Prev := Current;
            Current := SortSpace(Current).Next;

            -- If we've completed a full circle, break out
            if Current = SortByJob(Employee_Job) then
               exit;
            end if;
         end loop;

         -- Insert at the beginning of the list
         if Prev = 0 then
            Temp := SortByJob(Employee_Job);
            while SortSpace(Temp).Next /= SortByJob(Employee_Job) loop
               Temp := SortSpace(Temp).Next;
            end loop;
            SortSpace(Avail).Next := SortByJob(Employee_Job);
            SortByJob(Employee_Job) := Avail;
            SortSpace(Temp).Next := Avail;
         -- Insert in the middle or end
         else
            SortSpace(Avail).Next := SortSpace(Prev).Next;
            SortSpace(Prev).Next := Avail;
         end if;
      end if;

      -- Move to next available index
      Avail := Avail + 1;
   end loop;

   -- Close the input file
   Close(File_Input);

   -- Output sorted employee records
   for J in JobType loop
      if SortByJob(J) /= 0 then
         New_Line;
         Put("Job Type = ");
         Put(J);
         New_Line;
         Pt := SortByJob(J);

         loop
            Put(SortSpace(Pt).Name);
            Put(" ");
            Put(SortSpace(Pt).Job);
            Put(" ");
            Put(SortSpace(Pt).Age, 3);
            New_Line;

            Pt := SortSpace(Pt).Next;
            exit when Pt = SortByJob(J);
         end loop;
      end if;
   end loop;

end LinkSort;
