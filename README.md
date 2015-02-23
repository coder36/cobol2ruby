Cobol -> Ruby Transpiler
------------------------

Transpiler to convert Cobol into Ruby.

Aims
----

* Create a ruby DSL which looks and feels familiar to a Cobol developer
* Emulate cobol display logic, providing hooks to convert transpiled code into a web app.
* Emulate File Descriptor sections, providing hooks to save to a database or file


Source Cobol code:
------------------

    IDENTIFICATION DIVISION.
    PROGRAM-ID. MY_PROG.
    WORKING-STORAGE SECTION.
    01 CONTEXT.
      02 NAME PIC X(10).
      02 ADDRESS.
      03 ADDRESS1 PIC X(10).
      03 ADDRESS2 PIC X(10).
      03 ADDRESS3 PIC X(10).
      03 POSTCODE PIC X(10).
    PROCEDURE DIVISION.
    MAIN-PROCEDURE.
      DISPLAY "What is your name? "
      ACCEPT NAME
      DISPLAY CONTEXT
    END PROGRAM MY_PROG.



Traget Ruby code:
-----------------

    IDENTIFICATION :DIVISION {
      PROGRAM-ID "MY_PROG"
    }
    WORK_STORAGE :SECTION {
      NN :CONTEXT {
        NN :NAME, :PIC => "X(10)" 
        NN :ADDRESS  {
        NN :ADDRESS1, :PIC => "X(10)" 
        NN :ADDRESS2, :PIC => "X(10)" 
        NN :ADDRESS3, :PIC => "X(10)" 
        NN :POSTCODE, :PIC => "X(8)" 
      }
    }  
    PROCEDURE :DIVISION {
      PROC :MAIN_PROCEDURE {
        DISPLAY "What is your name? "
        ACCEPT :NAME
        DISPLAY :CONTEXT
      }
    }

