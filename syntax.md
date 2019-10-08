# ADA :satisfied: practice 

* variables declaration only before *begin*, there is a declaration scope which finishes whit word begin
```ada
procedure main is
    A,B,C:Integer;
begin
    body of procedure(asingment scope)
```

* begin introduces sequence of statement, assignment, condition
* assignment :=
* equality =
* attribute `'`, e.g. Integer'Value `Value` is attribute that transform string into value of a type, so Integer'Value `Value` would transform a string into integer type
* Integer'Image `Image` does oposite effect it  takes value of a type and transforms to string 
* to interact with console use library unit, provide access I/O on the console
```ada 
   with Ada.Text.IO
``` 
* to concatenate 2 strings use `&`
  
# Concurrency in Ada